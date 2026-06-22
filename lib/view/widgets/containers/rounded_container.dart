
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/yinkwell.dart';




class YRoundedContainer extends StatelessWidget {
  const YRoundedContainer({
    super.key,
    this.width,
    this.height,
    this.radius=DimensionResource.cardRadiusLg,
    this.child,
    this.showBorder=false,
    this.borderColor,
    this.backgroundColor,
    this.padding, this.margin, this.gradient, this.boxshadow,
    this.borderWidth =1, this.borderRadius, this.boxConstraints, this.alignment, this.onTap,
  });
 final double? width;
 final double? height;
 final double radius;
  final double borderWidth;
 final Widget? child;
 final bool showBorder;
 final Color? borderColor;
 final Color? backgroundColor;
  final Alignment? alignment;
  final VoidCallback? onTap;

 final EdgeInsetsGeometry? padding;
 final EdgeInsetsGeometry? margin;
  final Gradient? gradient;
  final List<BoxShadow>? boxshadow;
  final BorderRadius? borderRadius;
  final BoxConstraints? boxConstraints;

  @override
  Widget build(BuildContext context) {
    return YInkwell(
      onTap: onTap,
      child: Container(
        alignment: alignment,
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        constraints: boxConstraints,
        decoration: BoxDecoration(
          color: backgroundColor ?? ColorResource.instance.white,
          borderRadius: borderRadius ?? BorderRadius.circular(radius),
          border: showBorder ? Border.all(color: borderColor ??ColorResource.instance.grey_1,width:borderWidth) : null,

          boxShadow: boxshadow,
          gradient: gradient
        ),
        child: child  ,
      ),
    );
  }
}
