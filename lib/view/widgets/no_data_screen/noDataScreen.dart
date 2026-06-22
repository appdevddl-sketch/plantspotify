
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/image_resource.dart';
import '../../../model/utils/style_resource.dart';
import '../button_view/common_button.dart';


class NoDataFoundScreen extends StatelessWidget {
  final String ?message;
  final VoidCallback ?onRefresh;
  final  double? imageHeight;
  final  Color? backgroundColor;
  const NoDataFoundScreen({super.key, this.message, this.onRefresh, this.imageHeight, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? ColorResource.instance.white,
      body: RefreshIndicator(
        color: ColorResource.instance.btnGreenColor,
        onRefresh: () async {
          onRefresh?.call();
        },
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: ListView(
                padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  Lottie.asset(ImageResource.instance.dataNotFoundAnimation  ,height: imageHeight?? 350,repeat: false,),
                  // Image.asset(ImageResource.instance.plantNotFoundImage,height: 350,),
                  const SizedBox(height: 20,),
                  Text(
                    message ?? "No data available!".tr,
                    style: StyleResource.instance.styleMedium(DimensionResource.fontSizeLarge, ColorResource.instance.textColor_2),textAlign: TextAlign.center,
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
