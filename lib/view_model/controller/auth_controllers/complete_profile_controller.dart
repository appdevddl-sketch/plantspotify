
import 'package:flutter/material.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';


import '../../../model/network_calls/api_helper/provider_helper/auth_provider.dart';
import '../../../model/network_calls/dio_client/get_it_instance.dart';

import 'package:get/get.dart';

class CompleteProfileController extends BaseViewController{
  AuthProvider authProvider = getIt();

  TextEditingController nameController  = TextEditingController();


  var nameError = "".obs;

  RxString selectTypeValue = ''.obs;
  List<String> typeList =['Apartment','Villa','Outdoor Terrace','Office','Shaded indoor'];

}