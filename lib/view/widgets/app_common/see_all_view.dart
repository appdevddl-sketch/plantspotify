import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
class SeeAllUI extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  final Widget child;
  final double ?bottomPadding;
  final double ?leftPadding;
  final double ?rightPadding;

  const SeeAllUI({super.key, required this.title, required this.onSeeAll, required this.child, this.bottomPadding, this.leftPadding, this.rightPadding});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Expanded(child: Text(title,style: StyleResource.instance.styleBold(DimensionResource.fontSizeDoubleExtraLarge, ColorResource.instance.mainColor),)),
          TextButton( style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeSmall,vertical: DimensionResource.marginSizeExtraSmall),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.center),onPressed: onSeeAll, child: Text('SEE ALL'.tr,style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeDefault, ColorResource.instance.extraDarkGrey),))

        ],).paddingOnly(bottom: bottomPadding??DimensionResource.marginSizeDefault,left: leftPadding??0,right:rightPadding??0 ),
        child
      ],
    );
  }
}
