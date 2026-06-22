import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
import 'package:plants_spotify/view/widgets/button_view/yinkwell.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';
class ImageTooBlurryScreen extends StatelessWidget {
  const ImageTooBlurryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResource.instance.white,
        body: Container(
        padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(ImageResource.instance.imageTooBlurryImage,),
              Text("image_too_blurry".tr,style: StyleResource.instance.styleBold(DimensionResource.fontSizeLarge, ColorResource.instance.black),).paddingOnly(bottom: DimensionResource.marginSizeDefault),
              Text("image_too_blurry_subtitle".tr,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.black),).paddingOnly(bottom: DimensionResource.marginSizeDefault),
              CommonButton(color: ColorResource.instance.btnGreenColor,height: 40,textSize: DimensionResource.fontSizeExtraSmall,padding: EdgeInsets.all(DimensionResource.marginSizeExtraSmall),text: "capture_again".tr, loading: false, onPressed: ()=>Get.offAllNamed(Routes.rootView)).paddingOnly(bottom: DimensionResource.marginSizeDefault),
              YInkwell(onTap: ()=>Get.offAllNamed(Routes.rootView),child: Text("cancel".tr,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.black),).paddingOnly(bottom: DimensionResource.marginSizeSmall)),

            ],
          ),
        ),
      ),
    );
  }
}
