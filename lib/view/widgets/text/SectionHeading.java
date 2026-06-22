import 'package:common_setup/resource/style_resource.dart';
import 'package:common_setup/resource/super/dimensions_resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:util_resource/util/resource/color_resource.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key, this.textColor,  this.showActionButton=true, required this.title, this.onPressed, this.subTitle, this.actionButtonText, required this.showSubTitle, this.padding, this.titleSize, this.actionButtonTextStyle,
  });
  final Color? textColor;
  final bool showActionButton;
  final bool showSubTitle;
  final double? titleSize;
  final String title;
  final String? subTitle;
  final String? actionButtonText;
  final EdgeInsets? padding;
  final VoidCallback? onPressed;
  final TextStyle? actionButtonTextStyle;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,style: StyleResource.instance.styleExtraBold(titleSize??DimensionResource.fontSizeOverLarge, ColorResource.black),maxLines: 2, overflow: TextOverflow.ellipsis),
              if(showSubTitle) Text(subTitle!,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall , ColorResource.black),maxLines: 1, overflow: TextOverflow.ellipsis),
            ]
        ),
        if(showActionButton) InkWell(onTap: onPressed, child:Text(actionButtonText ?? "",style: actionButtonTextStyle ?? StyleResource.instance.styleSemiBold(DimensionResource.fontSizeLarge, ColorResource.mainColor)))
      ],
    );
  }
}