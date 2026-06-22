import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_image.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/subscription_controller/subscription_controller.dart';
import 'package:get/get.dart';

class SubscriptionScreen1 extends StatelessWidget {
  const SubscriptionScreen1({super.key, required this.controller});
  final SubscriptionController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: YRoundedContainer(
        height: HelperFunction.screenHeight(),
        width: HelperFunction.screenWidth(),
        radius: 0,
        gradient: LinearGradient(
          colors: [ Color(0xffF0FFDF), Color(0xffF0FFDF), Color(0xffFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0.0, 0.3, 0.5
          ],
        ),
        padding: const EdgeInsets.all(DimensionResource.marginSizeDefault),
        child: Column(
          children: [
            Platform.isIOS ? Gap(DimensionResource.defaultIos) : Gap(DimensionResource.defaultTop),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    height: 35,
                    width: 35,
                    padding: const EdgeInsets.all(DimensionResource.marginSizeSmall),
                    decoration: BoxDecoration(
                      color: ColorResource.instance.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: DecorationResource.instance.containerBoxShadow(ColorResource.instance.grey),
                    ),
                    child: Image.asset(
                      ImageResource.instance.backArrowIcon,
                      height: 11,
                      color: ColorResource.instance.black,
                    ),
                  ),
                ).paddingSymmetric(vertical: DimensionResource.paddingSizeExtraSmall),
                Expanded(child: Center(child: Text("subscription_plan".tr,style: StyleResource.instance.styleBold(DimensionResource.fontSizeLarge, ColorResource.instance.textDarkGreenColor),).paddingOnly(bottom: DimensionResource.marginSizeSmall))),
              ],
            ).paddingOnly(bottom: DimensionResource.marginSizeLarge*2),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Image.asset(ImageResource.instance.subPlantImage1,width: HelperFunction.screenWidth() *.60,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        buildIconCoulmn(imageUrl: ImageResource.instance.dropIcon, title: "watering".tr).paddingOnly(bottom: DimensionResource.marginSizeExtraSmall),
                        buildIconCoulmn(imageUrl: ImageResource.instance.sunIcon, title: "plant_database".tr).paddingOnly(bottom: DimensionResource.marginSizeExtraSmall),
                        buildIconCoulmn(imageUrl: ImageResource.instance.temperatureIcon, title: "plant_database".tr),


                      ],
                    )
                  ],
                ),
                YRoundedImage(
                  isNetworkImage: false,
                  imageUrl: ImageResource.instance.subPlantImage2,
                  width:  HelperFunction.screenWidth() *.60,
                ),
              ],
            ).paddingOnly(bottom: DimensionResource.marginSizeDefault),
            Text("enjoy_unrestricted".tr,style: StyleResource.instance.styleBold(DimensionResource.fontSizeLarge, ColorResource.instance.textDarkGreenColor),).paddingOnly(bottom: DimensionResource.marginSizeSmall),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    children: [
                      TextSpan(
                          text: "sub1_subtitle_1".tr,
                          style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.textColor_2 )
                      ),
                      TextSpan(
                          text: " "
                      ),
                      TextSpan(
                          text: "\$14.99/month".tr,
                          style: StyleResource.instance.styleBold(DimensionResource.fontSizeDefault, ColorResource.instance.btnGreenColor )
                      ),
                      TextSpan(
                          text: ".\n",
                          style: StyleResource.instance.styleRegular(DimensionResource.fontSizeDefault, ColorResource.instance.textColor_2 )

                      ),
                      TextSpan(
                          text: "sub1_subtitle_2".tr,
                          style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.textColor_2 )
                      )
                    ]
                )
            ).paddingOnly(bottom: DimensionResource.marginSizeDefault * 2),

            YRoundedContainer(
              padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
              // backgroundColor: ColorResource.instance.socialButtonGreenColor,
              gradient: LinearGradient(
                  colors: [ColorResource.instance.socialButtonGreenColor,ColorResource.instance.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter
              ),
              showBorder: true,
              radius: 5,

              borderColor: ColorResource.instance.btnBorderGreen.withValues(alpha: 0.4),
              width: HelperFunction.screenWidth(),
              boxshadow: DecorationResource.instance.containerBoxShadow(ColorResource.instance.black.withValues(alpha: 0.1)),
              child: Row(

                children: [
                  Expanded(child: buildSubscriptionDetailColumn(title: "\$14.99/${"month".tr}", subtitle: 'unlimited_scans'.tr,)),
                  Expanded(child: buildSubscriptionDetailColumn(title: "unlimited_scans".tr, subtitle: 'Unlimited Scans History'.tr,titleColor: ColorResource.instance.btnGreenColor,titleTextSize: DimensionResource.fontSizeSmall,))

                ],
              ),
            ).paddingOnly(bottom: DimensionResource.marginSizeDefault *3),

            CommonButton(text: "continue".tr, loading: controller.isLoading.value, onPressed: ()=>controller.nextPage())

          ],
        ),
      ),
    );
  }
}
class buildSubscriptionDetailColumn extends StatelessWidget {
  const buildSubscriptionDetailColumn({
    super.key, required this.title, required this.subtitle,  this.titleColor, this.titleTextSize,
  });
  final String title;
  final Color?  titleColor;
  final double?  titleTextSize;


  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,style: StyleResource.instance.styleBold(titleTextSize??DimensionResource.fontSizeLarge, titleColor ??  ColorResource.instance.black )),
        Row(
          children: [
            Icon(Icons.circle,size: DimensionResource.iconSizeExtraSmall /2,color: ColorResource.instance.textDarkGreenColor.withValues(alpha: 0.58),),
            Gap(DimensionResource.marginSizeExtraSmall),
            Flexible(child: Text(subtitle,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.textDarkGreenColor.withValues(alpha: 0.58)))),
          ],
        )
      ],
    );
  }
}

Column buildIconCoulmn({required String imageUrl,required String title}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Image.asset(imageUrl,height: 25,),
      Text(title,style: StyleResource.instance.styleMedium(DimensionResource.fontSizeExtraSmall, ColorResource.instance.textColor_2),)
    ],
  );
}