import 'dart:io';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:plants_spotify/model/model/root_view_models/accountview_models/subscription_model.dart';
import 'package:plants_spotify/model/model/auth_model/login_user_model.dart';
import 'package:plants_spotify/model/model/root_view_models/accountview_models/subscription_verify_model.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/account_option_provider.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/auth_provider.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/network_calls/dio_client/get_it_instance.dart';
import 'package:plants_spotify/model/services/auth_service.dart';
import 'package:plants_spotify/model/utils/in_app_purchase/in_app_purchase_util.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view/widgets/app_common/custom_popup/subscription_cancelled_popup.dart';
import 'package:plants_spotify/view/widgets/button_view/animated_box.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view/widgets/toast_view/showtoast.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/root_view_controller.dart';

class SubscriptionController extends BaseViewController{
  AccountOptionProvider accountOptionProvider = getIt();
  AuthProvider authProvider = getIt();
  final pageController = PageController();
  Rx<int> currentPageIndex =0.obs;



//update curret index when page scroll
  void updtePageIndicator(index) => currentPageIndex.value = index;
  void nextPage(){
    if(currentPageIndex.value == 2){
      // Get.find<AuthService>().box!.write(StringResource.instance.isFirst, true);
      // Get.offAllNamed(Routes.socialSignInScreen);
    }else{
      int page = currentPageIndex.value + 1 ;
      pageController.animateToPage(currentPageIndex.value+1,  curve: Curves.linear, duration: const Duration(milliseconds: 500));
    }

  }

  final RxInt selectedIndex = 0.obs;
  final RxList plansList = ["P","M","M+","Y","L"].obs;

  final CarouselSliderController carouselController =
  CarouselSliderController();

