import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';

class FaqShimmerScreen extends StatelessWidget {
  const FaqShimmerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        /// ================= BOTTOM LEAF =================
        Positioned(
          bottom: 0,
          left: 0,
          child: Image.asset(
            ImageResource.instance.leaf11Image,
            width: HelperFunction.screenWidth() * .50,
          ),
        ),

        /// ================= CONTENT =================
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DimensionResource.paddingSizeDefault,
            vertical: DimensionResource.paddingSizeDefault,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// FAQ TITLE
              _shimmerLine(width: 40, height: 14),
              Gap(DimensionResource.paddingSizeDefault),

              /// FAQ LIST
              Expanded(
                child: ListView.builder(
                  itemCount: 8,
                  itemBuilder: (_, __) => _faqItem(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// ================= FAQ ITEM (ExpansionTile clone) =================
  Widget _faqItem() {
    return Container(
      margin: const EdgeInsets.only(
        bottom: DimensionResource.marginSizeSmall,
      ),
      decoration: BoxDecoration(
        color: ColorResource.instance.white,
        border: Border.all(
          color: ColorResource.instance.dividerGrey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DimensionResource.marginSizeDefault,
          vertical: DimensionResource.marginSizeSmall,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ANSWER (collapsed placeholder space)
            _shimmerLine(height: 12),
            const Gap(6),
            _shimmerLine(height: 12, width: 200),
          ],
        ),
      ),
    );
  }

  /// ================= SHIMMER HELPERS =================

  Widget _shimmer(Widget child) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: child,
    );
  }

  Widget _shimmerLine({
    double width = double.infinity,
    required double height,
  }) {
    return _shimmer(
      Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _shimmerCircle(double size) {
    return _shimmer(
      Container(
        height: size,
        width: size,
        decoration: const BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
