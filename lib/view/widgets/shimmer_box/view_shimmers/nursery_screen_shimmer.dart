import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:shimmer/shimmer.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shared shimmer placeholder helper
// ─────────────────────────────────────────────────────────────────────────────

Widget _shimmerBox({required double height, required double width, double radius = 4}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// NurseryScreenShimmer — mirrors CollectionCard
// ─────────────────────────────────────────────────────────────────────────────

class NurseryScreenShimmer extends StatelessWidget {
  const NurseryScreenShimmer({super.key, this.itemCount});
  final int? itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: DimensionResource.marginSizeDefault,
        left: DimensionResource.marginSizeDefault,
        right: DimensionResource.marginSizeDefault,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount ?? 5,
      itemBuilder: (context, index) {
        return _buildNurseryShimmerItem();
      },
    );
  }
}

Widget _buildNurseryShimmerItem() {
  return YRoundedContainer(
    height: 60,
    radius: 5,
    backgroundColor: ColorResource.instance.grey_6.withValues(alpha: 0.5),
    padding: const EdgeInsets.only(
      right: DimensionResource.paddingSizeSmall,
    ),
    child: Row(
      children: [
        /// Image — single shimmer box covering the full image area
        _shimmerBox(height: 60, width: 50, radius: 5),

        const Gap(DimensionResource.paddingSizeSmall),

        /// Title + Subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _shimmerBox(height: 14, width: 130, radius: 4),
              const Gap(DimensionResource.paddingSizeExtraExtraSmall),
              _shimmerBox(height: 11, width: 90, radius: 4),
            ],
          ),
        ),

        /// More icon
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Icon(Icons.more_vert, size: 18, color: Colors.grey.shade300),
        ),
      ],
    ),
  ).paddingOnly(bottom: DimensionResource.paddingSizeDefault);
}


// ─────────────────────────────────────────────────────────────────────────────
// CollectionViewShimmer — mirrors MyCollectionCard
// ─────────────────────────────────────────────────────────────────────────────

class CollectionViewShimmer extends StatelessWidget {
  const CollectionViewShimmer({super.key, this.itemCount});
  final int? itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        vertical: DimensionResource.marginSizeDefault,
        horizontal: DimensionResource.marginSizeDefault,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount ?? 5,
      itemBuilder: (context, index) {
        return _buildCollectionViewShimmerItem();
      },
    );
  }
}

Widget _buildCollectionViewShimmerItem() {
  return YRoundedContainer(
    radius: 10,
    padding: const EdgeInsets.all(DimensionResource.marginSizeSmall),
    showBorder: true,
    borderColor: ColorResource.instance.black.withValues(alpha: 0.1),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Image — single shimmer box covering the full image area
        _shimmerBox(height: 80, width: 80, radius: 8),

        const Gap(DimensionResource.marginSizeSmall),

        /// Title + Subtitle + "Add Note" button
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shimmerBox(height: 14, width: 140, radius: 4),
              const Gap(DimensionResource.paddingSizeExtraExtraSmall),
              _shimmerBox(height: 14, width: 100, radius: 4),
              const Gap(DimensionResource.paddingSizeSmall),
              _shimmerBox(height: 28, width: 110, radius: 7),
            ],
          ),
        ),

        /// Menu icon
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Icon(Icons.more_vert, size: 28, color: Colors.grey.shade300),
        ).paddingSymmetric(horizontal: 5),
      ],
    ),
  ).paddingOnly(bottom: DimensionResource.marginSizeDefault);
}
