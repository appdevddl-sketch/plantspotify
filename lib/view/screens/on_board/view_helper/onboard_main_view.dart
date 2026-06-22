import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
import 'package:plants_spotify/view/widgets/button_view/yinkwell.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/circular_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view_model/controller/on_board_controller/on_board_controller.dart';



class OnBoardingMainView extends StatelessWidget {
  const OnBoardingMainView({
    super.key, required this.controller, required this.image, required this.subtitle, this.showSkipButton=true,this.titleWidget, this.boxFit, this.bottom, this.imageHeight, this.imageWidth,
  });
  final OnBoardController controller;
  final String image;
  final double? imageHeight;
  final double? imageWidth;
  final String subtitle;
  final Widget? titleWidget;
  final BoxFit? boxFit;
  final double? bottom;



  final bool showSkipButton;



  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          //   Positioned(top:0,right:0,child: Image.asset(ImageResource.instance.leafImage,height: 200,)),
          // Positioned(child: Image.asset(ImageResource.instance.appLogo2Image,height: 200,)),


         Positioned(
           bottom: bottom,
             child: Container(
               color: ColorResource.instance.white,
               height: HelperFunction.screenHeight(),
               width: HelperFunction.screenWidth(),
               child: Column(
                 children: [
                   Expanded(
                     child: Stack(

                       children: [
                         Positioned(top:0,right:0,child: Image.asset(ImageResource.instance.leafImage,height: 200,)),
                         Positioned.fill(child: Image.asset(image,width: imageWidth ?? HelperFunction.screenWidth(),fit: boxFit ?? BoxFit.cover,height: imageHeight,)),
                       ],
                     ),
                   ),

                   SizedBox(height: 200,width: HelperFunction.screenWidth(),)
                 ],
               ),
             )),
          Positioned.fill(child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [ColorResource.instance.black,ColorResource.instance.black.withValues(alpha: 0.3),ColorResource.instance.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.1,0.4,1]
                )
            ),
          )),
          Positioned(
            bottom: 0,
            child: Container(
              width: HelperFunction.screenWidth(),
              height: 245,


              decoration: BoxDecoration(
                // boxShadow: [
                //   BoxShadow(
                //     color: ColorResource.instance.black.withValues(alpha: 0.7),
                //     blurRadius: 50,
                //     spreadRadius: 45,
                //     offset: Offset(0, -4),
                //   ),
                // ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(65),
                ),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    YRoundedContainer(
                      radius: 0,
                      boxshadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: Offset(0, -4),
                        ),
                      ],
                      padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
                      gradient: LinearGradient(
                        colors: [ Color(0xff103303),  ColorResource.instance.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),

                      width: HelperFunction.screenWidth(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          titleWidget ?? SizedBox(),
                          Text(subtitle,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeDefault, ColorResource.instance.white),).paddingOnly(top: DimensionResource.paddingSizeDefault,bottom: DimensionResource.paddingSizeDefault * 2),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildCircles(context,controller),
                              InkWell(
                                onTap: ()=>controller.nextPage(),
                                child: YRoundedContainer(
                                  radius: 25,
                                  backgroundColor: ColorResource.instance.mainColor,
                                  padding: EdgeInsets.symmetric(horizontal:DimensionResource.paddingSizeLarge * 2,vertical:DimensionResource.paddingSizeSmall),
                                  child: Text("next".tr,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.white),),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: -20,
                        child: Image.asset(ImageResource.instance.leaf3Image,height: 200,width: 200 ,)
                    )

                  ],
                ),
              ),
            ),
          ),
          Positioned(top:40,right:30,child: YInkwell(onTap: ()=>controller.skipPage(),child: Text("skip".tr,style: StyleResource.instance.styleMedium(DimensionResource.fontSizeDefault, ColorResource.instance.white),)))


        ],
    );
  }
}


Widget _buildCircles(BuildContext context, OnBoardController controller) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) => _buildDot(index, context, controller),
      ));
}
Widget _buildDot(int index, BuildContext context, OnBoardController controller) {
  return Obx(
      ()=> YCircularContainer(
        width: controller.currentPageIndex.value == index ? 20 : 10,
        height: 4,
        margin: const EdgeInsets.only(right: 10),
        backgroundColor:controller.currentPageIndex.value == index ? ColorResource.instance.mainColor : ColorResource.instance.grey_3),
  );
}