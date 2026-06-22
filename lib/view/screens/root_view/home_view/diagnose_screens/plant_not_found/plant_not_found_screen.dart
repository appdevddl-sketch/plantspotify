import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';

class PlantNotFoundScreen extends StatelessWidget {
  const PlantNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: ColorResource.instance.white,
          padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
          child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    height: 35,
                    width: 35,
                    padding: const EdgeInsets.all(DimensionResource.marginSizeSmall),
                    decoration: BoxDecoration(
                      color: ColorResource.instance.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: DecorationResource.instance.containerBoxShadow(ColorResource.instance.grey),
                    ),
                    child: Image.asset(
                      ImageResource.instance.backArrowIcon,
                      height: 11,
                      color: ColorResource.instance.black,
                    ),
                  ),
                ).paddingSymmetric(vertical: DimensionResource.paddingSizeExtraSmall),
              ).paddingOnly(bottom: DimensionResource.marginSizeLarge*2),
              Image.asset(ImageResource.instance.plantNotFoundImage,),
              Text("plant_not_found".tr,style: StyleResource.instance.styleBold(DimensionResource.fontSizeLarge, ColorResource.instance.black),).paddingOnly(bottom: DimensionResource.marginSizeSmall),
              Text("plant_not_found_subtitle".tr,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.black),textAlign: TextAlign.center,).paddingOnly(bottom: DimensionResource.marginSizeSmall),
            Row(
              children: [
                Expanded(child: CommonButton(color: ColorResource.instance.btnGreenColor,height: 40,textSize: DimensionResource.fontSizeExtraSmall,padding: EdgeInsets.all(DimensionResource.marginSizeExtraSmall),text: "retake_photo".tr, loading: false, onPressed: ()=>Get.offAllNamed(Routes.rootView))),
                Gap(DimensionResource.marginSizeSmall),
                Expanded(child: CommonButton(color: ColorResource.instance.black,height: 40,textSize: DimensionResource.fontSizeExtraSmall,padding: EdgeInsets.all(DimensionResource.marginSizeExtraSmall),text: "search_by_name".tr, loading: false, onPressed: ()=>Get.offAllNamed(Routes.rootView,arguments: {"pageIndex":1})))
              ],
            )
            ],
          ),
        ),
      ),
    );
  }
}
