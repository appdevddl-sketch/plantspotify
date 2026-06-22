import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/diagnose_screens/diagnose_detail_screen/diagnose_detail_screen.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/diagnose_screens_controller/diagnose_detail_controller/diagnose_detail_controller.dart';

/// Tab – Prevention
class DiagnosePreventionScreen extends StatelessWidget {
  final DiagnoseDetailController controller;

  const DiagnosePreventionScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final prevention = controller.diagnoseData.value.diagnosisDetails?.first.prevention ?? [];
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "prevention".tr,
            style: StyleResource.instance.styleSemiBold(
              DimensionResource.fontSizeDefault,
              ColorResource.instance.textDarkGreenColor2,
            ),
          ).paddingOnly(bottom: DimensionResource.marginSizeExtraSmall),

          // Build rows of 2 – both cards in a row stretch to the tallest card's height
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 3) / 2;
              final rowCount = (prevention.length / 2).ceil();
              return Column(
                children: List.generate(rowCount, (rowIndex) {
                  final left  = rowIndex * 2;
                  final right = left + 1;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: itemWidth,
                            child: SymptomDetailCard(
                              titleSize: DimensionResource.fontSizeSmall,
                              subTitleSize: DimensionResource.fontSizeSmall,
                              title: '',
                              value: [prevention[left]],
                              backgroundColor: ColorResource.instance.bgLiteGreen,
                            ),
                          ),
                          const SizedBox(width: 3),
                          SizedBox(
                            width: itemWidth,
                            child: right < prevention.length
                                ? SymptomDetailCard(
                                    titleSize: DimensionResource.fontSizeSmall,
                                    subTitleSize: DimensionResource.fontSizeSmall,
                                    title: '',
                                    value: [prevention[right]],
                                    backgroundColor: ColorResource.instance.bgLiteGreen,
                                  )
                                : const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ).paddingAll(DimensionResource.paddingSizeSmall),
    );
  }
}
