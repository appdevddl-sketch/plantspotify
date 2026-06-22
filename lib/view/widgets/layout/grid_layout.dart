
import 'package:flutter/material.dart';


class YGridLayout extends StatelessWidget {
  const YGridLayout({
    super.key,
    required this.itemCount,
    this.mainAxisExtent = 288,
    required this.itemBuilder, this.crossAxisCount,required this.crossAxisSpacing,required this.mainAxisSpacing, this.isScrollable = false, this.padding,
  });
  final int itemCount;
  final double? mainAxisExtent;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final bool? isScrollable;
  final Widget? Function(BuildContext, int) itemBuilder;
  final int? crossAxisCount;
  final EdgeInsets? padding;


  @override
  Widget build(BuildContext context) {
    return GridView.builder(

      padding: padding,
      itemCount: itemCount,
      shrinkWrap: true,
      physics: isScrollable!
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount ?? 2,
          mainAxisExtent: mainAxisExtent,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
      ),
      itemBuilder: itemBuilder,
    );
  }
}