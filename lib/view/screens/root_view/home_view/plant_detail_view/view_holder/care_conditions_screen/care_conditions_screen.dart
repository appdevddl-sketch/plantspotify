import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/other_details_screen/other_details_screen.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
class CareConditionsScreen extends StatelessWidget {
  const CareConditionsScreen({
    super.key,
    this.temperature,
    this.hardinessZones,
    this.sunlightRequirements,
    this.soilRequirements,
  });

  final String? temperature;
  final String? hardinessZones;
  final String? sunlightRequirements;
  final String? soilRequirements;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Text(
            "care_conditions".tr,
            style: StyleResource.instance.styleSemiBold(
              DimensionResource.fontSizeDefault,
              ColorResource.instance.textDarkGreenColor2,
            ),
          ).paddingOnly(
              bottom: DimensionResource.marginSizeExtraSmall),

          /// TEMPERATURE
          if (temperature?.isNotEmpty ?? false)
            PlantAttributeRow(
              icon: ImageResource.instance.temperatureDetailIcon,
              title: "temperature".tr,
              value: temperature!,
            ).paddingOnly(
                bottom: DimensionResource.marginSizeDefault),

          /// HARDINESS ZONES
          if (hardinessZones?.isNotEmpty ?? false)
            PlantAttributeRow(
              icon: ImageResource.instance.hardinessDetailIcon,
              title: "hardiness_zones".tr,
              value: hardinessZones!,
            ).paddingOnly(
                bottom: DimensionResource.marginSizeDefault),

          /// SUNLIGHT REQUIREMENTS
          if (sunlightRequirements?.isNotEmpty ?? false)
            PlantAttributeRow(
              icon: ImageResource.instance.sunlightDetailIcon,
              title: "sunlight_requirements".tr,
              value: sunlightRequirements!,
            ).paddingOnly(
                bottom: DimensionResource.marginSizeDefault),

          /// SOIL REQUIREMENTS
          if (soilRequirements?.isNotEmpty ?? false)
            PlantAttributeRow(
              icon: ImageResource.instance.soilDetailRequirementsIcon,
              title: "soil_requirements".tr,
              value: soilRequirements!,
            ).paddingOnly(
                bottom: DimensionResource.marginSizeDefault),
        ],
      ),
    ).paddingAll(DimensionResource.paddingSizeSmall);
  }
}


