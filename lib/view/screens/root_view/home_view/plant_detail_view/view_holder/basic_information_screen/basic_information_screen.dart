import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/model/root_view_models/nursery_models/plant_notes_model.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/plant_detail_view.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/loader_helper/loader_helper_ui.dart';
import 'package:plants_spotify/view/widgets/no_data_screen/noDataScreen.dart';
import 'package:plants_spotify/view/widgets/pagination_view/pagination_view_screen.dart';
import 'package:plants_spotify/view/widgets/sliders/promo_slider.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/plant_detail_controller/plant_detail_controller.dart';

class BasicInformationScreen extends StatelessWidget {
  final String commonName;

  final String plantType;
  final String tags;
  final String scientificName;
  final String lifespan;
  final String distribution;
  final String description;
  final List<String> characteristics;
  final PlantDetailController controller;
  final List<String> bannerImages;


  const BasicInformationScreen({
    super.key,
    required this.description,
    required this.characteristics, required this.plantType, required this.scientificName, required this.lifespan, required this.distribution, required this.commonName, required this.controller, required this.tags, this.bannerImages = const [],
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        if (bannerImages.isNotEmpty)
          YPromoSlider(
            height: 204,
            width: HelperFunction.screenWidth(),
            autoplay: false,
            imageBorderRadius: 8,
            isNetworkImage: true,
            viewportFraction: 1,
            aspectRatio: 1,
            fit: BoxFit.cover,
            viewAll: false,
            banners: bannerImages,
          ).paddingOnly(bottom: DimensionResource.paddingSizeExtraSmall),
        if (bannerImages.isNotEmpty)
          Text("image_expand_text".tr, style: StyleResource.instance.styleRegularItalic(DimensionResource.fontSizeExtraSmall - 2, ColorResource.instance.lightGrey)).paddingOnly(bottom: DimensionResource.paddingSizeDefault),
        if (bannerImages.isNotEmpty)
          Divider(color: ColorResource.instance.dividerGrey, thickness: 2).paddingOnly(bottom: DimensionResource.paddingSizeDefault),
        YRoundedContainer(
            radius: 5,
            width: HelperFunction.screenWidth(),
            gradient: LinearGradient(
              colors: [
                ColorResource.instance.orangeGradientColor1,
                ColorResource.instance.orangeGradientColor2,
                ColorResource.instance.orangeGradientColor3,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            padding: EdgeInsets.all(DimensionResource.marginSizeDefault),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  commonName,
                  style: StyleResource.instance.styleBold(
                    DimensionResource.fontSizeSmall,
                    ColorResource.instance.textDarkGreenColor,
                  ),
                ).paddingOnly(bottom: DimensionResource.paddingSizeSmall),

                StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    PlantInfoItem(
                      height: 68,
                      maxLines: 2,
                      icon: ImageResource.instance.plantDetailIcon,
                      title: "plant_type".tr,
                      value: plantType ,
                    ),
                    PlantInfoItem(
                      height: 68,
                      maxLines: 2,
                      icon: ImageResource.instance.scientificIcon,
                      title: "scientific_name".tr,
                      value: scientificName,
                    ),
                    PlantInfoItem(
                      height: 68,
                      maxLines: 2,
                      icon: ImageResource.instance.clockIcon,
                      title: "lifespan".tr,
                      value: lifespan,
                    ),
                    PlantInfoItem(
                      height: 68,
                      maxLines: 2,
                      icon: ImageResource.instance.distributionIcon,
                      title: "distribution".tr,
                      value: distribution,
                    ),
                    if (tags.isNotEmpty ?? false)
                      StaggeredGridTile.fit(
                        crossAxisCellCount: 2,
                        child: PlantInfoItem(
                          icon: ImageResource.instance.plantTagsIcon,
                          maxLines: 6,
                          title: "names".tr,
                          value: tags,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ).paddingOnly(bottom: DimensionResource.marginSizeDefault),
      //   YRoundedContainer(
      //   radius: 5,
      //   width: HelperFunction.screenWidth(),
      //   height: tags.isEmpty?  205 :  295,
      //   gradient: LinearGradient(
      //   colors: [
      //       ColorResource.instance.orangeGradientColor1,
      //       ColorResource.instance.orangeGradientColor2,
      //       ColorResource.instance.orangeGradientColor3,
      //     ],
      //     begin: Alignment.bottomCenter,
      //     end: Alignment.topCenter,
      //   ),
      //   padding: EdgeInsets.all(DimensionResource.marginSizeDefault),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(
      //         commonName ?? "N/A",
      //         style: StyleResource.instance.styleBold(
      //           DimensionResource.fontSizeSmall,
      //           ColorResource.instance.textDarkGreenColor,
      //         ),
      //       ).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
      //
      //       Expanded(
      //         child: StaggeredGrid.count(
      //           crossAxisCount: 2,
      //           mainAxisSpacing: 10,
      //           crossAxisSpacing: 10,
      //           children: [
      //             PlantInfoItem(
      //
      //               icon: ImageResource.instance.plantDetailIcon,
      //               title: "plant_type".tr,
      //               value: plantType ?? "N/A",
      //             ),
      //             PlantInfoItem(
      //               icon: ImageResource.instance.scientificIcon,
      //               title: "scientific_name".tr,
      //               value: scientificName ?? "N/A",
      //             ),
      //             PlantInfoItem(
      //               icon: ImageResource.instance.clockIcon,
      //               title: "lifespan".tr,
      //               value: lifespan ?? "N/A",
      //             ),
      //             PlantInfoItem(
      //               icon: ImageResource.instance.distributionIcon,
      //               title: "distribution".tr,
      //               value: distribution ?? "N/A",
      //             ),
      //             if (tags.isNotEmpty)
      //               StaggeredGridTile.fit(
      //                 crossAxisCellCount: 2,
      //                 child: PlantInfoItem(
      //                   icon: ImageResource.instance.plantTagsIcon,
      //                   title: "names".tr,
      //                   value: tags ?? "N/A",
      //                 ),
      //               ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ).paddingOnly(bottom: DimensionResource.marginSizeDefault),

        /// this section is for notes
          if(controller.backScreenData["type"] == 2)
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 400,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "notes".tr,
                        style: StyleResource.instance.styleSemiBold(
                          DimensionResource.fontSizeDefault,
                          ColorResource.instance.textDarkGreenColor2,
                        ),
                      ),
                      YRoundedContainer(
                          onTap: (){
                            controller.bottomSheetType.value= 1;
                            controller.selectedPlantNote.value = PlantNotesData();
                            controller.editBottomSheet();
                            controller.notesError.value = "";
                            controller.imageError.value = "";
                          },
                          radius: 5,
                          padding: EdgeInsets.symmetric(horizontal: DimensionResource.paddingSizeSmall,vertical: DimensionResource.paddingSizeExtraSmall),
                          backgroundColor: ColorResource.instance.black,
                          child: Row(
                            children: [
                              Image.asset(ImageResource.instance.editNoteIcon,height: 10,),
                              Gap(DimensionResource.marginSizeExtraSmall),
                              Text(
                                "add_note".tr,
                                style: StyleResource.instance.styleMedium(
                                  DimensionResource.fontSizeExtraSmall,
                                  ColorResource.instance.white,
                                ),
                              ),
                            ],
                          )
                      )
                    ],
                  ),
                  Expanded(
                    child: Obx((){
                      if(controller.plantNotesData.value.status == true && controller.plantNotesPaginationViewController.itemList.isNotEmpty) {
                        return PaginationView<PlantNotesData>(
                            onRefresh: ()=>{},
                            showItemList: controller.plantNotesPaginationViewController.itemList,
                            pagingScrollController:controller.plantNotesPaginationViewController,
                            mainView:(BuildContext context, int index,PlantNotesData itemData){
                              if(index == controller.plantNotesPaginationViewController.itemList.length - 1){
                                return  TimelineItem(title: itemData.createdAt??"N/A", description: itemData.note??"N/A", isLast: true, imageUrls:itemData.images?.isNotEmpty??false ?itemData.images!.map((e) => e.image).whereType<String>().toList() : [], onTap: (x){controller.selectedPlantNote.value = itemData; controller.showNotesMenu(x);},);
                              }else{
                                return  TimelineItem(title: itemData.createdAt??"N/A", description: itemData.note??"N/A", isLast: false, imageUrls:itemData.images?.isNotEmpty??false ?itemData.images!.map((e) => e.image).whereType<String>().toList() : [], onTap: (x){controller.selectedPlantNote.value = itemData; controller.showNotesMenu(x);},);

                              }
                            }
                        ).paddingOnly(top: DimensionResource.marginSizeDefault *2,bottom: DimensionResource.marginSizeDefault);
                      }else if(controller.plantNotesData.value.status == true && controller.plantNotesPaginationViewController.itemList.isEmpty){
                        return NoDataFoundScreen(imageHeight: 250,message: "no_notes_found".tr,onRefresh: ()=>controller.getPlantsNoteList(pageNumber: 1, forPaginate: false),);
                      }else{
                        return loaderHelperUi();
                      }

                    }) ,
                  ),
                ],
              ),
            ).paddingOnly(bottom: DimensionResource.marginSizeDefault),


          Text(
            "basic_information".tr,
            style: StyleResource.instance.styleSemiBold(
              DimensionResource.fontSizeDefault,
              ColorResource.instance.textDarkGreenColor2,
            ),
          ).paddingOnly(bottom: DimensionResource.marginSizeSmall),
          /// DESCRIPTION (
          Text(
            description,
            style: StyleResource.instance.styleRegular(
              DimensionResource.fontSizeSmall,
              ColorResource.instance.textColor_2,
            ),
          ).paddingOnly(bottom: DimensionResource.marginSizeDefault),
      
          /// CHARACTERISTICS
          YRoundedContainer(
            width: HelperFunction.screenWidth(),
            backgroundColor:
            ColorResource.instance.socialButtonGreenColor,
            padding:
            EdgeInsets.all(DimensionResource.paddingSizeDefault),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "characterstics".tr,
                  style: StyleResource.instance.styleSemiBold(
                    DimensionResource.fontSizeDefault,
                    ColorResource.instance.textDarkGreenColor,
                  ),
                ).paddingOnly(
                    bottom:
                    DimensionResource.marginSizeExtraSmall),
      
                /// LIST (DYNAMIC)
                ...characteristics.map(
                      (item) => PlantCharactersticRow(
                    icon: ImageResource.instance.leafIcon,
                    text: item,
                  ).paddingOnly(
                      bottom:
                      DimensionResource.marginSizeExtraSmall),
                ),
              ],
            ),
          ),
        ],
      ).paddingAll(DimensionResource.paddingSizeSmall),
    );
  }
}

class PlantCharactersticRow extends StatelessWidget {
  final String icon;
  final String text;
  final double iconSize;

  const PlantCharactersticRow({
    super.key,
    required this.icon,
    required this.text,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          icon,
          height: iconSize,
        ),
        Gap(DimensionResource.marginSizeDefault),

        /// Flexible text
        Expanded(
          child: Text(
            text,
            style: StyleResource.instance.styleRegular(
              DimensionResource.fontSizeSmall,
              ColorResource.instance.textColor_2,
            ),
          ).paddingOnly(
            bottom: DimensionResource.marginSizeExtraSmall,
          ),
        ),
      ],
    );
  }
}
