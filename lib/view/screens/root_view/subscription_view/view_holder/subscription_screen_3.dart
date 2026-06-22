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

class SubscriptionScreen3 extends StatelessWidget {
  const SubscriptionScreen3({super.key, required this.controller});
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
            0.0, 0.0, 1
          ],
        ),
        padding: const EdgeInsets.all(DimensionResource.marginSizeDefault),
        child: Column(
          children: [
            Row(
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
          ],
        ),
      ),
    );
  }
}