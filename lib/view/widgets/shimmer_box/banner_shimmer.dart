import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../model/utils/color_resource.dart';
class BannerShimmerUi extends StatelessWidget {
  const BannerShimmerUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorResource.instance.grey_1,
      highlightColor: ColorResource.instance.white,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: ColorResource.instance.grey_1),
        margin:const EdgeInsets.symmetric(horizontal: 15),
        height: 160,
      ),
    );
  }
}
