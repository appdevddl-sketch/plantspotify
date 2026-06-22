import 'dart:convert';

import 'package:get/get.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';

import '../../model/services/auth_service.dart';
import '../routes/app_pages.dart';

class NotificationRedirection {
  static const int _tabHome = 0;
  static const int _tabSearch = 1;
  static const int _tabNursery = 3;

  static notificationRedirectionFromPayload(
      {required String notificationPayload}) {
    try {
      Map<String, dynamic> payload = jsonDecode(notificationPayload);
      (payload).logPrint();

      final bool isLoggedIn = Get.find<AuthService>().isLogin;
      if (!isLoggedIn) return;

      final String linkType = payload["link_type"]?.toString() ?? "";

      switch (linkType) {
        case "home":
          Get.offAllNamed(Routes.rootView);
          break;
        case "trending_plants":
          Get.toNamed(Routes.trendingScreen);
          break;
        case "plant_index":
          Get.toNamed(Routes.plantIndexScreen);
          break;
        case "articles":
          Get.toNamed(Routes.articlesScreen);
          break;
        case "nursery":
          Get.toNamed(Routes.rootView, arguments: {"pageIndex": _tabNursery});
          break;
        case "search":
          Get.toNamed(Routes.searchScreen);
          break;
        case "subscriptions":
          Get.toNamed(Routes.subscriptionScreen);
          break;
        case "scan_history":
          Get.toNamed(Routes.scanHistoryScreen);
          break;
        default:
          ("notification: unhandled link_type => $linkType").logPrint();
          break;
      }
    } catch (e) {
      (e).logPrint();
    }
  }

  static forLogoutNotification({required String notificationPayload}) {
    try {
      Map<String, dynamic> notificationPayloadJson =
          jsonDecode(notificationPayload);
      (notificationPayloadJson).logPrint();
      switch (notificationPayloadJson["link_type"]) {
        case "logout":
          {
            Get.find<AuthService>().logOut();
          }
          break;
        case "force_logout":
          {
            Get.find<AuthService>().logOut();
          }
          break;
        default:
          {
            ("something want wrong").logPrint();
          }
          break;
      }
    } catch (e) {
      (e).logPrint();
    }
  }
}