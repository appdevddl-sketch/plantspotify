

import 'package:flutter/material.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/account_option_provider.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/network_calls/dio_client/get_it_instance.dart';
import 'package:plants_spotify/model/services/auth_service.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view/widgets/toast_view/showtoast.dart';




class ContactUsController extends BaseViewController {
  AccountOptionProvider accountOptionProvider = getIt();
  final GlobalKey<FormState> contactUsFormKey = GlobalKey<FormState>();
  TextEditingController nameController  = TextEditingController(text: Get.find<AuthService>().user.value.name);
  TextEditingController emailController  = TextEditingController(text: Get.find<AuthService>().user.value.email);
  TextEditingController explainController  = TextEditingController();

  var nameError = "".obs;
  var emailError = "".obs;
  var explainError = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
  }

  void clearForm()async{
    nameController.clear();
    emailController.clear();
    explainController.clear();
     nameError.value = "";
     emailError.value = "";
     explainError.value = "";

  }

  void submitForm()async{
    if(contactUsFormKey.currentState?.validate()??false){

      isLoading.call(true);
      try {
        Map<String, dynamic> updateProfileData ={
          "name": nameController.text,
          "email": emailController.text,
          "message":  explainController.text ,

        };
        await accountOptionProvider.contactUs(updateProfileData, onError: (errorMessage) {
          
          ("errorMessage=> $errorMessage").logPrint();
          toastShow(message: errorMessage??"", error: true);
          isLoading.call(false);
        }, onSuccess: (message, data) async {
         BaseResponse response = BaseResponse.fromJson(data??{});
          if (response.status == true) {
            toastShow(message: response.message??"", error: false);
            clearForm.call();
            isLoading.call(false);
          } else {
            isLoading.call(false);
          }
        });
      } catch (e) {
        ("this is error ${e.toString()}").logPrint();
        isLoading.call(false);
      }

    }
  }

}
