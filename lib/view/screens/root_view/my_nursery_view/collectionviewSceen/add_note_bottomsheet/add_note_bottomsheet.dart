

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plants_spotify/model/model/root_view_models/nursery_models/plant_notes_model.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/input_formatters_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/bottom_sheet.dart';
import 'package:plants_spotify/view/widgets/button_view/button_holders.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
import 'package:plants_spotify/view/widgets/button_view/yinkwell.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_image.dart';
import 'package:plants_spotify/view/widgets/text_field_view/common_textfield.dart';
import 'package:plants_spotify/view/widgets/text_field_view/lable_container.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/collection_view_controller/collection_view_controller.dart';





Future<void> addNotesBottomSheet(BuildContext context, CollectionViewController controller) async {
  await BottomSheetModel(
      isDismissible: true,
      title: "".tr,
      isScrollControlled: true,
      padding: MediaQuery.of(context).viewInsets,
      borderRadius:const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
      height: 600,
      color: ColorResource.instance.white, child: Expanded(
    child:_buildAddNoteSheetUI(context,controller),
  )).presentDetail(Get.context!);
}


// class AddNoteBottomsheet extends StatelessWidget {
//   const AddNoteBottomsheet({
//     super.key, required this.formKey, required this.notesController, required this.notesError, required this.isLoading, required this.plantName, required this.scientificName, required this.plantImage, required this.isEdit, this.existingImages, required this.selectedFiles, required this.onSave, required this.onPickImage, required this.onRemoveExistingImage, required this.onRemoveSelectedImage,
//   });
//   final GlobalKey<FormState> formKey;
//   final TextEditingController notesController;
//   final RxString notesError;
//   final RxBool isLoading;
//   final String plantName;
//   final String scientificName;
//   final String plantImage;
//   final bool isEdit;
//   final List<Img>? existingImages;
//   final List<dynamic> selectedFiles;
//   final VoidCallback onSave;
//   final VoidCallback onPickImage;
//   final Function(int index) onRemoveExistingImage;
//   final Function(int index) onRemoveSelectedImage;
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(DimensionResource.paddingSizeDefault),
//         child: Obx(
//               ()=> Form(
//             key: formKey,
//             child: Column(
//                 children: [
//                   Text("add_note".tr,style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeDefault, ColorResource.instance.textDarkGreenColor),).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
//                   YRoundedImage(
//                     backgroundColor:
//                     ColorResource.instance.socialButtonGreenColor,
//                     imageUrl:  ImageResource.instance.plantImage,
//                     isNetworkImage: false,
//                     width: 80,
//                     border: Border.all(
//                       color: ColorResource.instance.btnBorderGreen
//                           .withValues(alpha: 0.6),
//                     ),
//                   ).paddingOnly(bottom: DimensionResource.paddingSizeExtraExtraSmall),
//                   Text(plantName, style: StyleResource.instance.styleBold(DimensionResource.fontSizeDefault, ColorResource.instance.textDarkGreenColor,),).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
//                   Text(scientificName, style: StyleResource.instance.styleRegular(DimensionResource.fontSizeDefault, ColorResource.instance.textColor_2,),).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
//                   LabelContainer(
//                     isRequired: true,
//                     label: "note".tr,
//                     child: CommonTextField(
//                       minLines: 4,
//                       maxLines: 6,
//                       maxLength: 500,
//                       height: 120,
//                       controller: notesController,
//                       hintText: "write_note".tr,
//                       inputFormatters: InputFormattersResource.instance.numberAndIntegerFormatters,
//                       keyboardType: TextInputType.name,
//                       validator: (val)=>val?.isValidNoteValidation(onError:(error)=>notesError.value =error,name: "note".tr),
//                       errorText: notesError.value,
//                     ),
//                   ).paddingOnly(bottom: DimensionResource.paddingSizeLarge),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("add_image".tr,style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeDefault, ColorResource.instance.black),),
//                       YInkwell(onTap: ()=> onPickImage,child: Image.asset(ImageResource.instance.cameraIcon,height: 18,))
//                     ],
//                   ).paddingOnly(bottom: DimensionResource.paddingSizeDefault),
//                   // buildSelectImageBox(context,controller).paddingSymmetric(vertical:  DimensionResource.paddingSizeDefault),
//
//                   CommonButton(text: "save".tr, loading: isLoading.value, onPressed: onSave,textSize: DimensionResource.fontSizeDefault,)
//                 ]
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


