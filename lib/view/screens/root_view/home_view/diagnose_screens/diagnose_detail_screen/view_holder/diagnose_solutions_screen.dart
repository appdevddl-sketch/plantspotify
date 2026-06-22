import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/diagnose_screens/diagnose_detail_screen/diagnose_detail_screen.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/diagnose_screens_controller/diagnose_detail_controller/diagnose_detail_controller.dart';

/// Tab – Solutions (immediate actions, organic options, chemical options)
class DiagnoseSolutionsScreen extends StatelessWidget {
  final DiagnoseDetailController controller;

  const DiagnoseSolutionsScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final treatments = controller.diagnoseData.value.diagnosisDetails?.first.treatments;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "solutions".tr,
            style: StyleResource.instance.styleSemiBold(
              DimensionResource.fontSizeDefault,
              ColorResource.instance.textDarkGreenColor2,
            ),
          ).paddingOnly(bottom: DimensionResource.marginSizeExtraSmall),

          if (treatments?.immediateActions?.isNotEmpty ?? false)
            SymptomDetailCard(
              titleSize: DimensionResource.fontSizeSmall,
              subTitleSize: DimensionResource.fontSizeSmall,
              title: 'immediate_actions'.tr,
              value: treatments!.immediateActions,
              backgroundColor: ColorResource.instance.blueBgColor,
              borderColor: ColorResource.instance.blueBgBorderColor.withValues(alpha: 0.2),
            ).paddingOnly(bottom: DimensionResource.paddingSizeExtraSmall),

          if (treatments?.organicOptions?.isNotEmpty ?? false)
            SymptomDetailCard(
              titleSize: DimensionResource.fontSizeSmall,
              subTitleSize: DimensionResource.fontSizeSmall,
              title: 'organic_options'.tr,
              value: treatments!.organicOptions,
              backgroundColor: ColorResource.instance.blueBgColor,
              borderColor: ColorResource.instance.blueBgBorderColor.withValues(alpha: 0.2),
            ).paddingOnly(bottom: DimensionResource.paddingSizeExtraSmall),

          if (treatments?.chemicalOptions?.isNotEmpty ?? false)
            SymptomDetailCard(
              titleSize: DimensionResource.fontSizeSmall,
              subTitleSize: DimensionResource.fontSizeSmall,
              title: 'chemical_options'.tr,
              value: treatments!.chemicalOptions,
              backgroundColor: ColorResource.instance.blueBgColor,
              borderColor: ColorResource.instance.blueBgBorderColor.withValues(alpha: 0.2),
            ).paddingOnly(bottom: DimensionResource.paddingSizeExtraSmall),
        ],
      ).paddingAll(DimensionResource.paddingSizeSmall),
    );
  }
}
