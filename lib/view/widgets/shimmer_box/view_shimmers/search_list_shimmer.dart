import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:shimmer/shimmer.dart';

class PlantGridShimmer extends StatelessWidget {
  const PlantGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 250,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const PlantCardShimmer(),
    );
  }
}
class PlantCardShimmer extends StatelessWidget {
  const PlantCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return YRoundedContainer(
      padding: EdgeInsets.all(DimensionResource.paddingSizeExtraSmall),
      showBorder: true,
      borderColor: Colors.grey.shade100,
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 180,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.shade100),
              ),
            ),
          ).paddingOnly(bottom: DimensionResource.marginSizeSmall),

          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 10,
              width: 50,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.shade100),
              ),
            ),
          ).paddingOnly(bottom: DimensionResource.marginSizeExtraSmall),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 10,
              width: 80,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.shade100),
              ),
            ),
          ).paddingOnly(bottom: DimensionResource.marginSizeExtraSmall),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 10,
              width: 100,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.shade100),
              ),
            ),
          ).paddingOnly(bottom: DimensionResource.marginSizeExtraSmall),

        ],
      ),
    );
  }
}
