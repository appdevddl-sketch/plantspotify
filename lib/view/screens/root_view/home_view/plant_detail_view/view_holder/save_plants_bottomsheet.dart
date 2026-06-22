

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/model/root_view_models/nursery_models/collection_model.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/bottom_sheet.dart';
import 'package:plants_spotify/view/widgets/button_view/yinkwell.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_image.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/plant_detail_controller/plant_detail_controller.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';






import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/model/root_view_models/nursery_models/collection_model.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/bottom_sheet.dart';
import 'package:plants_spotify/view/widgets/button_view/yinkwell.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_image.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/plant_detail_controller/plant_detail_controller.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';




void savePlantsBottomSheet(BuildContext context, dynamic controller){
  BottomSheetModel(
      isDismissible: true,
      title: "".tr,
      isScrollControlled: true,
      padding: MediaQuery.of(context).viewInsets,
      borderRadius:const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
      height: 350,
      color: ColorResource.instance.white, child: Expanded(
    child:_buildChangePasswordSheetUI(context,controller),
  )).presentDetail(Get.context!);
}


Widget _buildChangePasswordSheetUI(BuildContext context, dynamic controller) {
  return RefreshIndicator(
    color: ColorResource.instance.mainColor,
    onRefresh: () async{
      await controller.getCollection();
    },
    child: Obx(
          ()=> SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(DimensionResource.paddingSizeDefault),
          child: Column(
            children: [
              YRoundedContainer(
                backgroundColor: ColorResource.instance.grey_6.withValues(alpha: 2.2),
                height: 60,
                child: Row(
                  children: [
                    YRoundedImage(
                      borderRadius: 5,
                      padding: EdgeInsets.all(DimensionResource.paddingSizeExtraSmall+2),
                      backgroundColor: ColorResource.instance.socialButtonGreenColor,
                      imageUrl: controller.untitleData.value.image??"",
                      height: 100,
                      width: 50,
                      fit: BoxFit.contain,
                    ),
                    Gap(DimensionResource.paddingSizeSmall),
                    Expanded(child: Text(controller.untitleData.value.name??"",style: StyleResource.instance.styleMedium(DimensionResource.fontSizeDefault, ColorResource.instance.textDarkGreenColor),)),
                    YInkwell(onTap: ()=> controller.addPlantToCollection(data: controller.untitleData.value),child: controller.untitleData.value.isAdded == true ? Icon(Icons.bookmark,color: ColorResource.instance.btnGreenColor,) : Image.asset(ImageResource.instance.saveIcon,color: ColorResource.instance.grey_5,height: 18,)),
                    Gap(DimensionResource.paddingSizeSmall),
                  ],
                ),
              ).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("collections".tr,style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeDefault, ColorResource.instance.textDarkGreenColor),),
                  YRoundedContainer(
                    onTap: ()=>Get.toNamed(Routes.createCollectionScreen)?.then((value){
                      controller.getCollection();
                    }),
                    padding: EdgeInsets.symmetric(horizontal:DimensionResource.paddingSizeDefault,vertical:DimensionResource.paddingSizeExtraExtraSmall),
                    backgroundColor: ColorResource.instance.btnBorderGreen.withValues(alpha: 0.2),
                    child: Row(
                      children: [
                        Image.asset(ImageResource.instance.saveIcon,height: 15,color: ColorResource.instance.textColor_2,),
                        Gap(DimensionResource.marginSizeExtraSmall),
                        Text("new_collection".tr,style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeSmall,ColorResource.instance.black ),),
                      ],
                    ),
                  ),
                ],
              ).paddingOnly(bottom: DimensionResource.paddingSizeSmall),

              ...List.generate(controller.collectionList.value.data.where((e) => e.name != "Untitle").toList().length, (index){
                List<CollectionData> data = controller.collectionList.value.data.where((e) => e.name != "Untitle").toList();
                return CollectionCard(onCardTap: (){},isNetworkImage: true,title: data[index].name??"", image: data[index].image??"",isEdit: false,onSaveTap: (ctx){controller.addPlantToCollection(data: data[index]);},isAdded: data[index].isAdded??false,).paddingOnly(bottom: DimensionResource.paddingSizeDefault);
              }),
            ],
          ),
        ),
      ),
    ),
  );
}