  void onTabSelected(int index) {
    selectedIndex.value = index;


    WidgetsBinding.instance.addPostFrameCallback((_) {
      carouselController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void onCarouselChanged(int index) {
    selectedIndex.value = index;
  }




  RxList<SubscriptionData> subscriptionList = <SubscriptionData>[].obs;
  ///get predefine collection
  Future getPredefineCollection() async {
    try {
      await accountOptionProvider.getSubscriptionPlans(
        onError: (errorMessage) {
          
          ("errorMessage => $errorMessage").logPrint();
        },
        onSuccess: (message, data) {
          final response = ListResponse<SubscriptionData>.fromJson(data ?? {}, (e) => SubscriptionData.fromJson(e),);
          subscriptionList.value = response.data;
        },
      );
    } catch (e) {
      ("error ${e.toString()}").logPrint();
      isLoading(false);
    }
  }
  /// Whether the user has accepted the Terms of Use & Privacy Policy.
  RxBool isTermsAccepted = false.obs;

  /// Local guard to block multiple taps on the continue/purchase button.
  /// Stays true from tap until the buy method fully returns.
  RxBool isPurchaseInProgress = false.obs;

  Future subscriptionPurchase() async {
    // Require terms acceptance before proceeding
    if (!isTermsAccepted.value) {
      toastShow(message: "please_accept_terms".tr, error: true);
      return;
    }
    // Prevent double-tap while purchase is in progress
    if (isPurchaseInProgress.value) return;
    final iapUtils = Get.find<InAppPurchaseUtils>();

    var user = Get.find<AuthService>().user.value;

    if(user.isPremium == true  && user.currentActiveSubscription?.isAutoRenewing == true && user.currentActiveSubscription?.plan?.type?.toLowerCase() == "subscription"){
      toastShow(message: "already_active_subscription".tr, error: false);
      return ;
    }else if(user.isPremium == true && user.currentActiveSubscription?.isAutoRenewing == false && user.currentActiveSubscription?.plan?.type?.toLowerCase() == "timed_premium"){
      toastShow(message: "already_subscribed_plan".tr, error: false);
      return ;
    }
    else if(user.isPremium == true && user.currentActiveSubscription?.plan?.name?.toLowerCase() == "yearly" && subscriptionList[selectedIndex.value].name?.toLowerCase() == "monthly"  && user.currentActiveSubscription?.plan?.type?.toLowerCase() == "subscription"){
      toastShow(message: "cant_downgrade_plan".tr, error: false);
      return ;
    }
    final selected = subscriptionList[selectedIndex.value];
    final isConsumable = selected.type?.toLowerCase() == "consumable" || selected.type?.toLowerCase() == "timed_premium";
    ("Purchase type: '${selected.type}', isConsumable: $isConsumable, productId: ${Platform.isAndroid ? selected.googleProductId : selected.appleProductId}").logPrint();

    isPurchaseInProgress.value = true;
    try {
      if(Platform.isAndroid){
        isConsumable ?
        await iapUtils.buyConsumableProduct(selected.id??0, selected.googleProductId??"") :
        await iapUtils.buyNonConsumableProduct(selected.id??0, selected.googleProductId??"");
      }else{
        isConsumable ?
        await iapUtils.buyConsumableProduct(selected.id??0, selected.appleProductId??"") :
        await iapUtils.buyNonConsumableProduct(selected.id??0, selected.appleProductId??"");
      }
    } finally {
      isPurchaseInProgress.value = false;
    }
  }
  Future restorePurchase() async {
    // _showCancellationDialog(isError: true);
      await Get.find<InAppPurchaseUtils>().restorePurchases();
  }


  Future cancelSubscription() async {
    final user = Get.find<AuthService>().user.value;
    final subscription = user.currentActiveSubscription;

    if (subscription == null || user.isPremium != true) {
      toastShow(message: "no_active_subscription".tr, error: true);
      return;
    }

    // Find the matching plan to get product IDs
    String? googleProductId;
    String? appleProductId;
    for (final plan in subscriptionList) {
      if (plan.id == subscription.plan?.id) {
        googleProductId = plan.googleProductId;
        appleProductId = plan.appleProductId;
        break;
      }
    }

    await Get.find<InAppPurchaseUtils>().cancelSubscription(
      googleProductId: googleProductId,
      appleProductId: appleProductId,
    ).then((_) async {
      // Refresh user profile after returning from subscription management
      // to reflect any changes (e.g., subscription cancelled)
      await checkSubscriptionUpdate();
      Get.find<RootViewController>().getUserProfile();
    });
  }
  Rx<SingleResponse<SubscriptionVerifyModal>> subscriptionVerifyData = SingleResponse<SubscriptionVerifyModal>(data: SubscriptionVerifyModal()).obs;

  Future checkSubscriptionUpdate() async {
    try {
      await accountOptionProvider.subscriptionVerify(
        onError: (errorMessage) {
          
          ("errorMessage => $errorMessage").logPrint();
        },
        onSuccess: (message, data) {
          subscriptionVerifyData.value = SingleResponse<SubscriptionVerifyModal>.fromJson(data ?? {}, (data) => SubscriptionVerifyModal.fromJson(data));
          if(subscriptionVerifyData.value.data.currentStatus?.toLowerCase() == "cancelled"){
            _showCancellationDialog(isError: false);
          }else if(subscriptionVerifyData.value.data.currentStatus?.toLowerCase() == "active"){
            _showCancellationDialog(isError: true);
          }
        },
      );
    } catch (e) {
      ("error ${e.toString()}").logPrint();
      _showCancellationDialog(isError: true);
      isLoading(false);
    }
  }



  /// Shows the subscription cancellation result dialog.
  void _showCancellationDialog({required bool isError, String? message}) {
    if (Get.context != null) {
      showAnimatedDialog(
        Get.context!,
        SubscriptionCancelledPopup(
          isError: isError,
          message: message,
          onDismiss: () {
            // Refresh the subscription screen UI
            update();
          },
        ),
        dismissible: true,
      );
    }
  }



  @override
  void onInit() async{
    // TODO: implement onInit
    await getPredefineCollection();
    super.onInit();
  }

}

