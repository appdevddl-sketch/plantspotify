import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/style_resource.dart';
import '../loader_helper/loader_helper_ui.dart';

class CommonWidgetButton extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final bool loading;
  final bool? showBorder;
  final Color ?color;
  final Color ?borderColor;
  final Color? textColor;
  final double? textSize;
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsets? padding;
  final bool? isWidget;
  final Widget? widget;




  const CommonWidgetButton(
      {super.key,
        this.text,
        required this.loading,
        required this.onPressed, this.color,
        this.textColor,
        this.width,
        this.borderRadius,
        this.showBorder,
        this.height,
        this.borderColor,
        this.padding,
        this.textSize, this.margin, this.isWidget = true, this.widget});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: padding,
        height: height ?? 55,
        width: width ?? double.infinity,
        alignment: Alignment.center,
        margin: margin??EdgeInsets.zero,
        decoration: BoxDecoration(
          border: Border.all(color:borderColor??color??ColorResource.instance.btnGreenColor,),
          color: color??ColorResource.instance.btnGreenColor,
          borderRadius: BorderRadius.circular(borderRadius ?? DimensionResource.buttonRadius),),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius ?? DimensionResource.buttonRadius),
          child: MaterialButton(
              onPressed: onPressed,
              child: Center(
                  child: loading == true
                      ? loaderHelperUi(radius: 12, loaderColor: ColorResource.instance.white)
                      : isWidget! ? widget : Text(text??"".tr,
                      style: StyleResource.instance.styleSemiBold(
                          textSize ?? DimensionResource.fontSizeExtraLarge,
                          textColor ?? ColorResource.instance.white),maxLines: 1,textAlign: TextAlign.center)
              )),
        ));
  }
}

