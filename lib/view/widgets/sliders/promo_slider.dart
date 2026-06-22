import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/yinkwell.dart';
import 'package:plants_spotify/view/widgets/common/image_enlarge_widget.dart';
import 'package:plants_spotify/view/widgets/containers/circular_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_image.dart';
import 'package:plants_spotify/view/widgets/sliders/promo_slider_controller.dart';



class YPromoSlider extends StatelessWidget {
  const YPromoSlider({
    super.key, required this.banners, this.height, this.width, this.showIndex = true, this.autoplay = true,  this.enlargeCenterPage = true, this.aspectRatio, this.viewportFraction,this.enableInfiniteScroll =false, this.sliderIndicatorMargin, this.onPageChanged, this.isNetworkImage =true, this.fit, this.imageBorderRadius, this.viewAll = false,
  });
  final List<String> banners;
  final double? height;
  final double? width;
  final bool? showIndex;
  final bool viewAll;

  final bool autoplay;
  final bool enlargeCenterPage;
  final double? aspectRatio;
  final double? viewportFraction;
  final double? imageBorderRadius;

  final bool enableInfiniteScroll;
  final double? sliderIndicatorMargin;
  final Function? onPageChanged;
  final bool isNetworkImage;
  final BoxFit? fit;


  @override
  Widget build(BuildContext context) {
    final controller= Get.put(PromoSliderController());
    return YInkwell(
      onTap: (){ Navigator.of(context).push(PageRouteBuilder(opaque: false, barrierDismissible:true, pageBuilder: (BuildContext context, _, __)=>ImageEnlargeSliderWidget(imageUrl: banners, initialIndex: controller.carouselCurrentIndex.value,)));},
      child: Stack(
        children: [
          SizedBox(
            height: height,
            width: width ?? double.infinity,
            child: cs.CarouselSlider(
              options:cs.CarouselOptions(
                viewportFraction:viewportFraction ?? 0.5,
                aspectRatio:aspectRatio ?? 2,
                autoPlay: autoplay,
                enlargeCenterPage: enlargeCenterPage, // Enables enlarging the center item
                enlargeFactor: 0.6,
                scrollPhysics: const BouncingScrollPhysics(),
                enableInfiniteScroll: enableInfiniteScroll,
                onPageChanged: (index,_){
                  controller.updatePageIndicator(index);
                  onPageChanged?.call(index);
                },
              ),
              items: banners.map((url)=>YRoundedImage(isNetworkImage:isNetworkImage,imageUrl: url,borderRadius: imageBorderRadius??0,fit: fit,height: height,width: width,)).toList(),
            ),
          ),
        if(showIndex! && banners.length > 1)
          Positioned(
            bottom: 30,
            left: 0,
            right: 0  ,
            child: showIndex! ? Obx(()=> Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for(int i = 0;i<banners.length;i++)
                  YCircularContainer(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.all(0),
                    backgroundColor: controller.carouselCurrentIndex.value == i?ColorResource.instance.white:ColorResource.instance.lightGrey,).paddingSymmetric(horizontal: DimensionResource.paddingSizeExtraExtraSmall)
              ],
            ) ,
            ): SizedBox(),
          ),
        if(viewAll)
        Positioned(
            right: 0,
            bottom: 0,
            child: YRoundedContainer(
              padding: EdgeInsets.all(DimensionResource.paddingSizeExtraSmall),
              backgroundColor: ColorResource.instance.black.withValues(alpha: 0.38),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(6)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.image,color: ColorResource.instance.white.withValues(alpha: 0.6),size: 10,),
                  Gap(5),
                  Text("view_all".tr,style: StyleResource.instance.styleMedium(DimensionResource.fontSizeExtraSmall-3, ColorResource.instance.white),),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class YPromoSliderStyle2 extends StatelessWidget {
  const YPromoSliderStyle2({
    super.key, required this.banners, this.height, this.width, this.showIndex = true, this.autoplay = true,  this.enlargeCenterPage = true, this.aspectRatio, this.viewportFraction,this.enableInfiniteScroll =false, this.sliderIndicatorMargin, this.onPageChanged, this.isNetworkImage =true, this.fit, this.imageBorderRadius, this.initialPage = 0,
  });
  final List<String> banners;
  final double? height;
  final double? width;
  final bool? showIndex;
  final bool autoplay;
  final bool enlargeCenterPage;
  final double? aspectRatio;
  final double? viewportFraction;
  final double? imageBorderRadius;
  final int initialPage;

  final bool enableInfiniteScroll;
  final double? sliderIndicatorMargin;
  final Function? onPageChanged;
  final bool isNetworkImage;
  final BoxFit? fit;


  @override
  Widget build(BuildContext context) {
    final controller= Get.put(PromoSliderController2());
    SchedulerBinding.instance.addPostFrameCallback((_) {
      controller.carouselCurrentIndex.value = initialPage;
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(),
        SizedBox(
          height: height,
          width: width ?? double.infinity,
          child: cs.CarouselSlider(
            options:cs.CarouselOptions(
              viewportFraction:viewportFraction ?? 0.5,
              aspectRatio:aspectRatio ?? 2,
              autoPlay: autoplay,
              enlargeCenterPage: enlargeCenterPage, // Enables enlarging the center item
              enlargeFactor: 0.6,
              scrollPhysics: const BouncingScrollPhysics(),
              enableInfiniteScroll: enableInfiniteScroll,
              initialPage: initialPage,
              onPageChanged: (index,_){
                controller.updatePageIndicator(index);
                onPageChanged?.call(index);
              },
            ),
            items: banners.map((url)=>YRoundedImage(isNetworkImage:isNetworkImage,imageUrl: url,borderRadius: imageBorderRadius??0,fit: fit,height: height,width: width,)).toList(),
          ),
        ).paddingOnly(bottom: DimensionResource.paddingSizeDefault),
        if(showIndex! && banners.length > 1)
          showIndex! ? Obx(()=> Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for(int i = 0;i<banners.length;i++)
                YCircularContainer(
                  width: controller.carouselCurrentIndex.value == i ? 25 : 8,
                  height: 8,
                  margin: const EdgeInsets.all(0),
                  backgroundColor: controller.carouselCurrentIndex.value == i?ColorResource.instance.white:ColorResource.instance.lightGrey,).paddingSymmetric(horizontal: DimensionResource.paddingSizeExtraExtraSmall)
            ],
          ) ,
          ): SizedBox(),
      ],
    );
  }
}

class PromoSliderController extends GetxController{
  static PromoSliderController get instance => Get.find();
  final carouselCurrentIndex = 0.obs;
  void updatePageIndicator(index){
    carouselCurrentIndex.value=index;
  }
}

class PromoSliderController2 extends GetxController{
   RxBool isOpen = false.obs;
  static PromoSliderController get instance => Get.find();
  final carouselCurrentIndex = 0.obs;
  void updatePageIndicator(index){
    carouselCurrentIndex.value=index;
  }
}