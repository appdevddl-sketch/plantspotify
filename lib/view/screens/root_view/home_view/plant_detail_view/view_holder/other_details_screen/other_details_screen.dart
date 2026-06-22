import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';

class OtherDetailsScreen extends StatelessWidget {
  const OtherDetailsScreen({
    super.key,
    this.matureHeight,
    this.spread,
    this.color,
    this.type,
    this.plantingTime,
  });

  final String? matureHeight;
  final String? spread;
  final String? color;
  final String? type;
  final String? plantingTime;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Text(
            "other_details".tr,
            style: StyleResource.instance.styleSemiBold(
              DimensionResource.fontSizeDefault,
              ColorResource.instance.textDarkGreenColor2,
            ),
          ).paddingOnly(bottom: DimensionResource.marginSizeExtraSmall),
      
          /// HEIGHT
          if (matureHeight?.isNotEmpty ?? false)
            PlantAttributeRow(
              icon: ImageResource.instance.heightIcon,
              title: "mature_height".tr,
              value: matureHeight!,
            ).paddingOnly(
                bottom: DimensionResource.marginSizeDefault),
      
          /// SPREAD
          if (spread?.isNotEmpty ?? false)
            PlantAttributeRow(
              icon: ImageResource.instance.spreadIcon,
              title: "spread".tr,
              value: spread!,
            ).paddingOnly(
                bottom: DimensionResource.marginSizeDefault),
      
          /// COLOR
          if (color?.isNotEmpty ?? false)
            PlantAttributeRow(
              icon: ImageResource.instance.colorsIcon,
              title: "color".tr,
              value: color!,
            ).paddingOnly(
                bottom: DimensionResource.marginSizeDefault),
      
          /// TYPE
          if (type?.isNotEmpty ?? false)
            PlantAttributeRow(
              icon: ImageResource.instance.plantTypeIcon,
              title: "type".tr,
              value: type!,
            ).paddingOnly(
                bottom: DimensionResource.marginSizeDefault),
      
          /// PLANTING TIME (SPECIAL CARD)
          if (plantingTime?.isNotEmpty ?? false)
            YRoundedContainer(
              radius: 0,
              width: HelperFunction.screenWidth(),
              backgroundColor:
              ColorResource.instance.cardBgRed,
              padding: EdgeInsets.all(
                  DimensionResource.paddingSizeDefault),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    ImageResource.instance.plantingIcon,
                    height: 25,
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          "planting_time".tr,
                          style:
                          StyleResource.instance.styleSemiBold(
                            14,
                            ColorResource.instance.textBrownColor,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          plantingTime!,
                          style:
                          StyleResource.instance.styleRegular(
                            13,
                            ColorResource.instance.textColor_2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    ).paddingAll(DimensionResource.paddingSizeSmall);
  }
}

class PlantAttributeRow extends StatelessWidget {
  final String icon;
  final String title;
  final String value;

  const PlantAttributeRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// LEFT ICON
        Image.asset(
          icon,
          height: 25,
          color: ColorResource.instance.greenColor,
        ),

        const SizedBox(width: 12),

        /// RIGHT CONTENT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TITLE
              Text(
                title,
                style: StyleResource.instance.styleSemiBold(
                  14,
                  ColorResource.instance.textDarkGreenColor,
                ),
              ),

              const SizedBox(height: 4),

              /// VALUE
              Text(
                value,
                style: StyleResource.instance.styleRegular(
                  13,
                  ColorResource.instance.textColor_2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
