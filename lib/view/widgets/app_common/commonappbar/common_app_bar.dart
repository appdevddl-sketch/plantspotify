
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/yinkwell.dart';

class InViewAppBar extends StatelessWidget {
  const InViewAppBar({
    super.key, this.padding, this.showBackArrow = true, this.showCloseIcon=true, this.showtitle =false, this.onTapback, this.onTapClose, this.title, this.primaryImage, this.secondaryImage, this.showCustomTitle = false, this.customTitle,
  });
  final EdgeInsets? padding;
  final bool showBackArrow;
  final bool showCloseIcon;
  final bool showtitle;
  final String? title;
  final Widget? primaryImage;
  final Widget? secondaryImage;
  final VoidCallback? onTapback;
  final VoidCallback? onTapClose;
  final bool showCustomTitle;
  final Widget? customTitle;



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: DimensionResource.paddingSizeDefault),
      child: Column(
        children: [
          Gap(DimensionResource.appBarHeight),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              showBackArrow ? YInkwell(onTap: onTapback ?? ()=>Get.back(),child: primaryImage ?? Image.asset(ImageResource.instance.backArrowIcon,height: DimensionResource.iconSizeSmall,)) : SizedBox() ,
              if(showCustomTitle)customTitle?? SizedBox.shrink(),
              if(!showCustomTitle) showtitle ? Text(title??"",style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeLarge, ColorResource.instance.textColor_2),) : SizedBox(),
              showCloseIcon ? YInkwell(onTap: onTapClose,child: secondaryImage ?? Image.asset(ImageResource.instance.closeIcon,height: DimensionResource.iconSizeSmall,)) : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
