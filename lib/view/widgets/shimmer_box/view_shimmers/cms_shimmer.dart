import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CmsShimmer extends StatelessWidget {
  const CmsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            15,
                (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                height: 14,
                width: index % 3 == 0
                    ? double.infinity
                    : MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
