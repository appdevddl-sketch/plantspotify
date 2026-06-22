import 'dart:convert';


import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/nursery_provider.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/network_calls/dio_client/get_it_instance.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/home_view_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/save_plants_bottomsheet.dart';
import 'package:plants_spotify/view/widgets/button_view/animated_box.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view/widgets/toast_view/showtoast.dart';
import 'package:plants_spotify/view_model/notification/my_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class CreateCollectionController extends BaseViewController {
  NurseryProvider nurseryProvider = getIt();
  final GlobalKey<FormState> createCollectionFormKey = GlobalKey<FormState>();
  TextEditingController collectionNameController  = TextEditingController();
  var collectionNameError = "".obs;


  /// create collection
  void createCollection()async{
    if(createCollectionFormKey.currentState?.validate()??false) {
      isLoading.call(true);
      try {
        Map<String,String>  createCollectionData={
          "collection_name": collectionNameController.text,
        };
        await nurseryProvider.addPlantToCollection(createCollectionData,onError: (errorMessage) {
          
          ("errorMessage=> $errorMessage").logPrint();
          toastShow(message: errorMessage??"", error: true);
          isLoading.call(false);
        }, onSuccess: (message, data) async {
          BaseResponse response = BaseResponse.fromJson(data??{});
          if(response.status == true){
            collectionNameController.clear();
            toastShow(message: message??"", error: false);
            Get.back();
          }
          isLoading.call(false);
        });
      } catch (e) {
        ("this is login try error ${e.toString()}").logPrint();
        isLoading.call(false);
      }
    }

  }






  @override
  void onInit() {
    super.onInit();
  }




}
