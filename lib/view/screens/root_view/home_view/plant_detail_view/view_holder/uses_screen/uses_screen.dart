import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/diagnose_details_model.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/other_details_screen/other_details_screen.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';

import '../../../../../../../model/model/root_view_models/home_view_models/identify_detail_model.dart';
class UsesScreen extends StatelessWidget {
  const UsesScreen({
    super.key, required this.data,

  });

  final List<Use> data ;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Text(
            "uses".tr,
            style: StyleResource.instance.styleSemiBold(
              DimensionResource.fontSizeDefault,
              ColorResource.instance.textDarkGreenColor2,
            ),
          ).paddingOnly(bottom: DimensionResource.marginSizeSmall),

          /// DESCRIPTION OF USES
          if (data.isNotEmpty)
            ...List.generate(data.length, (index){
              return PlantAttributeRow(
                icon: ImageResource.instance.plantUseDetailIcon,
                title: data[index].name??"",
                value: data[index].description??"",
              ).paddingOnly(bottom: DimensionResource.marginSizeDefault);
            }),

        ],
      ),
    ).paddingAll(DimensionResource.paddingSizeSmall);
  }
}


