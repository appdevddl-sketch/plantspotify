import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';

class YBoxshadowContainer extends StatelessWidget {
  const YBoxshadowContainer({
    super.key, required this.child, this.padding, this.boxShadow, this.width, this.backgroundColor, this.height, this.showBoxShadow=true, this.showBorder, this.boxShadowColor, this.radius,
  });
  final Widget child;
  final EdgeInsets? padding;
  final BoxShadow? boxShadow;
  final double? width;
  final double? height;
  final double? radius;
  final bool showBoxShadow;
  final bool? showBorder;
  final Color? backgroundColor;
  final Color? boxShadowColor;





  @override
  Widget build(BuildContext context) {
    return YRoundedContainer(
      radius: radius??DimensionResource.cardRadiusLg,
      backgroundColor: backgroundColor ??ColorResource.instance.white,
      showBorder: showBorder ?? false,
      width: width??HelperFunction.screenWidth(),
      height: height,
      padding: padding ?? EdgeInsets.all(DimensionResource.marginSizeLarge),
      boxshadow: showBoxShadow?[
        boxShadow ?? BoxShadow(
          color: boxShadowColor??ColorResource.instance.lightGrey,
          offset: Offset(0, 2),
          blurRadius: 2,
        ),
      ]:[],
      child:child,
    );
  }
}
