

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/plant_detail_controller/plant_detail_controller.dart';





void editNotesBottomSheet(BuildContext context, PlantDetailController controller){
  BottomSheetModel(
      isDismissible: true,
      title: "".tr,
      isScrollControlled: true,
      padding: MediaQuery.of(context).viewInsets,
      borderRadius:const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
      height: 600,
      color: ColorResource.instance.white, child: Expanded(
    child:_buildEditNoteSheetUI(context,controller),
  )).presentDetail(Get.context!);
}


Widget _buildEditNoteSheetUI(BuildContext context, PlantDetailController controller){
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(DimensionResource.paddingSizeDefault),
      child: Obx(
            ()=> Form(
          key: controller.editNoteFormKey,
          child: Column(
              children: [
                Text(controller.bottomSheetType.value == 1 ? "add_note".tr : "edit_note".tr,style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeDefault, ColorResource.instance.textDarkGreenColor),).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
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
                Text(controller.backScreenData['type']==3 ? controller.identifyPlantData.value.data.plantDetails?.commonName??"N/A" : controller.plantDetailData.value.data.commonName??"N/A", style: StyleResource.instance.styleBold(DimensionResource.fontSizeDefault, ColorResource.instance.textDarkGreenColor,),
                ).paddingOnly(bottom: DimensionResource.paddingSizeExtraSmall),

                Text(controller.backScreenData['type']==3 ? controller.identifyPlantData.value.data.plantDetails?.scientificName??"N/A" : controller.plantDetailData.value.data.scientificName??"N/A", style: StyleResource.instance.styleRegular(DimensionResource.fontSizeDefault, ColorResource.instance.textColor_2,),).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
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
                    validator: (val)=>val?.isValidNoteValidation(onError:(error)=>controller.notesError.value =error,name: "note".tr),
                    errorText: controller.notesError.value,
                  ),
                ).paddingOnly(bottom: DimensionResource.paddingSizeDefault),
                ErrorContainer(
                  padding: EdgeInsets.zero,
                  errorText: controller.imageError.value,
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
                buildSelectImageBox(context,controller),
                CommonButton(text: "save".tr, loading: controller.isLoading.value, onPressed: ()=> controller.bottomSheetType.value == 1 ? controller.addPlantNote() : controller.editPlantNote(),textSize: DimensionResource.fontSizeDefault,)
              ]
          ),
        ),
      ),
    ),
  );
}



Widget buildSelectImageBox(BuildContext context, PlantDetailController controller){
  return Obx(
        ()=> SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: DimensionResource.marginSizeSmall,
        runSpacing: DimensionResource.marginSizeSmall,
        children: [
          ...List.generate(controller.selectedPlantNote.value.images?.length ?? 0, (index){
            final imageUrl = controller.selectedPlantNote.value.images?[index].image ?? '';
            if (imageUrl.isEmpty) return const SizedBox();
            return Stack(
              children: [
                YRoundedImage(
                  fit: BoxFit.cover,
                  borderRadius: 8,
                  height: 70,
                  width: 70,
                  imageUrl: imageUrl,
                ),
                Positioned(right: 0,top: 0,child: ButtonResource.instance.borderImageButton(borerColor: ColorResource.instance.transparent, backGroundColor: ColorResource.instance.transparent, image: ImageResource.instance.closeIcon, imageColor: ColorResource.instance.darkRedColor, onTap: ()=>controller.removeImage(controller.selectedPlantNote.value.images?[index].id??0),borderRadius: 50,imageHeight: 10,imagePadding: DimensionResource.marginSizeExtraSmall+2))

              ],
            );
          }),
          if(((controller.selectedPlantNote.value.images?.length??0) + controller.selectDocumentFiles.length) >= 1)
          ...List.generate(controller.selectDocumentFiles.length +  1, (index) =>
              SizedBox(
                width: 70,
                height: 70,
                child: index == controller.selectDocumentFiles.length  ? YRoundedContainer(
                  onTap: ()=> controller.pickFilesFromDevice(),
                  showBorder: true,
                  radius: 8,
                  borderColor: ColorResource.instance.textColor_2.withValues(alpha: 0.2),
                  padding: EdgeInsets.all(DimensionResource.paddingSizeExtraSmall),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add,color: ColorResource.instance.textColor_2.withValues(alpha: 0.2),),
                      Text("add_image".tr,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeExtraSmall,ColorResource.instance.textColor_2.withValues(alpha: 0.2)),),
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
              ),)
        ],
      ).paddingOnly(right:DimensionResource.paddingSizeSmall,top: DimensionResource.paddingSizeExtraSmall,bottom: DimensionResource.paddingSizeExtraSmall),
    ),
  );
}

