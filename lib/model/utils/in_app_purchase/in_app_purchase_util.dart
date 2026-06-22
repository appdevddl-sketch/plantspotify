  import 'dart:async';
  import 'dart:io';

  import 'package:get/get.dart';
  import 'package:get_storage/get_storage.dart';
  import 'package:in_app_purchase/in_app_purchase.dart';
  import 'package:in_app_purchase_android/in_app_purchase_android.dart';
  import 'package:in_app_purchase_android/billing_client_wrappers.dart';
  import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
  import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
  import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/account_option_provider.dart';
  import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
  import 'package:plants_spotify/model/network_calls/dio_client/get_it_instance.dart';
  import 'package:plants_spotify/model/services/auth_service.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:plants_spotify/model/utils/color_resource.dart';
  import 'package:plants_spotify/model/utils/string_resource.dart';
  import 'package:plants_spotify/view/widgets/loader_helper/loader_helper_ui.dart';
  import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
  import 'package:plants_spotify/view/widgets/toast_view/showtoast.dart';
  import 'package:plants_spotify/view_model/routes/app_pages.dart';
  import 'package:url_launcher/url_launcher.dart';

  import 'in_app_product_model.dart';

  class InAppPurchaseUtils extends GetxController with WidgetsBindingObserver {

    AccountOptionProvider accountOptionProvider = getIt();
    late StreamSubscription<List<PurchaseDetails>> _purchasesSubscription;

    /// Completer used to wait for app resume after opening external subscription management.
    Completer<void>? _resumeCompleter;

    /// List of available products
    RxList<IapProductModel> availableProducts = <IapProductModel>[].obs;
    RxInt subId = 0.obs;

    /// Whether a purchase is currently in progress (used for UI loader).
    RxBool isPurchasing = false.obs;

    /// iOS: The product ID we are currently trying to purchase.
    /// Used to detect if the purchase stream delivered the expected event.
    String? _pendingProductId;

    /// iOS: The product ID of the last completed buy attempt.
    /// Kept for 30 seconds after state reset so late-arriving stream events
    /// can still be submitted (StoreKit sometimes delivers with a delay).
    String? _recentlyAttemptedProductId;
    DateTime? _recentAttemptTime;

    /// iOS: Completer that resolves when the purchase stream delivers
    /// the expected product event. If the stream doesn't deliver within
    /// the timeout, the buy method falls back to querying the SK queue.
    Completer<bool>? _iosStreamCompleter;

    /// Tracks purchase IDs already submitted to the API to prevent duplicate calls.
    /// Persisted to GetStorage so it survives app restarts.
    final Set<String> _processedPurchaseIds = {};

    /// Maps product IDs to plan IDs so redelivered transactions
    /// (after app restart) can still send the correct plan_id to the backend.
    /// Persisted to GetStorage.
    final Map<String, int> _productToPlanMap = {};

    /// Serializes purchase processing to prevent race conditions from concurrent stream events.
    bool _isProcessingPurchases = false;
    List<PurchaseDetails> _pendingPurchaseQueue = [];

    final GetStorage _storage = GetStorage();

    @override
    void onInit() {
      super.onInit();
      WidgetsBinding.instance.addObserver(this);
      _loadPersistedData();
      initialize();
    }

    // Private constructor
    InAppPurchaseUtils._();

    // Singleton instance
    static final InAppPurchaseUtils _instance = InAppPurchaseUtils._();

    // Getter to access the instance
    static InAppPurchaseUtils get instance => _instance;

    // Create a private variable
    final InAppPurchase _iap = InAppPurchase.instance;

    // ──────────────────────────────────────────────
    // Persisted Data
    // ──────────────────────────────────────────────

    void _loadPersistedData() {
      final List<dynamic>? savedIds = _storage.read(StringResource.instance.processedPurchaseIds);
      if (savedIds != null) {
        _processedPurchaseIds.addAll(savedIds.cast<String>());
      }

      final Map<String, dynamic>? savedMap = _storage.read(StringResource.instance.pendingPurchasePlanMap);
      if (savedMap != null) {
        savedMap.forEach((key, value) {
          _productToPlanMap[key] = value as int;
        });
      }
    }

    void _saveProcessedPurchaseIds() {
      if (_processedPurchaseIds.length > 100) {
        final trimmed = _processedPurchaseIds.toList().sublist(_processedPurchaseIds.length - 100);
        _processedPurchaseIds.clear();
        _processedPurchaseIds.addAll(trimmed);
      }
      _storage.write(StringResource.instance.processedPurchaseIds, _processedPurchaseIds.toList());
    }

    void _saveProductToPlanMap() {
      _storage.write(StringResource.instance.pendingPurchasePlanMap, _productToPlanMap);
    }

    void _savePlanMapping(int planId, String productId) {
      _productToPlanMap[productId] = planId;
      _saveProductToPlanMap();
    }

    int _getPlanIdForProduct(String productId) {
      return _productToPlanMap[productId] ?? subId.value;
    }

    // ──────────────────────────────────────────────
    // Initialization
    // ──────────────────────────────────────────────

    Future<void> initialize() async {
      if (!(await _iap.isAvailable())) return;

      _purchasesSubscription = InAppPurchase.instance.purchaseStream.listen(
        (List<PurchaseDetails> purchaseDetailsList) {
          _handlePurchaseUpdates(purchaseDetailsList);
        },
        onDone: () {
          _purchasesSubscription.cancel();
        },
        onError: (error) {
          ('purchaseStream error: $error').logPrint;
        },
      );

      await _clearPendingPurchases();
    }

    // ──────────────────────────────────────────────
    // Clear Pending Purchases — Platform-specific
    // ──────────────────────────────────────────────

    Future<void> _clearPendingPurchases() async {
      try {
        if (Platform.isAndroid) {
          await _clearPendingPurchasesAndroid();
        } else if (Platform.isIOS) {
          await _clearPendingPurchasesIOS();
        }
      } catch (e) {
        ('Error clearing pending purchases: $e').logPrint;
      }
    }

    /// Android: Query past purchases. Submit unverified ones to backend, then consume.
    Future<void> _clearPendingPurchasesAndroid() async {
      final InAppPurchaseAndroidPlatformAddition androidAddition =
          _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final purchases = await androidAddition.queryPastPurchases();
      for (final purchase in purchases.pastPurchases) {
        ('Found past purchase: ${purchase.productID}, status: ${purchase.status}').logPrint;

        if (purchase.status == PurchaseStatus.purchased) {
          final purchaseId = purchase.purchaseID ?? '';
          if (purchaseId.isNotEmpty && _processedPurchaseIds.contains(purchaseId)) {
            try {
              final result = await androidAddition.consumePurchase(purchase);
              ('Consumed verified ${purchase.productID}: responseCode=${result.responseCode}').logPrint;
            } catch (e) {
              ('Failed to consume ${purchase.productID}: $e').logPrint;
            }
            continue;
          }

          ('Past purchase ${purchase.productID} not yet verified, submitting to API').logPrint;
          final apiSuccess = await _submitPurchaseToBackend(purchase);
          if (apiSuccess) {
            try {
              final result = await androidAddition.consumePurchase(purchase);
              ('Consumed after API verify ${purchase.productID}: responseCode=${result.responseCode}').logPrint;
            } catch (e) {
              ('Failed to consume ${purchase.productID}: $e').logPrint;
            }
          }
        }
      }
    }

    /// iOS: Clean the entire SK payment queue at startup.
    /// - Failed → finish immediately
    /// - Already-processed → finish immediately
    /// - Unverified purchased/restored → submit to backend, then finish
    /// This prevents old transactions from flooding the purchase stream.
    Future<void> _clearPendingPurchasesIOS() async {
      final skQueue = SKPaymentQueueWrapper();
      final transactions = await skQueue.transactions();
      ('iOS cleanup: Found ${transactions.length} transactions in SK queue').logPrint;

      PurchaseVerificationData? cachedReceipt;

      for (final txn in transactions) {
        final pid = txn.payment.productIdentifier;
        final tid = txn.transactionIdentifier ?? '';
        final state = txn.transactionState;

        // Failed → finish immediately
        if (state == SKPaymentTransactionStateWrapper.failed) {
          try { await skQueue.finishTransaction(txn); } catch (_) {}
          ('iOS cleanup: finished failed $pid').logPrint;
          continue;
        }

        // Purchased or Restored
        if (state == SKPaymentTransactionStateWrapper.purchased ||
            state == SKPaymentTransactionStateWrapper.restored) {

          // Already processed → finish immediately
          if (tid.isNotEmpty && _processedPurchaseIds.contains(tid)) {
            try { await skQueue.finishTransaction(txn); } catch (_) {}
            ('iOS cleanup: finished processed $pid ($tid)').logPrint;
            continue;
          }

          // Unverified → submit to backend first, then finish
          cachedReceipt ??= await _iap
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>()
              .refreshPurchaseVerificationData();
          if (cachedReceipt == null) continue;

          final ok = await _submitSkTransactionToBackend(txn, cachedReceipt);
          if (ok) {
            try { await skQueue.finishTransaction(txn); } catch (_) {}
            ('iOS cleanup: submitted & finished $pid ($tid)').logPrint;
          }
        }
      }
    }

    // ──────────────────────────────────────────────
    // Purchase Stream Handling
    // ──────────────────────────────────────────────

    void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
      ('handlePurchaseUpdates: ${purchaseDetailsList.length} items').logPrint();
      for (final p in purchaseDetailsList) {
        ('  -> ${p.productID}, status=${p.status}, id=${p.purchaseID}').logPrint();
      }

      if (_isProcessingPurchases) {
        _pendingPurchaseQueue.addAll(purchaseDetailsList);
        return;
      }
      _isProcessingPurchases = true;

      try {
        await _processPurchaseList(purchaseDetailsList);
        while (_pendingPurchaseQueue.isNotEmpty) {
          final queued = List<PurchaseDetails>.from(_pendingPurchaseQueue);
          _pendingPurchaseQueue.clear();
          await _processPurchaseList(queued);
        }
      } finally {
        _isProcessingPurchases = false;

        // On iOS: don't reset isPurchasing if the expected product hasn't
        // arrived yet — the buy method's inline fallback will handle it.
        if (Platform.isIOS && _pendingProductId != null && isPurchasing.value) {
          ('Stream did not deliver $_pendingProductId — buy method will fallback').logPrint();
        } else {
          isPurchasing.value = false;
        }

        ('handlePurchaseUpdates done').logPrint();
      }
    }

    Future<void> _processPurchaseList(List<PurchaseDetails> purchaseDetailsList) async {
      for (final pd in purchaseDetailsList) {
        switch (pd.status) {
          case PurchaseStatus.pending:
            ('purchase pending: ${pd.productID}').logPrint();
            break;

          case PurchaseStatus.error:
            ('purchase error: ${pd.productID} — ${pd.error?.message}').logPrint();
            toastShow(message: "purchase_failed".tr, error: true);
            _notifyIosStreamIfMatch(pd.productID);
            await _completePurchaseSafely(pd);
            break;

          case PurchaseStatus.canceled:
            ('purchase canceled: ${pd.productID}').logPrint();
            toastShow(message: "Purchase cancelled", error: true);
            _notifyIosStreamIfMatch(pd.productID);
            await _completePurchaseSafely(pd);
            break;

          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:
            await _handlePurchasedOrRestored(pd);
            break;
        }
      }
    }

    /// Unified handler for purchased/restored events.
    Future<void> _handlePurchasedOrRestored(PurchaseDetails pd) async {
      final txnId = pd.purchaseID ?? '';
      final isTargetProduct = _pendingProductId != null && pd.productID == _pendingProductId;
      final alreadyProcessed = txnId.isNotEmpty && _processedPurchaseIds.contains(txnId);

      // ── Check if this is a late-arriving event for a recent purchase attempt ──
      // StoreKit sometimes delivers the event AFTER our timeout + state reset.
      final isLateArrival = !isPurchasing.value &&
          _recentlyAttemptedProductId != null &&
          pd.productID == _recentlyAttemptedProductId &&
          _recentAttemptTime != null &&
          DateTime.now().difference(_recentAttemptTime!).inSeconds < 30;

      if (isLateArrival && !alreadyProcessed) {
        ('${pd.status} — LATE ARRIVAL for recent attempt ${pd.productID} ($txnId) — submitting to API').logPrint();
        _recentlyAttemptedProductId = null;
        _recentAttemptTime = null;
        try { _showLoader(); } catch (_) {}
        final apiSuccess = await _submitPurchaseToBackend(pd, forceSubmit: true);
        if (apiSuccess) {
          await _completePurchaseSafely(pd);
        } else {
          _hideLoader();
        }
        return;
      }

      // ── Purchase in progress: ONLY handle the target product ──
      // Everything else (old restores, unprocessed non-target) just gets
      // finished silently to clean the queue — exactly like Android where
      // the stream only delivers the product the user just bought.
      if (isPurchasing.value && !isTargetProduct) {
        ('${pd.status} (${pd.productID}) — not target, finishing silently during active purchase').logPrint();
        await _completePurchaseSafely(pd);
        return;
      }

      // ── No active purchase: skip already-processed background redeliveries ──
      if (alreadyProcessed) {
        ('${pd.status} (background, processed $txnId) — completing silently').logPrint();
        await _completePurchaseSafely(pd);
        return;
      }

      // ── Target product or unprocessed transaction (no active purchase) — submit ──
      if (isTargetProduct) {
        ('${pd.status} — target product ${pd.productID} delivered via stream').logPrint();
        try { _showLoader(); } catch (_) {}
      } else {
        ('${pd.status} — unprocessed ${pd.productID} ($txnId), submitting').logPrint();
      }

      final apiSuccess = await _submitPurchaseToBackend(pd, forceSubmit: isTargetProduct);

      if (apiSuccess) {
        await _completePurchaseSafely(pd);
      } else {
        if (isPurchasing.value) _hideLoader();
      }

      // Notify the buy method that the stream handled the target product
      if (isTargetProduct) {
        _notifyIosStreamIfMatch(pd.productID);
      }
    }

    /// If this product matches what we're waiting for on iOS,
    /// complete the stream completer so the buy method knows.
    void _notifyIosStreamIfMatch(String productId) {
      if (_pendingProductId != null && productId == _pendingProductId) {
        _pendingProductId = null;
        if (_iosStreamCompleter != null && !_iosStreamCompleter!.isCompleted) {
          _iosStreamCompleter!.complete(true);
        }
      }
    }

    // ──────────────────────────────────────────────
    // Complete Purchase — Platform-specific
    // ──────────────────────────────────────────────

    Future<void> _completePurchaseSafely(PurchaseDetails purchaseDetails) async {
      try {
        if (Platform.isAndroid) {
          // Consume the purchase so consumable products (e.g. scan packs)
          // can be bought again. For non-consumables this is harmless.
          final InAppPurchaseAndroidPlatformAddition androidAddition =
              _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
          final result = await androidAddition.consumePurchase(purchaseDetails);
          ('Purchase consumed (Android) for ${purchaseDetails.productID}: responseCode=${result.responseCode}').logPrint;
        } else if (Platform.isIOS) {
          // iOS: Always call completePurchase to finish the SK transaction.
          await _iap.completePurchase(purchaseDetails);
          ('Purchase completed (iOS) for ${purchaseDetails.productID}').logPrint;
        }
      } catch (e) {
        ('Failed to complete purchase: $e').logPrint;
      }
    }

    // ──────────────────────────────────────────────
    // Fetch Products
    // ──────────────────────────────────────────────

    Future<void> fetchProducts(Set<String> productIds) async {
      final response = await _iap.queryProductDetails(productIds);

      if (response.notFoundIDs.isNotEmpty) {
        ("Products not found: ${response.notFoundIDs}").logPrint();
      }

      availableProducts.value = response.productDetails
          .map((p) => IapProductModel.fromProductDetails(p))
          .toList();
    }

    // ──────────────────────────────────────────────
    // Buy Products
    // ──────────────────────────────────────────────
    //
    // Android: straightforward — buy → stream delivers → submit → done.
    // iOS:     buy → stream MAY deliver old restores instead.
    //          After buy returns, wait up to 5s for stream to deliver
    //          the expected product. If it doesn't, query SK queue
    //          directly and submit the receipt. Same result, same speed.
    // ──────────────────────────────────────────────

    Future<void> buyNonConsumableProduct(int id, String productId) async {
      isPurchasing.value = true;

      try {
        subId.value = id;
        _savePlanMapping(id, productId);

        _pendingProductId = productId;
        if (Platform.isIOS) {
          _iosStreamCompleter = Completer<bool>();
          // Brief delay to let the stream flush old restored transactions
          await Future.delayed(const Duration(milliseconds: 500));
        }

        final response = await _iap.queryProductDetails({productId});
        if (response.notFoundIDs.isNotEmpty) {
          ("Product not found: $productId").logPrint();
          toastShow(message: "product_not_found".tr, error: true);
          _resetPurchaseState();
          return;
        }

        final product = response.productDetails.first;
        final purchaseParam = PurchaseParam(productDetails: product);

        ('buyNonConsumable initiated for $productId').logPrint();
        await _iap.buyNonConsumable(purchaseParam: purchaseParam);
        ('buyNonConsumable returned for $productId').logPrint();

        // iOS: wait for stream or fallback to SK queue
        if (Platform.isIOS) {
          await _iosWaitOrFallback(productId);
        }
      } catch (e) {
        ("Failed to buy non-consumable: $e").logPrint();
        if (Platform.isAndroid) {
          toastShow(message: "purchase_failed".tr, error: true);
          _resetPurchaseState();
        } else if (_isIosUserCancellation(e)) {
          // User dismissed the purchase sheet — reset immediately
          ('iOS: user cancelled purchase').logPrint();
          _resetPurchaseState();
        } else {
          // iOS: StoreKit can throw even on success — check SK queue
          await _iosWaitOrFallback(productId);
        }
      }
    }

    Future<void> buyConsumableProduct(int id, String productId) async {
      isPurchasing.value = true;

      try {
        subId.value = id;
        _savePlanMapping(id, productId);

        _pendingProductId = productId;
        if (Platform.isIOS) {
          _iosStreamCompleter = Completer<bool>();
          await Future.delayed(const Duration(milliseconds: 500));
        }

        final response = await _iap.queryProductDetails({productId});
        if (response.notFoundIDs.isNotEmpty) {
          ("Product not found: $productId").logPrint();
          toastShow(message: "product_not_found".tr, error: true);
          _resetPurchaseState();
          return;
        }

        final product = response.productDetails.first;
        final purchaseParam = PurchaseParam(productDetails: product);

        // iOS: must be autoConsume true (StoreKit asserts it).
        // Android: false so we control consumption after backend verification.
        await _iap.buyConsumable(
          purchaseParam: purchaseParam,
          autoConsume: Platform.isIOS ? true : false,
        );

        if (Platform.isIOS) {
          await _iosWaitOrFallback(productId);
        }
      } catch (e) {
        ("Failed to buy consumable: $e").logPrint();
        if (Platform.isAndroid) {
          toastShow(message: "purchase_failed".tr, error: true);
          _resetPurchaseState();
        } else if (_isIosUserCancellation(e)) {
          ('iOS: user cancelled purchase').logPrint();
          _resetPurchaseState();
        } else {
          await _iosWaitOrFallback(productId);
        }
      }
    }

    /// Resets all purchase-related state.
    void _resetPurchaseState() {
      isPurchasing.value = false;
      _pendingProductId = null;
      _iosStreamCompleter = null;
    }

    /// Detects if an iOS StoreKit exception is a user cancellation.
    /// StoreKit throws PlatformException with various error codes/messages
    /// when the user dismisses the purchase sheet.
    bool _isIosUserCancellation(dynamic error) {
      if (!Platform.isIOS) return false;
      final msg = error.toString().toLowerCase();
      return msg.contains('cancel') ||
             msg.contains('payment not allowed') ||
             msg.contains('skError') && msg.contains('2') || // SKErrorPaymentCancelled = 2
             msg.contains('user cancelled');
    }

    // ──────────────────────────────────────────────
    // iOS: Wait for Stream or Fallback to SK Queue
    // ──────────────────────────────────────────────
    //
    // This is the key difference from Android. After buyNonConsumable
    // returns on iOS, we give the purchase stream 5 seconds to deliver
    // the expected product event. If it does → great, already handled.
    // If not → query the SK payment queue directly, find the transaction,
    // fetch the receipt, and submit to the backend ourselves.
    // ──────────────────────────────────────────────

    Future<void> _iosWaitOrFallback(String productId) async {
      if (_iosStreamCompleter == null) {
        _resetPurchaseState();
        return;
      }

      // Wait up to 10 seconds for the stream to deliver the target product.
      // iOS sandbox can take 5-15 seconds to deliver subscription events.
      bool handledByStream = false;
      try {
        handledByStream = await _iosStreamCompleter!.future
            .timeout(const Duration(seconds: 10), onTimeout: () => false);
      } catch (_) {}

      if (handledByStream) {
        ('iOS: stream delivered $productId — no fallback needed').logPrint();
        _resetPurchaseState();
        return;
      }

      // Stream didn't deliver in 10s — check SK queue.
      ('iOS fallback: stream missed $productId, checking SK queue').logPrint();

      try {
        _showLoader();
        var foundInQueue = await _submitViaSkQueue(productId);

        // If not found, wait 5 more seconds and retry SK queue once.
        // StoreKit sometimes takes extra time to populate the queue.
        if (!foundInQueue) {
          ('iOS fallback: not in queue yet, waiting 5s and retrying...').logPrint();
          // Also check if stream delivers during this wait
          try {
            handledByStream = await _iosStreamCompleter!.future
                .timeout(const Duration(seconds: 5), onTimeout: () => false);
          } catch (_) {}

          if (handledByStream) {
            ('iOS: stream delivered $productId during retry wait').logPrint();
            _hideLoader();
            _resetPurchaseState();
            return;
          }

          foundInQueue = await _submitViaSkQueue(productId);
        }

        if (!foundInQueue) {
          _hideLoader();
          ('iOS fallback: $productId not found after retry — saving for late stream events').logPrint();
          _recentlyAttemptedProductId = productId;
          _recentAttemptTime = DateTime.now();
        }
      } catch (e) {
        _hideLoader();
        ('iOS fallback failed: $e').logPrint();
        toastShow(message: "purchase_failed".tr, error: true);
      } finally {
        _resetPurchaseState();
      }
    }

    /// Queries the SK payment queue for a transaction matching [productId],
    /// fetches the receipt, submits to the backend, and finishes the transaction.
    /// Also cleans up old already-processed transactions while scanning.
    /// Returns true if the target transaction was found in the queue.
    Future<bool> _submitViaSkQueue(String productId) async {
      final skQueue = SKPaymentQueueWrapper();
      SKPaymentTransactionWrapper? matchingTxn;
      String transactionId = '';

      try {
        final transactions = await skQueue.transactions();
        for (final txn in transactions) {
          final pid = txn.payment.productIdentifier;
          final tid = txn.transactionIdentifier ?? '';
          final state = txn.transactionState;

          ('iOS fallback — queue txn: $pid, state: $state, id: $tid').logPrint();

          // Clean up failed transactions
          if (state == SKPaymentTransactionStateWrapper.failed) {
            try { await skQueue.finishTransaction(txn); } catch (_) {}
            continue;
          }

          // Clean up already-processed transactions
          if ((state == SKPaymentTransactionStateWrapper.purchased ||
               state == SKPaymentTransactionStateWrapper.restored) &&
              tid.isNotEmpty && _processedPurchaseIds.contains(tid)) {
            try { await skQueue.finishTransaction(txn); } catch (_) {}
            continue;
          }

          // Match our target product
          if (pid == productId && matchingTxn == null &&
              (state == SKPaymentTransactionStateWrapper.purchased ||
               state == SKPaymentTransactionStateWrapper.restored)) {
            transactionId = tid;
            matchingTxn = txn;
          }
        }
      } catch (e) {
        ('iOS fallback — failed to query SK queue: $e').logPrint();
      }

      if (matchingTxn == null) {
        ('iOS fallback — no matching txn for $productId in SK queue').logPrint();
        return false;
      }

      if (transactionId.isEmpty) transactionId = productId;

      // Fetch receipt and submit
      final iosAdd = _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      final receipt = await iosAdd.refreshPurchaseVerificationData();
      if (receipt == null) {
        _hideLoader();
        toastShow(message: "purchase_failed".tr, error: true);
        return true; // Was found in queue but receipt failed
      }

      final planId = _getPlanIdForProduct(productId);
      ("iOS fallback submit — plan_id: $planId, product: $productId, txnId: $transactionId").logPrint();

      bool apiSuccess = false;
      await accountOptionProvider.subscriptionPurchase({
        "plan_id": planId,
        "transaction_id": transactionId,
        "platform": "app_store",
        "product_id": productId,
        "purchase_token": receipt.serverVerificationData,
        "receipt_data": receipt.localVerificationData,
      }, onError: (errorMessage) {
        _hideLoader();
        ("iOS fallback error => $errorMessage").logPrint();
        final m = (errorMessage ?? '').toLowerCase();
        if (m.contains('expired') || m.contains('already')) {
          _processedPurchaseIds.add(transactionId);
          _saveProcessedPurchaseIds();
          apiSuccess = true;
        } else {
          toastShow(message: errorMessage ?? "purchase_failed".tr, error: true);
        }
      }, onSuccess: (message, data) {
        _hideLoader();
        BaseResponse response = BaseResponse.fromJson(data ?? {});
        if (response.status == true) {
          apiSuccess = true;
          _processedPurchaseIds.add(transactionId);
          _saveProcessedPurchaseIds();
          toastShow(message: "Purchase successful".tr, error: false);
          Get.offAllNamed(Routes.rootView);
        } else {
          final m = (response.message ?? '').toLowerCase();
          if (m.contains('expired') || m.contains('already')) {
            _processedPurchaseIds.add(transactionId);
            _saveProcessedPurchaseIds();
            apiSuccess = true;
          } else {
            toastShow(message: response.message ?? "purchase_failed".tr, error: true);
          }
        }
      });

      if (apiSuccess && matchingTxn != null) {
        try {
          await skQueue.finishTransaction(matchingTxn);
          ('iOS fallback — finished txn $transactionId').logPrint();
        } catch (e) {
          ('iOS fallback — failed to finish: $e').logPrint;
        }
      }

      return true; // Transaction was found in queue
    }

    /// Submits a raw SK transaction to the backend using a pre-fetched receipt.
    /// Used during startup cleanup.
    Future<bool> _submitSkTransactionToBackend(
        SKPaymentTransactionWrapper txn, PurchaseVerificationData receipt) async {
      try {
        final pid = txn.payment.productIdentifier;
        final tid = txn.transactionIdentifier ?? pid;
        final planId = _getPlanIdForProduct(pid);

        bool success = false;
        await accountOptionProvider.subscriptionPurchase({
          "plan_id": planId, "transaction_id": tid,
          "platform": "app_store", "product_id": pid,
          "purchase_token": receipt.serverVerificationData,
          "receipt_data": receipt.localVerificationData,
        }, onError: (err) {
          final m = (err ?? '').toLowerCase();
          if (m.contains('expired') || m.contains('already')) {
            _processedPurchaseIds.add(tid); _saveProcessedPurchaseIds();
            success = true;
          }
        }, onSuccess: (msg, data) {
          final r = BaseResponse.fromJson(data ?? {});
          if (r.status == true) {
            _processedPurchaseIds.add(tid); _saveProcessedPurchaseIds();
            success = true;
          } else {
            final m = (r.message ?? '').toLowerCase();
            if (m.contains('expired') || m.contains('already')) {
              _processedPurchaseIds.add(tid); _saveProcessedPurchaseIds();
              success = true;
            }
          }
        });
        return success;
      } catch (_) { return false; }
    }

    // ──────────────────────────────────────────────
    // Restore Purchases
    // ──────────────────────────────────────────────

    restorePurchases() async {
      try {
        await _iap.restorePurchases();
        await _verifySubscriptionAfterRestore();
      } catch (error) {
        ("error: $error").logPrint();
      }
    }

    Future<void> _verifySubscriptionAfterRestore() async {
      try {
        _showLoader();
        await accountOptionProvider.subscriptionVerify(
          onError: (errorMessage) {
            _hideLoader();
            ("subscriptionVerify error => $errorMessage").logPrint();
            toastShow(message: errorMessage ?? "restore_failed".tr, error: true);
          },
          onSuccess: (message, data) {
            _hideLoader();
            BaseResponse response = BaseResponse.fromJson(data ?? {});
            if (response.status == true) {
              toastShow(message: "restore_successful".tr??"", error: false);
              Get.offAllNamed(Routes.rootView);
            } else {
              toastShow(message: response.message ?? "restore_failed".tr, error: true);
            }
          },
        );
      } catch (e) {
        _hideLoader();
        ("subscriptionVerify exception => $e").logPrint();
      }
    }

    // Example method
    void purchaseProduct(String productId) {
      // Implementation for purchasing a product
    }

    // ──────────────────────────────────────────────
    // Cancel / Manage Subscription
    // ──────────────────────────────────────────────

    Future<void> cancelSubscription({String? googleProductId, String? appleProductId}) async {
      try {
        if (Platform.isIOS) {
          await _openIOSSubscriptionManagement(appleProductId: appleProductId);
        } else if (Platform.isAndroid) {
          await _openAndroidSubscriptionManagement(googleProductId: googleProductId);
          await _waitForAppResume();
        }
      } catch (e) {
        ('Error opening subscription management: $e').logPrint;
        toastShow(message: "cancel_subscription_error".tr, error: true);
      }
    }

    static const _subscriptionChannel = MethodChannel('com.plant.spotify/subscription');

    Future<void> _openIOSSubscriptionManagement({String? appleProductId}) async {
      try {
        final result = await _subscriptionChannel.invokeMethod('showManageSubscriptions');
        if (result == true) {
          ('iOS: showManageSubscriptions opened successfully').logPrint;
          return;
        }
        ('iOS: showManageSubscriptions not available, using fallback URL').logPrint;
      } catch (e) {
        ('iOS: Method channel failed: $e, using fallback URL').logPrint;
      }
      final fallbackUrl = Uri.parse('https://apps.apple.com/account/subscriptions');
      if (await canLaunchUrl(fallbackUrl)) {
        await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
        await _waitForAppResume();
      }
    }

    Future<void> _openAndroidSubscriptionManagement({String? googleProductId}) async {
      const packageName = 'com.plant.spotify';
      final Uri deepLink;

      if (googleProductId != null && googleProductId.isNotEmpty) {
        deepLink = Uri.parse(
          'https://play.google.com/store/account/subscriptions?sku=$googleProductId&package=$packageName',
        );
      } else {
        deepLink = Uri.parse(
          'https://play.google.com/store/account/subscriptions?package=$packageName',
        );
      }

      if (await canLaunchUrl(deepLink)) {
        await launchUrl(deepLink, mode: LaunchMode.externalApplication);
      } else {
        toastShow(message: "cancel_subscription_error".tr, error: true);
      }
    }

    @override
    void didChangeAppLifecycleState(AppLifecycleState state) {
      if (state == AppLifecycleState.resumed && _resumeCompleter != null && !_resumeCompleter!.isCompleted) {
        _resumeCompleter!.complete();
      }
    }

    Future<void> _waitForAppResume() async {
      _resumeCompleter = Completer<void>();
      await _resumeCompleter!.future;
      _resumeCompleter = null;
    }

    @override
    void onClose() {
      WidgetsBinding.instance.removeObserver(this);
      _purchasesSubscription.cancel();
      super.onClose();
    }

    // ──────────────────────────────────────────────
    // Submit Purchase to Backend
    // ──────────────────────────────────────────────

    /// Submits purchase data to the backend API.
    /// [forceSubmit] bypasses the duplicate check — used when the purchase
    /// stream delivers the target product the user is actively buying.
    Future<bool> _submitPurchaseToBackend(PurchaseDetails purchaseData, {bool forceSubmit = false}) async {
      final purchaseId = purchaseData.purchaseID ?? '';
      if (!forceSubmit && purchaseId.isNotEmpty && _processedPurchaseIds.contains(purchaseId)) {
        ('Skipping duplicate submit for $purchaseId').logPrint();
        if (isPurchasing.value) _hideLoader();
        return true;
      }

      bool success = false;

      try {
        final planId = _getPlanIdForProduct(purchaseData.productID);

        Map<String, dynamic> purchaseDataBody = {
          "plan_id": planId,
          "transaction_id": purchaseData.purchaseID,
          "platform": Platform.isAndroid ? "play_store" : "app_store",
          "product_id": purchaseData.productID,
          "purchase_token": purchaseData.verificationData.serverVerificationData,
          "receipt_data": purchaseData.verificationData.localVerificationData
        };

        ("submitPurchaseData — plan_id: $planId, product: ${purchaseData.productID}").logPrint();

        await accountOptionProvider.subscriptionPurchase(purchaseDataBody, onError: (errorMessage) {
          if (isPurchasing.value) _hideLoader();
          ("errorMessage=> $errorMessage").logPrint();
          final msg = (errorMessage ?? '').toLowerCase();
          final isPermanentRejection = msg.contains('expired') || msg.contains('already');
          if (isPermanentRejection) {
            if (purchaseId.isNotEmpty) {
              _processedPurchaseIds.add(purchaseId);
              _saveProcessedPurchaseIds();
            }
            success = true;
            ('Permanent rejection — completing to unblock queue: $errorMessage').logPrint;
          } else {
            toastShow(message: errorMessage ?? "", error: true);
            success = false;
          }
        }, onSuccess: (message, data) async {
          if (isPurchasing.value) _hideLoader();
          BaseResponse response = BaseResponse.fromJson(data ?? {});
          if (response.status == true) {
            if (purchaseId.isNotEmpty) {
              _processedPurchaseIds.add(purchaseId);
              _saveProcessedPurchaseIds();
            }
            success = true;
            toastShow(message: "Purchase successful".tr, error: false);
            Get.offAllNamed(Routes.rootView);
          } else {
            final msg = (response.message ?? '').toLowerCase();
            final isPermanentRejection = msg.contains('expired') || msg.contains('already');
            if (isPermanentRejection) {
              if (purchaseId.isNotEmpty) {
                _processedPurchaseIds.add(purchaseId);
                _saveProcessedPurchaseIds();
              }
              success = true;
              ('Permanent rejection — completing to unblock queue: ${response.message}').logPrint;
            } else {
              toastShow(message: response.message ?? "purchase_failed".tr, error: true);
              success = false;
            }
          }
        });
      } catch (e) {
        if (isPurchasing.value) _hideLoader();
        ("submit error: ${e.toString()}").logPrint();
        success = false;
      }

      return success;
    }

    // ──────────────────────────────────────────────
    // UI Helpers
    // ──────────────────────────────────────────────

    void _showLoader() {
      if (Get.isDialogOpen ?? false) return;
      Get.dialog(
        PopScope(
          canPop: false,
          child: Center(child: CircularProgressIndicator(color: ColorResource.instance.btnGreenColor)),
        ),
        barrierDismissible: false,
        barrierColor: Colors.black.withValues(alpha: 0.5),
      );
    }

    void _hideLoader() {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }
