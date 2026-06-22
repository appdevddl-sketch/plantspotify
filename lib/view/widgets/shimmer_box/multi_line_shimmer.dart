import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/box_shadow_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:shimmer/shimmer.dart';

import '../../../model/utils/color_resource.dart';
class MultiLineShimmer extends StatelessWidget {
  const MultiLineShimmer({Key? key, this.height=30, this.length, this.physics, this.width, this.radius, this.padding}) : super(key: key);

  final double? height;
  final double? width;
  final double? radius;
  final double? padding;
  final int? length;
  final ScrollPhysics? physics;


  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        physics: physics ?? NeverScrollableScrollPhysics(),
        child: Column(
          children: List.generate(length ?? 5, (index){
            return YRoundedContainer(height: height,width: width,radius: radius ?? 13).paddingOnly(bottom: padding ?? DimensionResource.marginSizeSmall);
          }),
        ),
      ),

    );
  }
}