class CollectionCard extends StatelessWidget {
  const CollectionCard({
    super.key,
    required this.title,
    required this.image,
    this.isNetworkImage = false,
    this.onSaveTap,
    this.height = 60,
    this.isEdit = false,
    this.onCardTap,this.subtitle, this.showSubtitle = false,this.isAdded = false,
  });

  final String title;
  final String? subtitle;
  final bool showSubtitle;
  final String image;
  final bool isNetworkImage;
  final void Function(BuildContext context)? onSaveTap;
  final double height;
  final bool isEdit;
  final bool isAdded;
  final VoidCallback? onCardTap;


  @override
  Widget build(BuildContext context) {
    return YRoundedContainer(
      height: height,
      radius: 5,
      backgroundColor: ColorResource.instance.grey_6.withValues(alpha: 0.5),
      padding: const EdgeInsets.only(
        right: DimensionResource.paddingSizeSmall,
      ),
      child: Row(

        children: [
          YInkwell(
            onTap: onCardTap,
            child: YRoundedImage(
              borderRadius: 5,
              padding: EdgeInsets.all(DimensionResource.paddingSizeExtraSmall+2),
              backgroundColor: ColorResource.instance.socialButtonGreenColor,
              isNetworkImage: isNetworkImage,
              imageUrl: image,
              height: 100,
              width: 50,
              fit: BoxFit.contain,
            ),
          ),
          const Gap(DimensionResource.paddingSizeSmall),
          Expanded(
            child: YInkwell(
              onTap: onCardTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: StyleResource.instance.styleMedium(
                      DimensionResource.fontSizeDefault,
                      ColorResource.instance.textDarkGreenColor,
                    ),
                  ),
                  if(showSubtitle)
                    Text(
                      subtitle??"",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: StyleResource.instance.styleRegular(
                        DimensionResource.fontSizeSmallTo,
                        ColorResource.instance.btnGreenColor,
                      ),
                    ),
                ],
              ),
            ),
          ),

          InkWell(
            onTap: () => onSaveTap?.call(context),
            child: isEdit
                ? const Icon(Icons.more_vert, size: 18)
                : YRoundedContainer(
              backgroundColor: isAdded ? ColorResource.instance.btnGreenColor : ColorResource.instance.socialButtonGreenColor,
              showBorder: true,
              borderColor:
              ColorResource.instance.btnGreenBorderColor,
              radius: 25,
              height: 25,
              width: 25,
              child: Center(
                child: Icon(
                  isAdded ? Icons.check : Icons.add,
                  color: isAdded ? ColorResource.instance.white : ColorResource.instance.btnGreenColor,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

BottomSheet(BuildContext context, dynamic controller){
  BottomSheetModel(
      isDismissible: true,
      title: "".tr,
      isScrollControlled: true,
      padding: MediaQuery.of(context).viewInsets,
      borderRadius:const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
      height: 350,
      color: ColorResource.instance.white, child: Expanded(
    child:_buildChangePasswordSheetUI(context,controller),
  )).presentDetail(Get.context!);
}

//
// Widget _buildChangePasswordSheetUI(BuildContext context, dynamic controller) {
//   return RefreshIndicator(
//     color: ColorResource.instance.mainColor,
//     onRefresh: () async{
//       await controller.getCollection();
//     },
//     child: Obx(
//         ()=> SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(DimensionResource.paddingSizeDefault),
//           child: Column(
//             children: [
//               YRoundedContainer(
//                 backgroundColor: ColorResource.instance.grey_6.withValues(alpha: 2.2),
//                 height: 60,
//                 child: Row(
//                   children: [
//                     YRoundedImage(
//                       borderRadius: 5,
//                       padding: EdgeInsets.all(DimensionResource.paddingSizeExtraSmall+2),
//                       backgroundColor: ColorResource.instance.socialButtonGreenColor,
//                       imageUrl: controller.untitleData.value.image??"",
//                       height: 100,
//                       width: 50,
//                       fit: BoxFit.contain,
//                     ),
//                     Gap(DimensionResource.paddingSizeSmall),
//                     Expanded(child: Text(controller.untitleData.value.name??"",style: StyleResource.instance.styleMedium(DimensionResource.fontSizeDefault, ColorResource.instance.textDarkGreenColor),)),
//                     YInkwell(onTap: ()=> controller.addPlantToCollection(data: controller.untitleData.value),child: controller.untitleData.value.isAdded == true ? Icon(Icons.bookmark,color: ColorResource.instance.btnGreenColor,) : Image.asset(ImageResource.instance.saveIcon,color: ColorResource.instance.grey_5,height: 18,)),
//                     Gap(DimensionResource.paddingSizeSmall),
//                 ],
//                 ),
//               ).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text("collections".tr,style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeDefault, ColorResource.instance.textDarkGreenColor),),
//                   YRoundedContainer(
//                     onTap: ()=>Get.toNamed(Routes.createCollectionScreen)?.then((value){
//                       controller.getCollection();
//                     }),
//                     padding: EdgeInsets.symmetric(horizontal:DimensionResource.paddingSizeDefault,vertical:DimensionResource.paddingSizeExtraExtraSmall),
//                     backgroundColor: ColorResource.instance.btnBorderGreen.withValues(alpha: 0.2),
//                     child: Row(
//                       children: [
//                         Image.asset(ImageResource.instance.saveIcon,height: 15,color: ColorResource.instance.textColor_2,),
//                         Gap(DimensionResource.marginSizeExtraSmall),
//                         Text("new_collection".tr,style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeSmall,ColorResource.instance.black ),),
//                       ],
//                     ),
//                   ),
//                 ],
//               ).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
//
//               ...List.generate(controller.collectionList.value.data.where((e) => e.name != "Untitle").toList().length, (index){
//                 List<CollectionData> data = controller.collectionList.value.data.where((e) => e.name != "Untitle").toList();
//                 return CollectionCard(onCardTap: (){},isNetworkImage: true,title: data[index].name??"", image: data[index].image??"",isEdit: false,onSaveTap: (ctx){controller.addPlantToCollection(data: data[index]);},isAdded: data[index].isAdded??false,).paddingOnly(bottom: DimensionResource.paddingSizeDefault);
//               }),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }

// class CollectionCard extends StatelessWidget {
//   const CollectionCard({
//     super.key,
//     required this.title,
//     required this.image,
//     this.isNetworkImage = false,
//     this.onSaveTap,
//     this.height = 60,
//     this.isEdit = false,
//     this.onCardTap,this.subtitle, this.showSubtitle = false,this.isAdded = false,
//   });
//
//   final String title;
//   final String? subtitle;
//   final bool showSubtitle;
//   final String image;
//   final bool isNetworkImage;
//   final void Function(BuildContext context)? onSaveTap;
//   final double height;
//   final bool isEdit;
//   final bool isAdded;
//   final VoidCallback? onCardTap;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return YRoundedContainer(
//       height: height,
//       radius: 5,
//       backgroundColor: ColorResource.instance.grey_6.withValues(alpha: 0.5),
//       padding: const EdgeInsets.only(
//         right: DimensionResource.paddingSizeSmall,
//       ),
//       child: Row(
//
//         children: [
//           YInkwell(
//             onTap: onCardTap,
//             child: YRoundedImage(
//               borderRadius: 5,
//               padding: EdgeInsets.all(DimensionResource.paddingSizeExtraSmall+2),
//               backgroundColor: ColorResource.instance.socialButtonGreenColor,
//               isNetworkImage: isNetworkImage,
//               imageUrl: image,
//               height: 100,
//               width: 50,
//               fit: BoxFit.contain,
//             ),
//           ),
//           const Gap(DimensionResource.paddingSizeSmall),
//           Expanded(
//             child: YInkwell(
//               onTap: onCardTap,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     title,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: StyleResource.instance.styleMedium(
//                       DimensionResource.fontSizeDefault,
//                       ColorResource.instance.textDarkGreenColor,
//                     ),
//                   ),
//                   if(showSubtitle)
//                   Text(
//                     subtitle??"",
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: StyleResource.instance.styleRegular(
//                       DimensionResource.fontSizeSmallTo,
//                       ColorResource.instance.btnGreenColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           InkWell(
//             onTap: () => onSaveTap?.call(context),
//             child: isEdit
//                 ? const Icon(Icons.more_vert, size: 18)
//                 : YRoundedContainer(
//               backgroundColor: isAdded ? ColorResource.instance.btnGreenColor : ColorResource.instance.socialButtonGreenColor,
//               showBorder: true,
//               borderColor:
//               ColorResource.instance.btnGreenBorderColor,
//               radius: 25,
//               height: 25,
//               width: 25,
//               child: Center(
//                 child: Icon(
//                   isAdded ? Icons.check : Icons.add,
//                   color: isAdded ? ColorResource.instance.white : ColorResource.instance.btnGreenColor,
//                   size: 20,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

