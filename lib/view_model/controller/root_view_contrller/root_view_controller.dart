import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/model/auth_model/app_versions_model.dart';
import 'package:plants_spotify/model/model/auth_model/ip_model.dart';
import 'package:plants_spotify/model/model/auth_model/login_user_model.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/app_setting_model.dart';
import 'package:plants_spotify/model/services/globleService.dart';
import 'package:plants_spotify/model/utils/file_resource.dart';
import 'package:plants_spotify/view/screens/auth_view/profile_screen/profile_screen/profile_screen.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/home_view_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/search_screen/search_screen.dart';
import 'package:plants_spotify/view/screens/root_view/my_nursery_view/my_nursery_screen.dart';
import 'package:plants_spotify/view/widgets/app_common/custom_popup/loader_popup.dart';
import 'package:plants_spotify/view/widgets/app_common/custom_popup/warningPopup.dart';

import 'package:plants_spotify/view/widgets/button_view/animated_box.dart';
import 'package:plants_spotify/view/widgets/button_view/image_picker.dart';

import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view/widgets/toast_view/showtoast.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/home_controller.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';
import 'package:wakelock_plus/wakelock_plus.dart';


import '../../../model/network_calls/api_helper/provider_helper/auth_provider.dart';
import '../../../model/network_calls/dio_client/base_response.dart';
import '../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../model/services/auth_service.dart';
import '../../../model/utils/image_resource.dart';

import '../../../view/widgets/app_common/custom_popup/permission_popup.dart';
import '../auth_controllers/profile_controller.dart';
import '../root_view_contrller/my_nursery_controller/my_nursery_controller.dart';
import '../root_view_contrller/home_controller/search_screen_controller/search_screen_controller.dart';
import '../../notification/notifiction_redirection.dart';


class RootViewController extends BaseViewController {
  AuthProvider authProvider = getIt();
  final GlobalKey<ScaffoldState> scaffoldKey =  GlobalKey<ScaffoldState>();
  RxInt selectedIndex = 0.obs;
  List<Widget> widgetOptions = <Widget>[
    HomeViewScreen(),
    SearchScreen(),
    Center(child: Center(child: Text('3'),)),
    MyNurseryScreen(),
    ProfileScreen(),

  ];
  List<Map<String,dynamic>> images = [
    {"image":ImageResource.instance.homeIcon,"title":"home".tr},
    {"image":ImageResource.instance.searchIcon,"title":"search".tr},
    {"image":"","title":""},
    {"image":ImageResource.instance.plantIcon,"title":"my_nursery".tr},
    {"image":ImageResource.instance.userIcon,"title":"profile".tr},

  ];
  onItemTapped(int index) {
    if(index != 2){
      selectedIndex.value = index;
      selectedIndex.value.logPrint();
      refreshSelectedPage(index);
    }
  }

  void refreshSelectedPage(int index) {
    try {
      switch (index) {
        case 0:
          if (Get.isRegistered<HomeController>()) {
            Get.find<HomeController>().onInit();
          }
          break;
        case 1:
          if (Get.isRegistered<SearchScreenController>()) {
            Get.find<SearchScreenController>().onInit();
          }
          break;
        case 3:
          if (Get.isRegistered<MyNurseryController>()) {
            Get.find<MyNurseryController>().onInit();
          }
          break;
        case 4:
          if (Get.isRegistered<ProfileController>()) {
            Get.find<ProfileController>().onInit();
          }
          break;
      }
    } catch (e) {
      ("refresh error: ${e.toString()}").logPrint();
    }
  }


  /// on will pop
  void onWillPopClick(){
    if(selectedIndex.value == 0){
      SystemNavigator.pop();
    }else{
      selectedIndex.value = 0;
    }
  }

  @override
  void onInit() async {
    if (Get.arguments != null) {
      Map<String, dynamic> backData = Get.arguments;
      if (backData.containsKey("pageIndex")) {
        onItemTapped(backData["pageIndex"]);
      }
    }
    await getAppVersions();
    await updateLocation();
    await getUserIp();
    await updateDeviceID();
    await getUserProfile();
    checkTerminatedNotification();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> checkTerminatedNotification() async {
    try {
      final RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null && initialMessage.data.isNotEmpty) {
        ("terminated notification payload => ${initialMessage.data}").logPrint();
        NotificationRedirection.notificationRedirectionFromPayload(
          notificationPayload: jsonEncode(initialMessage.data),
        );
      }
    } catch (e) {
      ("checkTerminatedNotification error => $e").logPrint();
    }
  }


  void onRefresh()async{
    await getUserProfile();
    await getUserIp();
    updateLocation();
    getAppVersions();
    updateDeviceID();
  }

