


import 'package:get/get.dart';
import 'package:plants_spotify/model/services/auth_service.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';

class SplashScreenController extends BaseViewController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    final auth = Get.find<AuthService>();
    await Future.delayed(const Duration(seconds: 3));
    Get.offAllNamed(
      auth.isFirst
          ? auth.isLogin
              ? Routes.rootView
              : Routes.socialSignInScreen
          : Routes.onBoardScreen,
    );
  }
}