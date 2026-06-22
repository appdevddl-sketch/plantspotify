
import 'package:flutter/material.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/root_view_controller.dart';


import '../../../model/network_calls/api_helper/provider_helper/auth_provider.dart';
import '../../../model/network_calls/dio_client/get_it_instance.dart';

import 'package:get/get.dart';

class ProfileController extends BaseViewController{
@override
  void onInit() {
    // TODO: implement onInit
    Get.find<RootViewController>().getUserProfile();
    super.onInit();
  }

}