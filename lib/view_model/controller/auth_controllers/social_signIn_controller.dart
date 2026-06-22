
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plants_spotify/model/model/auth_model/login_user_model.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/app_setting_model.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/services/auth_service.dart';
import 'package:plants_spotify/model/services/globleService.dart';
import 'package:plants_spotify/model/utils/object_extension.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view/widgets/toast_view/showtoast.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


import '../../../model/network_calls/api_helper/provider_helper/auth_provider.dart';
import '../../../model/network_calls/dio_client/get_it_instance.dart';
import "package:flutter/material.dart";

import '../../routes/app_pages.dart';


class SocialSignInController extends BaseViewController {
  AuthProvider authProvider = getIt();

  final GoogleSignIn googleSignIn = GoogleSignIn.instance;



  @override
  void onInit() {
    super.onInit();
    getAppVersions();
  }

  /// force update
  RxBool isValidVersion = true.obs;
  Rx<SingleResponse<AppSettingModel>> appSettingData = SingleResponse<AppSettingModel>(data: AppSettingModel()).obs;
  Future getAppVersions() async {
    try {
      await authProvider.getAppVersions(onError: (errorMessage) {
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        appSettingData.value = SingleResponse<AppSettingModel>.fromJson(data ?? {}, (data) => AppSettingModel.fromJson(data));
        String currentVersion = await HelperFunction.getAppVersion();
        String? forceVersion = Platform.isIOS
            ? appSettingData.value.data.forceIosVersion
            : appSettingData.value.data.forceAndroidVersion;
        if (forceVersion != null && HelperFunction.isVersionLessThan(currentVersion, forceVersion)) {
          isValidVersion.value = false;
        } else {
          isValidVersion.value = true;
        }
      });
    } catch (e) {
      ("error ${e.toString()}").logPrint();
    }
  }

  VoidCallback get onAppleLoginPressed => () {
    apple();
  };


  Future<void> google() async {
    try {
      googleSignIn.initialize(serverClientId: dotenv.env['Google_sign_server_client_id']);
      final GoogleSignInAccount? account = await googleSignIn.authenticate();

      if (account == null) return;

      final GoogleSignInAuthentication auth =
          account.authentication;
      apiSocialLogin(email: account.email, name: account.displayName??"", provider: 'google', providerID: account.id??"", identityToken: account.authentication.idToken??"");

    } catch (e) {
      toastShow(
        message: 'Things seem quiet here. Please try again',
        error: true,
      );
      e.printLog(message: 'Google Sign-In error: ');
      print( 'Google Sign-In error: $e');

    }
  }

  /// Apple login
  Future<void> apple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final appleUserId = credential.userIdentifier;

      apiSocialLogin(
        email: credential.email ?? "",
        name: credential.givenName ?? credential.familyName ?? "",
        provider: "apple",
        identityToken: credential.identityToken??"",
        providerID: appleUserId ?? "",
      );

    } catch (e) {
      e.printLog(message: 'Apple Sign-In error: ');
    }
  }


  void apiSocialLogin({required String email, required String name, required String provider,required String providerID,required String identityToken})async{

    try {
      String firebaseToken = await Get.find<GlobalService>().getFireBaseToken();
      Map<String,String> sociaLoginData ={
        "provider": provider,
        "provider_id": providerID,
        "email": email,
        "name": name,
        "identityToken":identityToken,
        "device_id": firebaseToken,
        "device_type":Platform.isAndroid ? "android" : "ios",
      };
      print(firebaseToken);
      await authProvider.socialLogin(sociaLoginData, onError: (errorMessage) {
        
        ("errorMessage=> $errorMessage").logPrint();
        toastShow(message: errorMessage??"", error: true);
        isLoading.call(false);
      }, onSuccess: (message, data) async {
        SingleResponse<User> loginModel = SingleResponse<User>.fromJson(data??{},(data)=>User.fromJson(data));
        if (loginModel.status == true) {
          toastShow(message: loginModel.message??"", error: false);
          await Get.find<AuthService>().saveUser(loginModel.data.toJson()??{});
          await Get.find<AuthService>().saveUserToken(loginModel.token??"");
          await Get.find<AuthService>().saveFcmToken(firebaseToken);
          Get.offAllNamed(Routes.rootView);
          isLoading.call(false);
        } else {

          isLoading.call(false);
        }
      });
    } catch (e) {
      ("this is login try error ${e.toString()}").logPrint();
      isLoading.call(false);
    }

  }
}

