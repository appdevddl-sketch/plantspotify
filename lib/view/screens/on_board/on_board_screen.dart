import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/font_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/screens/on_board/view_helper/onboard_main_view.dart';
import 'package:plants_spotify/view_model/controller/on_board_controller/on_board_controller.dart';




class OnBoardScreen extends StatelessWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(
        viewControl: OnBoardController(),
        bottomSafeArea: Platform.isAndroid ? true : false,
        backgroundColor: ColorResource.instance.backgroundMainColor,
        onPageBuilder: (BuildContext context,OnBoardController controller)=>_buildOnboardView(context,controller));
  }
}



Widget _buildOnboardView(BuildContext context, OnBoardController controller) {
  return PageView(

    controller: controller.pageController,
    onPageChanged: controller.updtePageIndicator,
    children:  [
      OnBoardingMainView(controller: controller, image: ImageResource.instance.onBoardThird,boxFit: BoxFit.contain,
        titleWidget: RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                      text: "your_smart".tr,
                      style: StyleResource.instance.styleMedium(DimensionResource.fontSizeSmall * 2, ColorResource.instance.white)
                  ),
                  TextSpan(
                      text: " ${"ai_plant".tr} ",
                      style: StyleResource.instance.styleExtraBold(DimensionResource.fontSizeSmall * 2, ColorResource.instance.mainColor).copyWith(fontFamily: FontResource.instance.secondaryFont)
                  ),
                  TextSpan(
                      text: "care_partner".tr,
                      style: StyleResource.instance.styleMedium(DimensionResource.fontSizeSmall * 2, ColorResource.instance.white)
                  ),
                ]
            )),
        subtitle: "onboard_subtitle".tr,),
      OnBoardingMainView(controller: controller, image: ImageResource.instance.onBoardFirst,boxFit: BoxFit.cover,
        titleWidget: RichText(
          text: TextSpan(
          children: [
            TextSpan(
              text: "hi_im".tr,
              style: StyleResource.instance.styleMedium(DimensionResource.fontSizeSmall * 2, ColorResource.instance.white)
            ),
            TextSpan(text: " "),
            TextSpan(
                text: " ${"plant_spotify".tr} " ,
                style: StyleResource.instance.styleBold(DimensionResource.fontSizeSmall * 2, ColorResource.instance.mainColor).copyWith(fontFamily: FontResource.instance.secondaryFont)
            )
          ]
        )),
        subtitle: "onboard_subtitle".tr,),
      OnBoardingMainView(controller: controller, image: ImageResource.instance.onBoardSecond,boxFit: BoxFit.cover,
        titleWidget: RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                      text: "i_help_you_to_identify_only".tr,
                      style: StyleResource.instance.styleMedium(DimensionResource.fontSizeSmall * 2, ColorResource.instance.white)
                  ),
                  TextSpan(
                      text: " ${"plant".tr} ",
                      style: StyleResource.instance.styleExtraBold(DimensionResource.fontSizeSmall * 2, ColorResource.instance.mainColor).copyWith(fontFamily:FontResource.instance.secondaryFont )
                  ),
                  TextSpan(
                      text: "instantly".tr,
                      style: StyleResource.instance.styleMedium(DimensionResource.fontSizeSmall * 2, ColorResource.instance.white)
                  )
                ]
            )),
        subtitle: "onboard_subtitle".tr,),

    ],
  );
}

