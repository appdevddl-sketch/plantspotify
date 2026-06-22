import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/services/auth_service.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/yinkwell.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/sliders/promo_slider.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';

import '../../../model/utils/color_resource.dart';
import '../cached_network_image_widget/cachednetworkimagewidget.dart';


class ImageEnlargeWidget extends StatelessWidget {
  final String imageUrl;
  final BoxFit ?boxFit;
  final VoidCallback ?onTap;
  final EdgeInsetsGeometry ?imagePadding;
  final double? radius;



  const ImageEnlargeWidget({Key? key, required this.imageUrl,this.boxFit,this.onTap, this.imagePadding, this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    imageUrl.logPrint();
    return Scaffold(
      backgroundColor: ColorResource.instance.black.withValues(alpha: .5),
      body: GestureDetector(
        onTap: ()=>Get.back(),
        child: Container(
          padding: imagePadding??EdgeInsets.all(DimensionResource.paddingSizeDefault) ,
          color: ColorResource.instance.black.withValues(alpha: .1),
          child: Center(
            child: Hero(
              tag:imageUrl,
              child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(radius?? 8)),child: CachedNetworkImageWidget(imageUrl:imageUrl,fit: BoxFit.contain)),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageEnlargeSliderWidget extends StatelessWidget {
  final List<String> imageUrl;
  final BoxFit ?boxFit;
  final VoidCallback ?onTap;
  final EdgeInsetsGeometry ?imagePadding;
  final double? radius;
  final int initialIndex;



  const ImageEnlargeSliderWidget({Key? key, required this.imageUrl,this.boxFit,this.onTap, this.imagePadding, this.radius, this.initialIndex = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    imageUrl.logPrint();
    return Scaffold(
      backgroundColor: ColorResource.instance.black.withValues(alpha: .5),
      body: GestureDetector(
        onTap: ()=>Get.back(),
        child: Container(
          padding: imagePadding??EdgeInsets.all(DimensionResource.paddingSizeDefault) ,
          color: ColorResource.instance.black.withValues(alpha: .1),
          child: Center(
            child: Hero(
              tag:imageUrl,
              child: YPromoSliderStyle2(
                height: HelperFunction.screenHeight() * .90 ,
                width: HelperFunction.screenWidth(),
                autoplay: false,
                imageBorderRadius: 15,
                isNetworkImage: true,
                viewportFraction: 1,
                aspectRatio: 1,
                fit: BoxFit.contain,
                banners: imageUrl,
                initialPage: initialIndex,
              )

            ),
          ),
        ),
      ),
    );
  }
}