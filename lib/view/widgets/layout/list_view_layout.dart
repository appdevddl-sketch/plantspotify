import 'package:flutter/material.dart';

class YListView extends StatelessWidget {
  const YListView({
    super.key,
    required this.count,
    required this.itemBuilder,
    this.scrollDirection,
    this.scrollPhysics,
    this.padding,
  });

  final int count;
  final Axis? scrollDirection;
  final ScrollPhysics? scrollPhysics;
  final EdgeInsetsGeometry? padding;
  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: padding,
      itemCount: count,
      scrollDirection: scrollDirection ?? Axis.vertical,
      physics: scrollPhysics ?? const NeverScrollableScrollPhysics(),
      itemBuilder: itemBuilder,
    );
  }
}
