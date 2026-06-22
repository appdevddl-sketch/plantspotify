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
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/text_field_view/common_textfield.dart';
import 'package:plants_spotify/view/widgets/text_field_view/lable_container.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';



class RenamePopup extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final dynamic controller;


  const RenamePopup({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return PopupDialog(
        child: YRoundedContainer(
          padding: EdgeInsets.all(DimensionResource.marginSizeDefault),
          height: 425,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                 Expanded(child: Center(child: Text("rename_collections".tr,style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeDefault, ColorResource.instance.black),))),
                  InkWell(onTap: Get.back,child: Image.asset(ImageResource.instance.closeOutlinedIcon,height: 18,))
                ],
              ),
              Image.asset(ImageResource.instance.renameImage,height: 150,),
              Container(
                padding: EdgeInsets.all(DimensionResource.marginSizeDefault),
                child: Column(
                  children: [
                    Form(
                      child: LabelContainer(
                        label: 'please_enter_a_new_name'.tr,
                        child: CommonTextField(
                          controller: controller.collectionNameController,
                          hintText: "enter_collection_name".tr,
                          inputFormatters: InputFormattersResource.instance.numberAndIntegerFormatters,
                          keyboardType: TextInputType.name,
                          validator: (val)=>val?.isValidNameValidation(onError:(error)=>controller.collectionNameError.value =error,name: "collection_name".tr),
                          errorText: controller.collectionNameError.value,
                        ),
                      ).paddingOnly(bottom: DimensionResource.paddingSizeDefault *2),
                    ),

                    CommonButton(text: "save".tr, loading: false, onPressed: onConfirm,height: 40,color: ColorResource.instance.btnGreenColor,textSize: DimensionResource.fontSizeSmall,).paddingOnly(bottom: DimensionResource.marginSizeSmall),


                  ],
                ),
              ),

            ],

          ),

        )
    );
  }
}