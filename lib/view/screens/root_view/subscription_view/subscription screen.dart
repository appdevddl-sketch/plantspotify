



import 'dart:io';

import 'package:flutter/material.dart';

import 'package:plants_spotify/view/screens/root_view/subscription_view/view_holder/subscription_screen_1.dart';
import 'package:plants_spotify/view/screens/root_view/subscription_view/view_holder/subscription_screen_2.dart';

import 'package:plants_spotify/view_model/controller/root_view_contrller/subscription_controller/subscription_controller.dart';

import '../../base_view/base_view_screen.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(viewControl: SubscriptionController(),
        bottomSafeArea: Platform.isAndroid ? true : false,
        onPageBuilder: (BuildContext context,SubscriptionController controller)=>_buildLoginView(context,controller));
  }
}

Widget _buildLoginView(BuildContext context,SubscriptionController controller){
  return PageView(
    controller: controller.pageController,
    onPageChanged: controller.updtePageIndicator,
    children:  [
      // SubscriptionScreen1(controller: controller),
      SubscriptionScreen2(controller: controller),
    ],
  );
}