// class imageBox extends StatelessWidget {
//   const imageBox({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//           ()=> SizedBox(
//         width: double.infinity,
//         child: Wrap(
//           spacing: DimensionResource.marginSizeSmall,
//           runSpacing: DimensionResource.marginSizeSmall,
//           children: [
//             ...List.generate(controller.selectedPlantNote.value.images?.length ?? 0, (index){
//               final imageUrl = controller.selectedPlantNote.value.images?[index].image ?? '';
//               if (imageUrl.isEmpty) return const SizedBox();
//               return Stack(
//                 children: [
//                   YRoundedImage(
//                     fit: BoxFit.cover,
//                     borderRadius: 8,
//                     height: 70,
//                     width: 70,
//                     imageUrl: imageUrl,
//                   ),
//                   Positioned(right: 0,top: 0,child: ButtonResource.instance.borderImageButton(borerColor: ColorResource.instance.transparent, backGroundColor: ColorResource.instance.transparent, image: ImageResource.instance.closeIcon, imageColor: ColorResource.instance.white, onTap: ()=>controller.removeImage(index),borderRadius: 50,imageHeight: 10,imagePadding: DimensionResource.marginSizeExtraSmall+2))
//
//                 ],
//               );
//             }),
//             ...List.generate(controller.selectDocumentFiles.length +  1, (index) =>
//                 SizedBox(
//                   width: 70,
//                   height: 70,
//                   child: index == controller.selectDocumentFiles.length  ? YRoundedContainer(
//                     onTap: ()=> controller.pickFilesFromDevice(),
//                     showBorder: true,
//                     radius: 8,
//                     borderColor: ColorResource.instance.textColor_2.withValues(alpha: 0.2),
//                     padding: EdgeInsets.all(DimensionResource.paddingSizeExtraSmall),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.add,color: ColorResource.instance.textColor_2.withValues(alpha: 0.2),),
//                         Text("add_more".tr,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeExtraSmall,ColorResource.instance.textColor_2.withValues(alpha: 0.2)),),
//                       ],
//                     ),
//                   ) : Stack(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadiusGeometry.circular(8),
//                         child: Image.file(
//                           File(controller.selectDocumentFiles[index].files.path),
//                           fit: BoxFit.cover,
//                           height: 70,width: 70,
//                         ),
//                       ),
//                       Positioned(right: 0,top: 0,child: ButtonResource.instance.borderImageButton(borerColor: ColorResource.instance.transparent, backGroundColor: ColorResource.instance.transparent, image: ImageResource.instance.closeIcon, imageColor: ColorResource.instance.white, onTap: ()=>controller.selectDocumentFiles.removeAt(index),borderRadius: 50,imageHeight: 10,imagePadding: DimensionResource.marginSizeExtraSmall+2))
//
//                     ],
//                   ),
//                 ),)
//           ],
//         ).paddingOnly(right:DimensionResource.paddingSizeSmall,top: DimensionResource.paddingSizeExtraSmall,bottom: DimensionResource.paddingSizeExtraSmall),
//       ),
//     );
//   }
// }