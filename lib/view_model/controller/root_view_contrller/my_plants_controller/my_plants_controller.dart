
import 'package:flutter/material.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:get/get.dart';

class MyPlantsController extends BaseViewController with GetSingleTickerProviderStateMixin{

  late TabController pageController;
  RxString selectCategory = 'saved_plants'.tr.obs;
  List<String> tabsCategory = ['saved_plants'.tr, 'scan_history'.tr];
  void onChangeButtonTapped(int index) {
    selectCategory.value = tabsCategory[index];
    pageController.animateTo(index, duration: const Duration(milliseconds: 250), curve: Curves.linear);
  }
  final GlobalKey<ScaffoldState> scaffoldKey =  GlobalKey<ScaffoldState>();


  @override
  void onInit() {
    pageController = TabController(initialIndex: 0, vsync: this, length: 2);
    pageController.addListener(pageListener);

    super.onInit();
  }

  pageListener() {
    switch (pageController.index) {
      case 0:
        selectCategory.value = "saved_plants".tr;
        break;
      case 1:
        selectCategory.value = "scan_history".tr;
        break;
      default:
        selectCategory.value = "saved_plants".tr;
    }
  }



}

