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

class FruitDetailsScreen extends StatelessWidget {
  const FruitDetailsScreen({
    super.key,
    this.fruitingTime,
    this.harvestTime,
    this.fruitColor,
  });

  final String? fruitingTime;
  final String? harvestTime;
  final String? fruitColor;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Text(
            "fruit_details".tr,
            style: StyleResource.instance.styleSemiBold(
              DimensionResource.fontSizeDefault,
              ColorResource.instance.textDarkGreenColor2,
            ),
          ).paddingOnly(
            bottom: DimensionResource.marginSizeExtraSmall,
          ),

          /// FRUITING TIME
          if (fruitingTime?.isNotEmpty ?? false)
            FruitDetailCard(
              icon: ImageResource.instance.plantDetailIcon,
              title: "fruit_details_time".tr,
              value: fruitingTime!,
            ).paddingOnly(
                bottom: DimensionResource.marginSizeDefault),

          /// HARVEST TIME
          if (harvestTime?.isNotEmpty ?? false)
            FruitDetailCard(
              icon: ImageResource.instance.plantDetailIcon,
              title: "harvest_time".tr,
              value: harvestTime!,
            ).paddingOnly(
                bottom: DimensionResource.marginSizeDefault),

          /// FRUIT COLOR
          if (fruitColor?.isNotEmpty ?? false)
            FruitDetailCard(
              icon: ImageResource.instance.plantDetailIcon,
              title: "fruit_color".tr,
              value: fruitColor!,
            ).paddingOnly(
                bottom: DimensionResource.marginSizeDefault),
        ],
      ).paddingAll(DimensionResource.paddingSizeSmall),
    );
  }
}


class FruitDetailCard extends StatelessWidget {
  const FruitDetailCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.iconBgColor,
    this.iconSize = 15,
    this.containerSize = 30,
  });

  final String icon;
  final String title;
  final String value;
  final Color? iconBgColor;
  final double iconSize;
  final double containerSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        YRoundedContainer(
          height: containerSize,
          width: containerSize,
          backgroundColor:
          iconBgColor ?? ColorResource.instance.btnGreenColor.withValues(alpha: 0.5),
          padding: EdgeInsets.all(DimensionResource.paddingSizeExtraSmall),
          child: Center(
            child: Image.asset(
              icon,
              height: iconSize,
            ),
          ),
        ),
        Gap(DimensionResource.marginSizeDefault),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: StyleResource.instance.styleSemiBold(
                  DimensionResource.fontSizeDefault,
                  ColorResource.instance.black,
                ),
              ).paddingOnly(
                bottom: DimensionResource.marginSizeExtraSmall,
              ),
              Text(
                value,
                style: StyleResource.instance.styleRegular(
                  DimensionResource.fontSizeSmall,
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
