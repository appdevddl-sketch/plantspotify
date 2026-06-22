import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/input_formatters_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/button_holders.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
import 'package:plants_spotify/view/widgets/button_view/image_picker.dart';
import 'package:plants_spotify/view/widgets/button_view/payment_details_dialog.dart';
import 'package:plants_spotify/view/widgets/button_view/yinkwell.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_image.dart';
import 'package:plants_spotify/view/widgets/text_field_view/common_textfield.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';

import '../../../../model/utils/color_resource.dart';

class WarningPopup extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final dynamic controller;


  const WarningPopup({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return PopupDialog(
        child: YRoundedContainer(
          height: 450,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(ImageResource.instance.leaf4Image,width: 100,),
                    InkWell(onTap: Get.back,child: Image.asset(ImageResource.instance.closeOutlinedIcon,height: 18,).paddingOnly(top: 10,right: 10))
                  ],
                ),
                _buildPicBox(controller),
                Container(
                  padding: EdgeInsets.all(DimensionResource.marginSizeDefault),
                  child: Column(
                    children: [
                      Text("warning_title".tr,style: StyleResource.instance.styleBold(DimensionResource.fontSizeDefault, ColorResource.instance.black),textAlign: TextAlign.center,).paddingOnly(bottom: DimensionResource.marginSizeSmall),
                      Text("warning_subtitle".tr,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.textColor_9),textAlign: TextAlign.center,).paddingOnly(bottom: DimensionResource.marginSizeDefault * 3),
                      CommonButton(text: "proceed".tr, loading: false, onPressed: onConfirm,height: 40,color: ColorResource.instance.btnGreenColor,textSize: DimensionResource.fontSizeSmall,).paddingOnly(bottom: DimensionResource.marginSizeSmall),
                      YInkwell(onTap:onCancel,child: Text("may_be_later".tr,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.textColor_9),textAlign: TextAlign.center,).paddingOnly(bottom: DimensionResource.marginSizeDefault)),

                    ],
                  ),
                ),
            
              ],
            
            ),
          ),

        )
    );
  }
}
Widget _buildPicBox(dynamic controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(
        child: Hero(
          tag: "xyz",
          child: Obx(() {
            return controller.selectedImage.value.path != "" || controller.selectedImage.value.path.isNotEmpty
                ? Obx(() {
              return ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.file(
                  controller.selectedImage.value,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              );
            })
                :  SizedBox.shrink();
          }),
        ),
      ),
      Obx(()=>Visibility(
          visible: controller.selectedImageError.value != "",
          child: Padding(
            padding: const EdgeInsets.only(top: DimensionResource.marginSizeSmall),
            child: Text(
              controller.selectedImageError.value,
              style: StyleResource.instance.styleRegular(
                  DimensionResource.fontSizeDefault,
                  ColorResource.instance.darkRedColor),
            ),
          ))),
    ],
  );
}
