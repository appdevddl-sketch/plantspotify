import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/box_shadow_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:shimmer/shimmer.dart';

import '../../../model/utils/color_resource.dart';
class SingleLineShimmer extends StatelessWidget {
  const SingleLineShimmer({Key? key, this.height =30, this.width, this.radius                                                                                                                                                                               }) : super(key: key);
  final double? height;
  final double? width;
  final double? radius;



  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: YRoundedContainer(height: height,width: width,radius: radius ?? DimensionResource.cardRadiusLg),
    );
  }
}
