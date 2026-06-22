
import 'package:flutter/material.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
class RoundedCapsules extends StatelessWidget {
  const RoundedCapsules({
    super.key, this.height, this.radius, this.borderColor, this.showBorder, this.padding, this.backgroundColor, required this.child, this.width,
  });
  final double? height;
  final double? radius;
  final Color? borderColor;
  final Color? backgroundColor;
  final bool? showBorder;
  final Widget child;
  final EdgeInsets? padding;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: YRoundedContainer(
        showBorder: showBorder ?? true,
        borderColor: borderColor ?? ColorResource.instance.grey.withOpacity(0.6),
        radius: radius ?? DimensionResource.cardRadiusXl,
        height: height ?? 32,
        backgroundColor: backgroundColor ?? ColorResource.instance.white,
        padding: padding ?? const EdgeInsets.only(top:DimensionResource.paddingSizeExtraSmall,bottom: DimensionResource.paddingSizeExtraSmall,left: DimensionResource.paddingSizeDefault,right: DimensionResource.paddingSizeDefault),
        child: child,
      ),
    );
  }
}