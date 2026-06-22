import 'package:flutter/material.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key, this.textColor,  this.showActionButton=true, required this.title, this.onPressed, this.subTitle, this.actionButtonText, required this.showSubTitle, this.padding,
  });
  final Color? textColor;
  final bool showActionButton;
  final bool showSubTitle;
  final String title;
  final String? subTitle;
  final String? actionButtonText;
  final EdgeInsets? padding;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: DimensionResource.paddingSizeLarge),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,style: StyleResource.instance.styleExtraBold(DimensionResource.fontSizeExtraLarge, ColorResource.instance.black),maxLines: 2, overflow: TextOverflow.ellipsis),
                  if(showSubTitle) Text(subTitle??"",style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall , ColorResource.instance.black),maxLines: 1, overflow: TextOverflow.ellipsis),
                ]
            ),
          ),
          if(showActionButton) InkWell(onTap: onPressed, child:Text(actionButtonText ?? "",style: StyleResource.instance.styleRegular(  DimensionResource.fontSizeDefault, ColorResource.instance.textColor_9)))
        ],
      ),
    );
  }
}