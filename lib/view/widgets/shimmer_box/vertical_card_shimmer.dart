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
class VerticalCardShimmer extends StatelessWidget {
  const VerticalCardShimmer({Key? key, this.height, this.length, this.physics}) : super(key: key);

  final double? height;
  final int? length;
  final ScrollPhysics? physics;


  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
        physics: physics ?? AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(length ?? 5, (index){
            return YRoundedContainer(
              height: height,
              radius: 35,
              width: 170,
              padding: EdgeInsets.only(top:DimensionResource.paddingSizeDefault),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SingleLineShimmer(
                    width:150,
                    height: 120,
                  ),
                  Gap(DimensionResource.marginSizeSmall),
                  SingleLineShimmer(height: 10,width: 70,),
                  Gap(DimensionResource.marginSizeSmall),
                  SingleLineShimmer(height: 10,width: 90,),
                  Gap(DimensionResource.marginSizeSmall),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: 80,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(35),
                                  bottomRight: Radius.circular(35)
                              )
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ).paddingOnly(right: DimensionResource.marginSizeDefault);
          }),
        ),
      );


  }
}
class VerticalSingleCardShimmer extends StatelessWidget {
  const VerticalSingleCardShimmer({Key? key, this.height, this.length, this.physics}) : super(key: key);

  final double? height;
  final int? length;
  final ScrollPhysics? physics;


  @override
  Widget build(BuildContext context) {
    return  YRoundedContainer(
      height: height,
      width: 170,
      padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SingleLineShimmer(
            width:150,
            height: 120,
          ),
          Gap(DimensionResource.marginSizeSmall),
          SingleLineShimmer(height: 10,width: 80,),
          Gap(DimensionResource.marginSizeSmall),
          SingleLineShimmer(height: 10,width: 100,),
          Gap(DimensionResource.marginSizeSmall),
          SingleLineShimmer(height: 10,width: 60,)
        ],
      ),
    );


  }
}