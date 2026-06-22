import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:get/get.dart';
class SubscriptionShimmer extends StatelessWidget {
  const SubscriptionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: HelperFunction.screenWidth(),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffF0FFDF),
              Color(0xffF0FFDF),
              Color(0xffFFFFFF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.3, 0.5],
          ),
        ),
        child: Column(
          children: [
            Gap(DimensionResource.appBarHeight * 2),

            SizedBox(
              height: HelperFunction.screenWidth() * .50,
              child: Center(
                child: _shimmerCard(
                  width: HelperFunction.screenWidth() ,
                  height: HelperFunction.screenWidth() * .55,
                ),
              ),
            ).paddingOnly(bottom: DimensionResource.paddingSizeDefault * 5),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                    (_) => _shimmerCircle(40)
                    .paddingSymmetric(horizontal: DimensionResource.paddingSizeSmall),
              ),
            ).paddingOnly(bottom: DimensionResource.paddingSizeDefault),

            SizedBox(
              height: HelperFunction.screenWidth() * .60,
              child: Center(
                child: _shimmerCard(
                  width: HelperFunction.screenWidth() * .60,
                  height: HelperFunction.screenWidth() * .55,
                ),
              ),
            ).paddingOnly(bottom: DimensionResource.paddingSizeDefault),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DimensionResource.paddingSizeDefault,
              ),
              child: _shimmerPill(
                width: HelperFunction.screenWidth(),
                height: 50,
              ),
            ),

            Gap(DimensionResource.marginSizeDefault * 2),
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
    required double width,
    required double height,
  }) {
    return _shimmer(
      Container(
        width: width,
        height: height,
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

  Widget _shimmerBox(double width, double height) {
    return _shimmer(
      Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _shimmerCard({
    required double width,
    required double height,
  }) {
    return _shimmer(
      Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _shimmerPill({
    required double width,
    required double height,
  }) {
    return _shimmer(
      Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
