import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
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



class DeletePopup extends StatelessWidget {
  final String? title;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final dynamic controller;


  const DeletePopup({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    required this.controller,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return PopupDialog(
        child: YRoundedContainer(
          gradient: LinearGradient(
            colors: [  Color(0xffE8FFF0),Color(0xffFFFFFF),],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

          ),
          height: 365,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Align(alignment: Alignment.centerRight,child: InkWell(onTap: Get.back,child: Image.asset(ImageResource.instance.closeOutlinedIcon,height: 18,).paddingOnly(top: 10,right: 10))),
              Image.asset(ImageResource.instance.deleteImage,height: 150,).paddingOnly(bottom: DimensionResource.paddingSizeDefault),
              Container(
                padding: EdgeInsets.all(DimensionResource.marginSizeDefault),
                child: Column(
                  children: [
                    Text(title ?? "delete_title".tr,style: StyleResource.instance.styleMedium(DimensionResource.fontSizeSmall, ColorResource.instance.black),textAlign: TextAlign.center,).paddingOnly(bottom: DimensionResource.paddingSizeDefault),
                    CommonButton(text: "yes_delete".tr, loading: false, onPressed: onConfirm,height: 40,color: ColorResource.instance.btnRed,textSize: DimensionResource.fontSizeSmall,).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
                    YInkwell(onTap: onCancel,child: Text("cancel".tr,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.textColor_9),textAlign: TextAlign.center,).paddingOnly(bottom: DimensionResource.marginSizeDefault)),

                  ],
                ),
              ),

            ],

          ),

        )
    );
  }
}