  Future getUserProfile()async {
    try {
      await authProvider.getProfile(onError: (errorMessage) {

        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        SingleResponse<User> loginModel = SingleResponse<User>.fromJson(
            data ?? {}, (data) => User.fromJson(data));
        if (loginModel.status == true) {
          await Get.find<AuthService>().saveUser(
              loginModel.data.toJson() ?? {});
        } else {}
      });
    } catch (e) {
      ("error ${e.toString()}").logPrint();
    }
  }
  Future getUserIp()async {
    try {
      await authProvider.getUserIp(onError: (errorMessage) {

        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        if(data?["status"]== "success"){
          await Get.find<AuthService>().saveUserIp(UserIp.fromJson(data??<String, dynamic>{}).toJson() ?? {});
        }

      });
    } catch (e) {
      ("error ${e.toString()}").logPrint();
    }
  }
  Future updateLocation()async{
    if(Get.find<AuthService>().user.value.countryCode?.isEmpty??false || Get.find<AuthService>().user.value.countryCode == null){
      try {
        Map<String, dynamic> updateLocationData ={
          "country_code": Get.find<AuthService>().userIp.value.countryCode,
          "latitude": Get.find<AuthService>().userIp.value.lat,
          "longitude": Get.find<AuthService>().userIp.value.lon,
        };
        await authProvider.updateLocation(updateLocationData, onError: (errorMessage) {

          ("errorMessage=> $errorMessage").logPrint();
        }, onSuccess: (message, data) async {

        });
      } catch (e) {
        ("this is error ${e.toString()}").logPrint();
      }
    }

  }
  Future updateDeviceID()async{
    try {
      String firebaseToken = await Get.find<GlobalService>().getFireBaseToken();
      Map<String, dynamic> updateLocationData ={
        "device_id": firebaseToken,
        "device_type":Platform.isAndroid ? "android" : "ios",
      };
      await authProvider.updateLocation(updateLocationData, onError: (errorMessage) {

        ("errorMessage=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {

      });
    } catch (e) {
      ("this is error ${e.toString()}").logPrint();
    }

  }

  RxBool isValidVersion = true.obs;
  Rx<SingleResponse<AppSettingModel>> appSettingData = SingleResponse<AppSettingModel>(data: AppSettingModel()).obs;
  Future getAppVersions()async {
    try {
      await authProvider.getAppVersions(onError: (errorMessage) {
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        appSettingData.value = SingleResponse<AppSettingModel>.fromJson(data ?? {}, (data) => AppSettingModel.fromJson(data));
        String currentVersion = await HelperFunction.getAppVersion();
        String? forceVersion = Platform.isIOS
            ? appSettingData.value.data.forceIosVersion
            : appSettingData.value.data.forceAndroidVersion;
        if(forceVersion != null && HelperFunction.isVersionLessThan(currentVersion, forceVersion)){
          isValidVersion.value = false;
        }else{
          isValidVersion.value = true;
        }
      });
    } catch (e) {
      ("error ${e.toString()}").logPrint();
    }
  }

    void identifyProcess(){
      Get.find<HomeController>().scanType.value = 2;
      Get.find<HomeController>().diagnoseTap();
    }

  void permissionPopup(context,controller) {
    showAnimatedDialog(
    Get.context!,
        PermissionPopup(
    showCancelOption: false,
    onConfirm:() async {
      Get.back();
      showImagePicker(Get.context!, onCamaraTap: controller.imgFromCamera, onGalleryTap: controller.imgFromGallery);

      // warningPopup(context,controller);
      // loadingPopup(controller);
    }, onCancel: () {
    Get.back();
    },controller:  controller),
    dismissible: false,
    isFlip: true);
    }
  void loadingPopup(controller) {
    WakelockPlus.enable();
    showAnimatedDialog(
        Get.context!,
        LoaderPopup(controller:  controller),
        dismissible: false,
        isFlip: true);
  }


  /// selected image
  Rx<File> selectedImage = File("").obs;
  var selectedImageError = "".obs;

  VoidCallback get imgFromGallery => (){
    FileResource.instance.imagePickerFromGallery().then((pickedFile){
      if(pickedFile.path!=""){
        selectedImage.value = File(pickedFile.path);
        Get.back();
        warningPopup(Get.context!,this);

      }
    } );
  };
  VoidCallback get imgFromCamera => (){
    FileResource.instance.imagePickerFromCamara().then((pickedFile){
      if(pickedFile.path!=""){
        selectedImage.value = File(pickedFile.path);
        Get.back();
        warningPopup(Get.context!,this);

      }
    } );
  };

  void warningPopup(context,controller) {
    showAnimatedDialog(
        Get.context!,
        WarningPopup(
            onConfirm:() async {
              Get.back();
              loadingPopup(controller);
              await Future.delayed(const Duration(seconds: 5));
              Get.back();
              Get.toNamed(Routes.plantsDetailScreen);
              WakelockPlus.disable();
            }, onCancel: () {
          Get.back();
        },controller:  controller),
        dismissible: false,
        isFlip: true);
  }
  void completeProfile() {
    showAnimatedDialog(
      Get.context!,
      PermissionPopup(
        onConfirm: ()  => Get.toNamed(Routes.editProfileScreen),
        onCancel: () {
          Get.back();
        },
        controller: this,
        title: "complete_profile".tr,
        subTitle: "complete_profile_error".tr,
        confirmTitle: "proceed".tr,
        image: ImageResource.instance.completeProfilePlantIcon,
        height: 370,
      ),
      dismissible: false,
      isFlip: true,
    );
  }

}
