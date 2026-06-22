import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/input_formatters_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/button_holders.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
import 'package:plants_spotify/view/widgets/button_view/payment_details_dialog.dart';
import 'package:plants_spotify/view/widgets/button_view/yinkwell.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/text_field_view/common_textfield.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';

import '../../../../model/utils/color_resource.dart';

class PermissionPopup extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final dynamic controller;
  final String? image;
  final String? title;
  final String? subTitle;
  final String? confirmTitle;
  final String? cancelTitle;
  final double? height;
  final bool showCancelOption;

  const PermissionPopup({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    required this.controller,
    this.image,
    this.title,
    this.subTitle,
    this.confirmTitle,
    this.cancelTitle,
    this.height,
    this.showCancelOption = true,
  });

  @override
  Widget build(BuildContext context) {
    return PopupDialog(
      child: YRoundedContainer(
        height: height ?? 420,
        child: Column(mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Image.asset(ImageResource.instance.leaf4Image,width: 100,),
              if (showCancelOption)
                InkWell(onTap: Get.back,child: Image.asset(ImageResource.instance.closeOutlinedIcon,height: 18,).paddingOnly(top: 10,right: 10))
              else
                SizedBox(width: 38, height: 38),
              ],
            ),
            Image.asset(image??ImageResource.instance.cameraImage,height: 100,),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(DimensionResource.marginSizeDefault),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(title ?? "enable_camera_title".tr,style: StyleResource.instance.styleBold(DimensionResource.fontSizeDefault, ColorResource.instance.black),textAlign: TextAlign.center,).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
                        Text(subTitle ?? "enable_camera_subtitle".tr,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall-1, ColorResource.instance.textColor_9),textAlign: TextAlign.center,),
                      ],
                    ),
                    Column(
                      children: [
                        CommonButton(text: confirmTitle ?? "allow".tr, loading: false, onPressed: onConfirm,height: 40,color: ColorResource.instance.btnGreenColor,textSize: DimensionResource.fontSizeSmall,).paddingOnly(bottom: DimensionResource.marginSizeSmall),
                        if (showCancelOption)
                          YInkwell(onTap:onCancel,child: Text(cancelTitle ?? "not_now".tr,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.textColor_9),textAlign: TextAlign.center,)),
                      ],
                    )
                  ],
                ),
              ),
            ),

          ],

        ),

      )
    );
  }
}
