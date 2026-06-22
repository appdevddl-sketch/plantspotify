

import 'package:flutter/material.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
class YInkwell extends StatelessWidget {
  const YInkwell({
    super.key,  this.onTap, required this.child,
  });
  final VoidCallback? onTap;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: child,
    );
  }
}