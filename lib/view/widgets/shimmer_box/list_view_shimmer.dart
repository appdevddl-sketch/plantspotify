import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/box_shadow_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/layout/list_view_layout.dart';
import 'package:shimmer/shimmer.dart';

import '../../../model/utils/color_resource.dart';
class ListViewShimmer extends StatelessWidget {
  const ListViewShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: HelperFunction.screenWidth(),height: 200,
        child: YListView(count: 6,scrollDirection: Axis.horizontal, itemBuilder: (context,index){
          return YRoundedContainer(radius:35,child: SizedBox(),width: 170,height: 200,).paddingOnly(right: DimensionResource.marginSizeDefault);
        }),
      ),
    );
  }
}
