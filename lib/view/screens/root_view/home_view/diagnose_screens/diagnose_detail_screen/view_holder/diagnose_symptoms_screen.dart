import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/diagnose_screens/diagnose_detail_screen/diagnose_detail_screen.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/diagnose_screens_controller/diagnose_detail_controller/diagnose_detail_controller.dart';

/// Tab – Symptoms
class DiagnoseSymptomsScreen extends StatelessWidget {
  final DiagnoseDetailController controller;

  const DiagnoseSymptomsScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final symptoms = controller.diagnoseData.value.diagnosisDetails?.first.symptoms ?? [];
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "symptoms".tr,
            style: StyleResource.instance.styleSemiBold(
              DimensionResource.fontSizeDefault,
              ColorResource.instance.textDarkGreenColor2,
            ),
          ).paddingOnly(bottom: DimensionResource.marginSizeExtraSmall),

          ...List.generate(symptoms.length, (index) =>
            SymptomDetailCard(
              titleSize: DimensionResource.fontSizeSmall,
              subTitleSize: DimensionResource.fontSizeSmall,
              title: '',
              value: symptoms[index],
              backgroundColor: ColorResource.instance.bgLiteGreen,
            ).paddingOnly(bottom: DimensionResource.paddingSizeExtraSmall),
          ),
        ],
      ).paddingAll(DimensionResource.paddingSizeSmall),
    );
  }
}
