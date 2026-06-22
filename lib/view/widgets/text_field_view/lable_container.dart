import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/style_resource.dart';

class LabelContainer extends StatelessWidget {
  final Widget child;
  final String label;
  final Color? labelColor;
  final double? fontSize;
  final TextStyle? labelStyle;
  final bool isRequired;
  final String? errorText;
  final double? paddingTop;
  final CrossAxisAlignment ?crossAxisAlignment;
  final EdgeInsets ? padding;


  const LabelContainer(
      {Key? key,
      required this.child,
      required this.label,
      this.errorText,
      this.isRequired = false,
      this.paddingTop,
      this.fontSize,
      this.crossAxisAlignment,
      this.labelColor, this.labelStyle,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.zero,
      width: double.infinity,
      child: Column(crossAxisAlignment: crossAxisAlignment??CrossAxisAlignment.start, children: [
        RichText(text: TextSpan(
            children: [
                TextSpan(
                    text: label,
                    style: labelStyle??StyleResource.instance.styleMedium(fontSize??DimensionResource.fontSizeDefault, labelColor ?? ColorResource.instance.textDarkGreenColor)
                ),
              if(isRequired)
                TextSpan(
                    text: "*",
                    style: StyleResource.instance.styleSemiBold(fontSize??DimensionResource.fontSizeDefault,  ColorResource.instance.darkRedColor)
                ),
            ]
        )),
        SizedBox(
          height: paddingTop??DimensionResource.marginSizeSmall,
        ),
        child,
        errorText == null || errorText == ""
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
                child: Text(
                  errorText ?? "",
                  style: StyleResource.instance.styleRegular(
                      DimensionResource.fontSizeSmall,
                      ColorResource.instance.redColor),
                  textAlign: TextAlign.start,
                ),
              ),
      ]),
    );
  }
}

class ErrorContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final String errorText;
  const ErrorContainer(
      {Key? key,
      required this.child,
        required this.errorText, this.padding,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        child,
        errorText == ""
            ? const SizedBox(height: 0,)
            : Padding(
          padding: padding ?? const EdgeInsets.only(left: DimensionResource.paddingSizeDefault, right: 0, top: 5, bottom: 5),
          child: Text(
            errorText,
            style: StyleResource.instance.styleRegular(
                DimensionResource.fontSizeSmall,
                ColorResource.instance.darkRedColor),
            textAlign: TextAlign.start,
          ),
        ),
      ]),
    );
  }
}
