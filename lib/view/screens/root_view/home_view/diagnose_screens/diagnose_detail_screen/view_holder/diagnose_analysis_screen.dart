import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/diagnose_screens/diagnose_detail_screen/diagnose_detail_screen.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/diagnose_screens_controller/diagnose_detail_controller/diagnose_detail_controller.dart';

/// Tab – Plant Diagnostics (likely causes)
class DiagnoseAnalysisScreen extends StatelessWidget {
  final DiagnoseDetailController controller;

  const DiagnoseAnalysisScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final likelyCauses = controller.diagnoseData.value.diagnosisDetails?.first.likelyCauses ?? [];
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "plant_diagnostics".tr,
            style: StyleResource.instance.styleSemiBold(
              DimensionResource.fontSizeDefault,
              ColorResource.instance.textDarkGreenColor2,
            ),
          ).paddingOnly(bottom: DimensionResource.marginSizeExtraSmall),

          ...List.generate(likelyCauses.length, (index) =>
            SymptomDetailCard(
              titleSize: DimensionResource.fontSizeSmall,
              subTitleSize: DimensionResource.fontSizeSmall,
              title: '',
              value: likelyCauses[index],
              backgroundColor: ColorResource.instance.orangeBoxBg,
              borderColor: ColorResource.instance.orangeGradientColor1.withValues(alpha: 0.2),
            ).paddingOnly(bottom: DimensionResource.paddingSizeExtraSmall),
          ),
        ],
      ).paddingAll(DimensionResource.paddingSizeSmall),
    );
  }
}
