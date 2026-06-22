import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plants_spotify/model/model/auth_model/ip_model.dart';
import 'package:plants_spotify/model/model/auth_model/login_user_model.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/home_controller.dart';
import '../../view_model/routes/app_pages.dart';
import '../network_calls/dio_client/dio_client.dart';
import '../network_calls/dio_client/get_it_instance.dart';
import '../utils/string_resource.dart';

class AuthService extends GetxService {
  Rx<User> user = User().obs;
  Rx<UserIp> userIp = UserIp().obs;

  GetStorage? box;
  RxString firebaseToken = "".obs;
  Future<AuthService> init() async {
    box = GetStorage();
    getCurrentUserData();
    getCurrentUserIpData();
    getFcmToken();
    // await setMapApiKeyToChannel();
    return this;
  }

  saveUser(Map<String, dynamic> map) async {
    await box?.write(StringResource.instance.currentUser, map);
    user.value = User.fromJson(map);
    getCurrentUserData();
  }
  saveUserIp(Map<String, dynamic> map) async {
    await box?.write(StringResource.instance.currentUserIp, map);
    userIp.value = UserIp.fromJson(map);
    getCurrentUserIpData();
  }

  Future<User> getCurrentUserData() async {
    if (box?.hasData(StringResource.instance.currentUser) ?? false) {
      ("user data box =>${box?.read(StringResource.instance.currentUser)}").logPrint();
      try {
        user.value = User.fromJson(box?.read(StringResource.instance.currentUser));
        (user.value.name)?.logPrint();
        return user.value;
      } catch (e) {
        ("User Data Error =>$e").logPrint();
        return user.value;
      }
    } else {
      user.value = User();
      return user.value;
    }
  }

  Future<UserIp> getCurrentUserIpData() async {
    if (box?.hasData(StringResource.instance.currentUserIp) ?? false) {
      ("user data box =>${box?.read(StringResource.instance.currentUserIp)}").logPrint();
      try {
        userIp.value = UserIp.fromJson(box?.read(StringResource.instance.currentUserIp));
        (userIp.value.city)?.logPrint();
        return userIp.value;
      } catch (e) {
        ("User Data Error =>$e").logPrint();
        return userIp.value;
      }
    } else {
      userIp.value = userIp();
      return userIp.value;
    }
  }

  Future<void> saveUserToken(String token) async {
    final DioClient dioClient = getIt();
    dioClient.token = token;
    dioClient.dio.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
    dioClient.dio.options.headers.logPrint();
    try {
      await box?.write(StringResource.instance.token, token);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeUserData() async {
    user.value = User();
    await box?.remove(StringResource.instance.currentUser);
  }


  Future<void> removeToken() async {
    await box?.remove(StringResource.instance.token);
  }



  Future<void> logOut() async {
    try {
      await removeUserData();
      await removeToken();
      Get.delete<HomeController>();
      DioClient dio = getIt();
      dio.dio.options.headers = {
        'Content-Type': 'application/json',
      };
    } catch (_) {}

    Get.offAllNamed(Routes.socialSignInScreen);
  }


  String getUserToken() {
    return box?.read(StringResource.instance.token) ?? "";
  }

  Locale getUserLocale() {
    try {
      return Locale(box?.read(StringResource.instance.selectedLocaleKey)??'en_US');
    } catch (e) {
      rethrow;
    }
  }


  Future<void> saveUserLocale(String local) async {
    try {
      await box?.write(StringResource.instance.selectedLocaleKey, local);
    } catch (e) {
      rethrow;
    }
  }
  Future<void> saveIsNotificationShow(bool value) async {
    try {
      await box?.write(StringResource.instance.isNotification, value);
    } catch (e) {
      rethrow;
    }
  }
  Future<bool> getIsNotificationShow() async{
    try {
      return box?.read(StringResource.instance.isNotification)??true;
    } catch (e) {
      rethrow;
    }
  }
  String getCurrencySymbol() {
    try {
      return box?.read(StringResource.instance.currencySymbol) ?? "د.ل";
    } catch (e) {
      rethrow;
    }
  }


  Future<void> saveCurrencySymbol(String symbol) async {
    try {
      await box?.write(StringResource.instance.currencySymbol, symbol);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getFcmToken() async {
    String token = await box?.read(StringResource.instance.fcmToken)??"";
    token.logPrint(message: "Token is ");
    firebaseToken.value = token;
    return token;
  }

  Future saveFcmToken(String token) async {
    await box?.write(StringResource.instance.fcmToken, token);
    firebaseToken.value = token;
  }
  Future setMapApiKeyToChannel() async {
    try {
      const platform = MethodChannel('map_key');
      await platform.invokeMethod('setMapKey', {'key': dotenv.env["GOOGLE_MAP_API_KEY"]??""});
    } on PlatformException catch (e) {
      ("Failed to set secure flag: ${e.message}").logPrint();
    }
  }

  bool get isFirst => box?.read(StringResource.instance.isFirst) ?? false;
  bool get isLogin => box?.hasData(StringResource.instance.currentUser) ?? false;
}

