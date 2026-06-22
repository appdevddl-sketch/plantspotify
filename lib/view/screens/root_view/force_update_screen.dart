import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';

class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResource.instance.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: DimensionResource.paddingSizeLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImageResource.instance.sadPlantIcon,
                height: 150,
              ),
              const Gap(DimensionResource.paddingSizeLarge),
              Text(
                "update_required".tr,
                style: StyleResource.instance.styleBold(
                  DimensionResource.fontSizeLarge,
                  ColorResource.instance.black,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(DimensionResource.paddingSizeSmall),
              Text(
                "update_required_subtitle".tr,
                style: StyleResource.instance.styleRegular(
                  DimensionResource.fontSizeSmall,
                  ColorResource.instance.textColor_9,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(DimensionResource.paddingSizeExtraLarge),
              CommonButton(
                text: "update_now".tr,
                loading: false,
                onPressed: () => HelperFunction.openStoreListing(),
                height: 48,
                color: ColorResource.instance.btnGreenColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