Widget _buildAddNoteSheetUI(BuildContext context, CollectionViewController controller){

  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(DimensionResource.paddingSizeDefault),
      child: Obx(
        ()=> Form(
          key: controller.collectionFormKey,
          child: Column(
            children: [
              Text("add_note".tr,style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeDefault, ColorResource.instance.textDarkGreenColor),).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
              YRoundedImage(
                backgroundColor:
                ColorResource.instance.socialButtonGreenColor,
                imageUrl:  ImageResource.instance.plantImage,
                isNetworkImage: false,
                width: 80,
                border: Border.all(
                  color: ColorResource.instance.btnBorderGreen
                      .withValues(alpha: 0.6),
                ),
              ).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
              Text(controller.selectedPlantData.commonName??"", style: StyleResource.instance.styleBold(DimensionResource.fontSizeDefault, ColorResource.instance.textDarkGreenColor,),
              ).paddingOnly(bottom: DimensionResource.paddingSizeExtraSmall),

              Text(controller.selectedPlantData.scientificName??"", style: StyleResource.instance.styleRegular(DimensionResource.fontSizeDefault, ColorResource.instance.textColor_2,),).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
              LabelContainer(
                isRequired: true,
                label: "note".tr,
                child: CommonTextField(
                  minLines: 4,
                  maxLines: 6,
                  maxLength: 500,
                  height: 120,
                  controller: controller.notesController,
                  hintText: "write_note".tr,
                  keyboardType: TextInputType.name,
                  validator: (val)=>val?.isValidNameValidation(onError:(error)=>controller.notesError.value =error,name: "note".tr),
                  errorText: controller.notesError.value,
                ),
              ).paddingOnly(bottom: DimensionResource.paddingSizeLarge),
              ErrorContainer(
                errorText: controller.imageError.value,
                padding: EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("add_image".tr,style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeDefault, ColorResource.instance.black),),
                        Text("*",style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeDefault,  ColorResource.instance.darkRedColor),),

                      ],
                    ),
                    YInkwell(onTap: ()=> controller.pickFilesFromDevice(),child: Image.asset(ImageResource.instance.cameraIcon,height: 18,))
                ],
                ).paddingOnly(bottom: DimensionResource.paddingSizeDefault),
              ),
              buildSelectImageBox(context,controller).paddingSymmetric(vertical:  DimensionResource.paddingSizeDefault),

              CommonButton(text: "save".tr, loading: controller.isLoading.value, onPressed: ()=>controller.addPlantNote(),textSize: DimensionResource.fontSizeDefault,),
              Gap(100),
              ]
          ),
        ),
      ),
    ),
  );
}



Widget buildSelectImageBox(BuildContext context, CollectionViewController controller){
  return Obx(
    ()=> SizedBox(
      width: double.infinity,
      child: Wrap(
        // spacing: DimensionResource.marginSizeLarge,
        // runSpacing: DimensionResource.marginSizeDefault,
        children: List.generate(controller.selectDocumentFiles.length + ( controller.selectDocumentFiles.isNotEmpty ? 1 : 0), (index) =>
            SizedBox(
              width: 70,
              height: 70,
              child: index == controller.selectDocumentFiles.length &&  controller.selectDocumentFiles.isNotEmpty  ? YRoundedContainer(
                onTap: ()=> controller.pickFilesFromDevice(),
                showBorder: true,
                radius: 8,
                borderColor: ColorResource.instance.textColor_2.withValues(alpha: 0.2),
                padding: EdgeInsets.all(DimensionResource.paddingSizeExtraSmall),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add,color: ColorResource.instance.textColor_2.withValues(alpha: 0.2),),
                    Text("add_more".tr,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeExtraSmall,ColorResource.instance.textColor_2.withValues(alpha: 0.2)),),
                  ],
                ),
              ) : Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(8),
              child: Image.file(
                File(controller.selectDocumentFiles[index].path),
                fit: BoxFit.cover,
                height: 70,width: 70,
              ),
            ),
            Positioned(right: 0,top: 0,child: ButtonResource.instance.borderImageButton(borerColor: ColorResource.instance.transparent, backGroundColor: ColorResource.instance.transparent, image: ImageResource.instance.closeIcon, imageColor: ColorResource.instance.darkRedColor, onTap: ()=>controller.selectDocumentFiles.removeAt(index),borderRadius: 50,imageHeight: 10,imagePadding: DimensionResource.marginSizeExtraSmall+2))

          ],
        ),
        ).paddingOnly(right:DimensionResource.paddingSizeSmall,top: DimensionResource.paddingSizeExtraSmall,bottom: DimensionResource.paddingSizeExtraSmall),
        ),
      ),
    ),
  );
}