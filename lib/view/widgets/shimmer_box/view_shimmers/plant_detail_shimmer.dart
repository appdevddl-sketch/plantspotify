import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius borderRadius;

  const ShimmerBox({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
class PlantDetailShimmer extends StatelessWidget {
  const PlantDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(
            height: 180,
            width: double.infinity,
            borderRadius: BorderRadius.circular(16),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              4,
                  (index) => ShimmerBox(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.20,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 24),

          ShimmerBox(height: 24, width: 160),

          const SizedBox(height: 16),


          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.2,
            ),
            itemBuilder: (_, __) {
              return ShimmerBox(
                height: 70,
                width: double.infinity,
                borderRadius: BorderRadius.circular(12),
              );
            },
          ),

          const SizedBox(height: 24),


          ShimmerBox(height: 22, width: 140),

          const SizedBox(height: 12),


          Column(
            children: List.generate(
              3,
                  (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ShimmerBox(
                  height: 14,
                  width: double.infinity,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          ShimmerBox(height: 22, width: 160),

          const SizedBox(height: 12),

          Column(
            children: List.generate(
              3,
                  (index) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ShimmerBox(
                  height: 16,
                  width: double.infinity,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
