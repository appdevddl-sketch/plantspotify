
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plants_spotify/model/model/root_view_models/accountview_models/setting_model.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/auth_provider.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/home_provider.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/network_calls/dio_client/get_it_instance.dart';
import 'package:plants_spotify/model/services/auth_service.dart';
import 'package:plants_spotify/model/services/globleService.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/screens/root_view/my_nursery_view/view_holder/delete_dialog_screen.dart';
import 'package:plants_spotify/view/widgets/app_common/custom_popup/delete_account_form.dart';
import 'package:plants_spotify/view/widgets/app_common/custom_popup/permission_popup.dart';
import 'package:plants_spotify/view/widgets/app_common/custom_popup/warningPopup.dart';
import 'package:plants_spotify/view/widgets/button_view/animated_box.dart';
import 'package:plants_spotify/view/widgets/button_view/my_dialog.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view/widgets/toast_view/showtoast.dart';

import 'package:plants_spotify/view_model/controller/root_view_contrller/root_view_controller.dart';
class AccountViewController extends BaseViewController{
  AuthProvider authProvider = getIt();
  HomeProvider homeProvider = getIt();
  RxBool notificationStatus =  true.obs;
  RxString privacyPolicyUrl = "".obs;
  RxString aboutUsUrl = "".obs;
  RxString appVersion = "".obs;

  TextEditingController reasonController  = TextEditingController();
  RxString reasonError = "".obs;
  final GlobalKey<FormState> reasonFormKey = GlobalKey<FormState>();


  void logout() {
    showAnimatedDialog(
        Get.context!,
        PermissionPopup(
            onConfirm:() async {
              Get.back();
              try {
                Get.back();
                String deviceId = await Get.find<GlobalService>().getFireBaseToken();
                Map<String,dynamic> logoutData = {
                  "device_id" :deviceId,
                };
                await authProvider.logout(logoutData,onError: (errorMessage) {
                  
                  toastShow(message: errorMessage ?? "Something went wrong here.".tr, error: true);
                  ("errorMessage=> $errorMessage").logPrint();
                }, onSuccess: (message, data) async {
                  await Get.find<AuthService>().logOut();
                  toastShow(message: message ?? "", error: false);
                });
              } catch (e) {
                toastShow(message: "Unhandled Exception".tr, error: true);
              }
            }, onCancel: () {
          Get.back();
        },
          height: 370,
          controller:  this,
          image: ImageResource.instance.sadPlantIcon,
          title: "logout_title".tr,
          subTitle: "logout_subtitle".tr,
          confirmTitle: "logout".tr,
          cancelTitle: "cancel".tr,
        ),
        dismissible: false,
        isFlip: true);
  }

  void deleteReasonPopup() {
    showAnimatedDialog(
        Get.context!,
        DeleteFormPopup(
          onConfirm:() async {
            submitDeleteForm();
          }, onCancel: () {
          Get.back();
        },
          height: 570,
          controller:  this,
          image: ImageResource.instance.sadPlantIcon,
          title: "delete_account_form_title".tr,
          subTitle: "delete_account_form_subtitle".tr,
          confirmTitle: "delete".tr,
          cancelTitle: "cancel".tr,
        ),
        dismissible: false,
        isFlip: true);
  }

  void submitDeleteForm() async{
    if(reasonFormKey.currentState?.validate()??false){
      try {
        Map<String,dynamic> deleteAccountData = {
          "reason" : reasonController.text,
        };
        await authProvider.deleteAccount(deleteAccountData,onError: (errorMessage) {
          
          toastShow(message: errorMessage ?? "Something went wrong here.".tr, error: true);
          ("errorMessage=> $errorMessage").logPrint();
        }, onSuccess: (message, data) async {
          await Get.find<AuthService>().logOut();
          toastShow(message: message ?? "", error: false);

        });
      } catch (e) {
        toastShow(message: "Unhandled Exception".tr, error: true);
      }
    }
  }
  void openDeleteDialog(controller) {
    showAnimatedDialog(
        Get.context!,
        DeletePopup(
          onConfirm:() async {
            Get.back();
            deleteReasonPopup();
          }, onCancel: () {
          Get.back();
        },controller:  controller,title: "delete_account_title".tr,),
        dismissible: false,
        isFlip: true);
  }


  // Future setUserNotificationStatus(bool value)async {
  //   notificationStatus.value = value;
  //   try {
  //     String time =HelperFunction.formatDateForHash();
  //     String hash = HelperFunction.getHashData("${ notificationStatus.value == true ? "1" : "0"}$time${Get.find<AuthService>().user.value.id}${Get.find<AuthService>().user.value.uniqueId}");
  //     Map<String,dynamic> getProfileData ={
  //       "user_id": Get.find<AuthService>().user.value.id,
  //       "is_notification": notificationStatus.value == true ? "1" : "0" ,
  //       "hash": hash,
  //       "timestamp": time,
  //     };
  //     ("hashData => ${HelperFunction.formatDateForHash()}${Get.find<AuthService>().user.value.id}${Get.find<AuthService>().user.value.uniqueId}").logPrint();
  //     ("POST DATA => $getProfileData").logPrint();
  //     await homeProvider.changeNotificationStatus(getProfileData,onError: (errorMessage) {
  //       ("error Message=> $errorMessage").logPrint();
  //     }, onSuccess: (message, data) async {
  //       BaseResponse response= BaseResponse.fromJson(data??{});
  //       if(response.status == 0){
  //
  //       }
  //     });
  //   } catch (e) {
  //     ("this is login try error ${e.toString()}").logPrint();
  //   }
  // }
  //
  // Future getAboutUsLink()async {
  //   try {
  //     String time =HelperFunction.formatDateForHash();
  //     String hash = HelperFunction.getHashData("$time${Get.find<AuthService>().user.value.id}${Get.find<AuthService>().user.value.uniqueId}");
  //     Map<String,dynamic> getSettingsUrlData ={
  //       "user_id": Get.find<AuthService>().user.value.id,
  //       "hash": hash,
  //       "timestamp": time,
  //     };
  //     ("hashData => ${HelperFunction.formatDateForHash()}${Get.find<AuthService>().user.value.id}${Get.find<AuthService>().user.value.uniqueId}").logPrint();
  //     ("POST DATA => $getSettingsUrlData").logPrint();
  //     await homeProvider.getSettingsUrl(getSettingsUrlData,onError: (errorMessage) {
  //       ("vendor profile error Message=> $errorMessage").logPrint();
  //     }, onSuccess: (message, data) async {
  //       SingleResponse<SettingsModel> response = SingleResponse<SettingsModel>.fromJson(data??{},(data)=>SettingsModel.fromJson(data));
  //      if(response.status == 0){
  //        privacyPolicyUrl.value = response.data.privacyPolicy??"";
  //        aboutUsUrl.value = response.data.aboutUs??"";
  //        print("dadasdasdad::${privacyPolicyUrl.value}");
  //        print("dadasdasdad1234::${aboutUsUrl.value}");
  //      }
  //     });
  //   } catch (e) {
  //     ("this is login try error ${e.toString()}").logPrint();
  //   }
  // }
  @override
  void onInit() async{
    // TODO: implement onInit
    // notificationStatus.value = Get.find<AuthService>().user.value.isNotification == "1"? true :false;
    // await getAboutUsLink();
    appVersion.value = await HelperFunction.getAppVersion();
    super.onInit();
  }
}

