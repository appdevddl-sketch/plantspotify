import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class QuestionsShimmer extends StatelessWidget {
  const QuestionsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Info Banner
          _shimmerBox(height: 36, radius: 8),
          const SizedBox(height: 20),

          /// Question
          _shimmerBox(height: 22, width: 220),
          const SizedBox(height: 16),

          /// Options
          ...List.generate(4, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  _shimmerCircle(size: 36),
                  const SizedBox(width: 12),
                  Expanded(child: _shimmerBox(height: 18)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _shimmerBox({
    double height = 16,
    double width = double.infinity,
    double radius = 6,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  Widget _shimmerCircle({double size = 32}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: size,
        width: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
