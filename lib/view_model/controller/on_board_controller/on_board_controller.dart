import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';

import '../../../model/services/auth_service.dart';
import '../../../model/utils/string_resource.dart';
import '../../routes/app_pages.dart';


class OnBoardController extends BaseViewController{
  // PageController pageController = PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
  // RxInt selectedIndex = 0.obs;
  // // variables
  final pageController = PageController();
  Rx<int> currentPageIndex =0.obs;
//update curret index when page scroll
  void updtePageIndicator(index) => currentPageIndex.value = index;


//jump to the  specific dot selected page
  void dotNavigationClick(index){
    currentPageIndex.value=index;
    pageController.jumpTo(index);
  }

  //update current index and  jump to the next page
  void nextPage(){
    if(currentPageIndex.value == 2){
      Get.find<AuthService>().box!.write(StringResource.instance.isFirst, true);
       Get.offAllNamed(Routes.socialSignInScreen);
    }else{
      int page = currentPageIndex.value + 1 ;
      pageController.animateToPage(currentPageIndex.value+1,  curve: Curves.linear, duration: const Duration(milliseconds: 500));
    }

  }
//update current index and  jump to the last page
  void skipPage(){
    Get.find<AuthService>().box!.write(StringResource.instance.isFirst, true);
    Get.toNamed(Routes.socialSignInScreen);

  }

  // VoidCallback get onNextClicked => (){
  //   if(selectedIndex<2) {
  //     pageController.animateToPage(selectedIndex.value+1,  curve: Curves.linear, duration: const Duration(milliseconds: 200));
  //   }
  //   else{
  //     Get.find<AuthService>().box!.write(StringResource.instance.isFirst, true);
  //   }
  // };
  // VoidCallback get onSkip => (){
  //   Get.find<AuthService>().box!.write(StringResource.instance.isFirst, true);
  // };
}