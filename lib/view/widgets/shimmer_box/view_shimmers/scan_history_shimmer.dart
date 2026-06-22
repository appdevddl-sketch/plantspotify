import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:shimmer/shimmer.dart';

class ScanHistoryShimmer extends StatelessWidget {
  const ScanHistoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {


    return ListView.builder(
      itemCount: 8, // number of shimmer items
      itemBuilder: (context, index) {
        return _buildCard().marginAll(DimensionResource.marginSizeSmall);
      },
    );


  }
  Widget _buildCard(){
    return YRoundedContainer(

      width: HelperFunction.screenWidth(),
      padding: const EdgeInsets.all(12),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image placeholder
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 12),

          /// Text placeholders
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(width: 120, height: 14),
                const SizedBox(height: 8),
                _line(width: 160, height: 12),
                const SizedBox(height: 12),

                /// Button / status placeholder
                _line(width: 100, height: 16, radius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _line({
    required double width,
    required double height,
    double radius = 8,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
