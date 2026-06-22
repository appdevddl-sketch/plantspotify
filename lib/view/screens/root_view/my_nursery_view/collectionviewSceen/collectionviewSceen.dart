import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/model/root_view_models/nursery_models/collection_plants_model.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/root_view/root_view.dart';
import 'package:plants_spotify/view/widgets/button_view/common_widget_button.dart';
import 'package:plants_spotify/view/widgets/button_view/yinkwell.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_image.dart';
import 'package:plants_spotify/view/widgets/loader_helper/loader_helper_ui.dart';
import 'package:plants_spotify/view/widgets/no_data_screen/noDataScreen.dart';
import 'package:plants_spotify/view/widgets/pagination_view/pagination_view_screen.dart';
import 'package:plants_spotify/view/widgets/shimmer_box/view_shimmers/nursery_screen_shimmer.dart';
import 'package:plants_spotify/view/widgets/text_field_view/common_textfield.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/collection_view_controller/collection_view_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/root_view_controller.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';

import '../../../base_view/base_view_screen.dart';

class CollectionViewScreen extends StatelessWidget {
  const CollectionViewScreen
      ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CollectionViewController());
    return BaseView(viewControl: controller,
        appbarPerimeter: AppbarPerimeter(title: controller.backScreenData.value.name??"",centerTitle: true),
        onPageBuilder: (BuildContext context,CollectionViewController controller)=>_buildMainView(context,controller));
  }
}

Widget _buildMainView(BuildContext context,CollectionViewController controller){
  return Obx((){
    if(controller.collectionPlantData.value.status!=false && controller.collectionPlantPaginationViewController.itemList.isNotEmpty) {
      return Column(
        children: [
          Text("You can see saved plants details for ${Get.find<RootViewController>().appSettingData.value.data.plantDetailsRetentionDays} days from the search date.",style: StyleResource.instance.styleRegularItalic(DimensionResource.fontSizeSmall, ColorResource.instance.textColor_2),).paddingOnly(left:DimensionResource.paddingSizeDefault ,right: DimensionResource.paddingSizeDefault,top: DimensionResource.paddingSizeDefault),
          Expanded(
            child: PaginationView<CollectionPlantData>(
                onRefresh: (){Get.find<RootViewController>().getAppVersions(); controller.onInit();},
                sidePadding:const EdgeInsets.symmetric(vertical: DimensionResource.marginSizeDefault,horizontal: DimensionResource.marginSizeDefault),
                showItemList: controller.collectionPlantPaginationViewController.itemList,
                pagingScrollController:controller.collectionPlantPaginationViewController,
                mainView:(BuildContext context, int index,CollectionPlantData itemData) =>MyCollectionCard(
                  title: itemData.commonName??"",
                  subTitle:itemData.scientificName??"",
                  searchDate: itemData.searchDate,
                  validTill: itemData.validTill,
                  showValidity: itemData.searchDate != null && itemData.searchDate !=null,
                  image: itemData.image??"",
                  onAddNoteTap: () {
                    controller.selectedPlantData = itemData;
                    controller.addBottomSheet();
                  },
                  onMenuTap: (cardContext) {
                    controller.selectedPlantData = itemData;
                    controller.showCollectionMenu(cardContext);
                  },
                  onCardTap: (){
                    controller.selectedPlantData = itemData;
                    Get.toNamed(Routes.plantsDetailScreen,arguments: {"id":controller.selectedPlantData.plantId,"type":2,"notes_id": controller.selectedPlantData.id});
                  },
            
                ).paddingOnly(bottom: DimensionResource.marginSizeDefault)
            ),
          ),
        ],
      );
    }
    else if(controller.collectionPlantData.value.status==true && controller.collectionPlantPaginationViewController.itemList.isEmpty){
      return   NoDataFoundScreen(message: "no_data_found".tr,onRefresh: ()=>controller.onInit(),);
    }
    else {
      return CollectionViewShimmer();
    }
  });


}

class MyCollectionCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String image;
  final String? searchDate;
  final String? validTill;
  final bool showValidity;

  final void Function(BuildContext) onMenuTap;
  final VoidCallback onAddNoteTap;
  final VoidCallback? onCardTap;


  const MyCollectionCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.image,
    required this.onMenuTap,
    required this.onAddNoteTap,
    this.onCardTap,
     this.searchDate,
     this.validTill, this.showValidity = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        YRoundedContainer(
          onTap: onCardTap,
          radius: 10,
          padding: EdgeInsets.all(DimensionResource.marginSizeSmall),
          showBorder: true,
          borderColor:
          ColorResource.instance.black.withValues(alpha: 0.1),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  YRoundedImage(
                    backgroundColor:
                    ColorResource.instance.socialButtonGreenColor,
                    imageUrl: image,
                    isNetworkImage: image.startsWith("http") ? true : false,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    padding: EdgeInsets.all(DimensionResource.paddingSizeExtraSmall),
                    border: Border.all(
                      color: ColorResource.instance.btnBorderGreen
                          .withValues(alpha: 0.6),
                    ),
                  ),
                  Gap(DimensionResource.marginSizeSmall),

                  /// Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: StyleResource.instance.styleBold(
                            DimensionResource.fontSizeDefault,
                            ColorResource.instance.textDarkGreenColor,
                          ),
                        ).paddingOnly(
                            bottom:
                            DimensionResource.paddingSizeExtraExtraSmall),

                        Text(
                          subTitle,
                          style: StyleResource.instance.styleRegular(
                            DimensionResource.fontSizeDefault,
                            ColorResource.instance.textColor_2,
                          ),
                        ).paddingOnly(
                            bottom:
                            DimensionResource.paddingSizeExtraExtraSmall),

                        /// Add Note Button
                        YRoundedContainer(
                          onTap: onAddNoteTap,
                          radius: 7,
                          padding: EdgeInsets.symmetric(
                            horizontal:
                            DimensionResource.paddingSizeDefault,
                            vertical:
                            DimensionResource.paddingSizeExtraSmall,
                          ),
                          backgroundColor:
                          ColorResource.instance.btnGreenColor,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                ImageResource.instance.addNoteIcon,
                                height: 14,
                              ),
                              Gap(DimensionResource.marginSizeSmall),
                              Text(
                                "add_note".tr,

                                style: StyleResource.instance.styleMedium(
                                  DimensionResource.fontSizeSmall,
                                  ColorResource.instance.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        /// uncomment this to add indicator
                        //  YRoundedContainer(
                        //    backgroundColor: ColorResource.instance.socialButtonGreenColor,
                        //    padding: EdgeInsets.all(DimensionResource.marginSizeExtraSmall),
                        //    radius: 0,
                        //    child: Row(
                        //      children: [
                        //        Image.asset(ImageResource.instance.collectionIndicatorIcon,height: 10,),
                        //        Gap(DimensionResource.marginSizeExtraSmall),
                        //        Expanded(child: Text("check_watering".tr,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.btnGreenColor),)),
                        //        YRoundedContainer(
                        //          backgroundColor: ColorResource.instance.white,
                        //          padding: EdgeInsets.all(DimensionResource.marginSizeExtraSmall/2),
                        //          radius: 0,
                        //          child: Text("20 aug 25",style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeExtraSmall, ColorResource.instance.btnGreenColor),),
                        //
                        //        )
                        //      ],
                        //    ),
                        //  )
                      ],
                    ),
                  ),

                  /// Menu Button
                  Builder(
                    builder: (cardContext) {
                      return YInkwell(
                        onTap: () {
                          onMenuTap(cardContext);
                        },
                        child: Icon(
                          Icons.more_vert,
                          size: 28,
                          color: ColorResource.instance.grey_5,
                        ).paddingSymmetric(horizontal:  5),
                      );
                    },
                  ),

                ],
              ),
              if(showValidity)
              Row(children: [
                Expanded(child: Center(child: Text("${"search_date".tr} : $searchDate",style: StyleResource.instance.styleRegular(DimensionResource.fontSizeExtraSmall + 1, ColorResource.instance.textColor_2),))),
                Gap(DimensionResource.marginSizeExtraSmall + 2),
                Expanded(child: Center(child: Text("${"valid_till".tr} : $validTill",style: StyleResource.instance.styleRegular(DimensionResource.fontSizeExtraSmall + 1, ColorResource.instance.textColor_2),))),

              ],).paddingOnly(top: DimensionResource.marginSizeSmall)
            ],
          ),
        ),



      ],
    );
  }
}


class MenuOverlay extends StatelessWidget {
  final double top;
  final double left;
  final VoidCallback onDelete;
  final VoidCallback onClose;

  const MenuOverlay({
    super.key,
    required this.top,
    required this.left,
    required this.onDelete,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.translucent,
            ),
          ),

          Positioned(
            top: top,
            left: left,
            child: Container(
              width: 180,
              decoration: BoxDecoration(
                color: ColorResource.instance.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: ColorResource.instance.btnBorderGreen.withValues(alpha: 0.4)),
                boxShadow: [
                  BoxShadow(
                    color: ColorResource.instance.btnBorderGreen.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _menuItem(ImageResource.instance.binIcon, 'delete_plant'.tr, onDelete),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
      String icon,
      String title,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFDFF2D7),
              child:  Image.asset(icon, height: 16,),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}