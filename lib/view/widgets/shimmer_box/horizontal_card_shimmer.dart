import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/box_shadow_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/shimmer_box/multi_line_shimmer.dart';
import 'package:plants_spotify/view/widgets/shimmer_box/single_line_shimmer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../model/utils/color_resource.dart';
class HorizontalCardShimmer extends StatelessWidget {
  const HorizontalCardShimmer({Key? key, this.height, this.length, this.physics}) : super(key: key);

  final double? height;
  final int? length;
  final ScrollPhysics? physics;


  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
        physics: physics ?? NeverScrollableScrollPhysics(),
        child: Column(
          children: List.generate(length ?? 5, (index){
            return YRoundedContainer(
              height: height,
              padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SingleLineShimmer(
                    width:100,
                    height: 100,
                  ),
                  Gap(DimensionResource.marginSizeDefault),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleLineShimmer(
                        width:250,
                        height: 10,
                      ),
                      Gap(DimensionResource.marginSizeSmall),
                      SingleLineShimmer(
                        width:200,
                        height: 10,
                      ),
                      Gap(DimensionResource.marginSizeSmall),
                      SingleLineShimmer(
                        width:100,
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ).paddingOnly(bottom: DimensionResource.marginSizeSmall);
          }),
        ),
      );


  }
}
