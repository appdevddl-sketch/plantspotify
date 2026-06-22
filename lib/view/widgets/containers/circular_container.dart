import 'package:flutter/material.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';


class YCircularContainer extends StatelessWidget {
  const YCircularContainer({
    super.key,
    this.width=400,
    this.height=400,
    this.radius=400,
    this.padding=0,
    this.child,
    this.backgroundColor, this.margin,this.showBorder=false,
    this.borderColor,
  });
  final double? width;
  final double? height;
  final double radius;
  final double padding;
  final EdgeInsets? margin;
  final Widget? child;
  final Color? backgroundColor;
  final bool showBorder;
  final Color? borderColor;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: backgroundColor ??ColorResource.instance.white,
          border: showBorder ? Border.all(color: borderColor ?? ColorResource.instance.grey_1) : null,
      ),
        child: child,
    );
  }
}