import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
class ToxicityInformationScreen extends StatelessWidget {
  const ToxicityInformationScreen({
    super.key,
    this.toxicityToHumans,
    this.toxicityToPets,
    this.weedPotential,
  });

  final String? toxicityToHumans;
  final String? toxicityToPets;
  final String? weedPotential;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Text(
            "toxicity_information".tr,
            style: StyleResource.instance.styleSemiBold(
              DimensionResource.fontSizeDefault,
              ColorResource.instance.textDarkGreenColor2,
            ),
          ).paddingOnly(bottom: DimensionResource.marginSizeSmall),

          /// TOXICITY TO HUMANS
          if (toxicityToHumans?.isNotEmpty ?? false)
            ToxicityInfoBox(
              title: 'toxicity_to_humans'.tr,
              value: toxicityToHumans!,
              titleColor: ColorResource.instance.textRed,
              backgroundColor:
              ColorResource.instance.textRed.withValues(alpha: 0.2),
            ).paddingOnly(bottom: DimensionResource.marginSizeSmall),

          /// TOXICITY TO PETS
          if (toxicityToPets?.isNotEmpty ?? false)
            ToxicityInfoBox(
              title: 'toxicity_to_pets'.tr,
              value: toxicityToPets!,
              titleColor: ColorResource.instance.orangeTextBg,
              backgroundColor:
              ColorResource.instance.cardOrangeColor.withValues(alpha: 0.1),
            ).paddingOnly(bottom: DimensionResource.marginSizeSmall),

          /// WEED POTENTIAL
          // if (weedPotential?.isNotEmpty ?? false)
          //   ToxicityInfoBox(
          //     title: 'weed_potential'.tr,
          //     value: weedPotential!,
          //     titleColor: ColorResource.instance.btnGreenColor,
          //     backgroundColor:
          //     ColorResource.instance.socialButtonGreenColor.withValues(alpha: 0.9),
          //   ).paddingOnly(bottom: DimensionResource.marginSizeSmall),
        ],
      ).paddingAll(DimensionResource.paddingSizeSmall),
    );
  }
}

class ToxicityInfoBox extends StatelessWidget {
  const ToxicityInfoBox({
    super.key,
    required this.title,
    required this.value,
    this.backgroundColor,
    this.radius = 0,
    this.padding,
    this.titleStyle,
    this.valueStyle,
    this.crossAxisAlignment = CrossAxisAlignment.start, this.titleColor,
  });

  final String title;
  final String value;
  final Color? backgroundColor;
  final Color? titleColor;

  final double radius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return YRoundedContainer(
      backgroundColor:
      backgroundColor ?? ColorResource.instance.btnGreenColor,
      radius: radius,
      width: HelperFunction.screenWidth(),
      padding:
      padding ?? EdgeInsets.all(DimensionResource.paddingSizeSmall),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            title.tr,
            style: titleStyle ??
                StyleResource.instance.styleSemiBold(
                  DimensionResource.fontSizeSmall,
                  titleColor??ColorResource.instance.black,
                ),
          ).paddingOnly(
            bottom: DimensionResource.marginSizeSmall,
          ),
          Text(
            value,
            style: valueStyle ??
                StyleResource.instance.styleRegular(
                  DimensionResource.fontSizeSmall,
                  ColorResource.instance.textColor_2,
                ),
          ),
        ],
      ),
    );
  }
}

