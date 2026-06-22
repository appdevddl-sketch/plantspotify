import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/plant_detail_model.dart';
import 'package:plants_spotify/model/model/root_view_models/nursery_models/plant_notes_model.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/basic_information_screen/basic_information_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/care_conditions_screen/care_conditions_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/flower_details_screen/flower_detail_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/fruit_details_screen/fruit_details_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/gallery_screen/gallery_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/geo_location/geo_location_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/toxicity_information_screen/toxicity_information_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/uses_screen/uses_screen.dart';
import 'package:plants_spotify/view/widgets/button_view/common_widget_button.dart';
import 'package:plants_spotify/view/widgets/button_view/yinkwell.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_image.dart';
import 'package:plants_spotify/view/widgets/loader_helper/loader_helper_ui.dart';
import 'package:plants_spotify/view/widgets/no_data_screen/noDataScreen.dart';
import 'package:plants_spotify/view/widgets/pagination_view/pagination_view_screen.dart';
import 'package:plants_spotify/view/widgets/shimmer_box/view_shimmers/plant_detail_shimmer.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/plant_detail_controller/plant_detail_controller.dart';
import '../../../base_view/base_view_screen.dart';
import 'view_holder/other_details_screen/other_details_screen.dart';

class PlantDetailView extends StatelessWidget {
  const PlantDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    PlantDetailController controller = Get.put(PlantDetailController());
    return Obx(
      ()=> BaseView(
          viewControl: controller,
          appbarPerimeter: AppbarPerimeter(
            title: controller.commonName.value,
            titleColor: ColorResource.instance.black,
            centerTitle: true,
          ),
          bottomSafeArea: Platform.isAndroid ? true : false,
          bottomBarPerimeter: BottomBarPerimeter(
            bottomBarHeight: Platform.isAndroid ? 68 : 78,
            context: context,
            widget:
                (BuildContext context, controller) => _buildBottomBar(context, controller),
          ),
          onPageBuilder:
              (BuildContext context, PlantDetailController controller) =>
                  _buildMainView(context, controller),
      ),
    );
  }
}



Widget _buildMainView(BuildContext context, PlantDetailController controller) {
  if (controller.isLoading.value == true) return PlantDetailShimmer();
  if (controller.isDataEmpty.value == true) {
    return NoDataFoundScreen(
      message: "no_data_found".tr,
      onRefresh: () => controller.refreshData(),
    );
  }

  return Column(
    children: [
      /// TabBar – fixed at top
      Container(
        color: Colors.white,
        height: 110,
        child: _buildTabs(context, controller),
      ),
      /// TabBarView – each tab scrolls independently
      Expanded(
        child: TabBarView(
          controller: controller.pageController,
          children: controller.backScreenData['type'] == 3
              ? [
                  BasicInformationScreen(description: controller.identifyPlantData.value.data.plantDetails?.description ?? "N/A", characteristics: controller.identifyPlantData.value.data.plantDetails?.basicInfo?.characteristics ?? [], plantType: controller.identifyPlantData.value.data.plantDetails?.basicInfo?.plantType ?? "N/A", scientificName: controller.identifyPlantData.value.data.plantDetails?.scientificName ?? "N/A", lifespan: controller.identifyPlantData.value.data.plantDetails?.basicInfo?.lifespan ?? "N/A", distribution: (controller.identifyPlantData.value.data.plantDetails?.geoLocation ?? []).join(', '), commonName: controller.identifyPlantData.value.data.plantDetails?.commonName ?? "N/A", controller: controller, tags: controller.identifyPlantData.value.data.plantDetails?.tags ?? "", bannerImages: controller.galleryImages),
                  OtherDetailsScreen(matureHeight: controller.identifyPlantData.value.data.plantDetails?.otherDetails?.matureHeight ?? "N/A", spread: controller.identifyPlantData.value.data.plantDetails?.otherDetails?.spread ?? "N/A", color: controller.identifyPlantData.value.data.plantDetails?.otherDetails?.plantColor ?? "N/A", type: controller.identifyPlantData.value.data.plantDetails?.basicInfo?.plantType ?? "N/A", plantingTime: controller.identifyPlantData.value.data.plantDetails?.otherDetails?.plantingTime ?? "N/A"),
                  GalleryScreen(images: controller.galleryImages),
                  FlowerDetailScreen(bloomingTime: controller.identifyPlantData.value.data.plantDetails?.flowerDetails?.bloomingTime ?? "N/A", flowerColor: controller.identifyPlantData.value.data.plantDetails?.flowerDetails?.flowerColor ?? "N/A", flowerSize: controller.identifyPlantData.value.data.plantDetails?.flowerDetails?.flowerSize ?? "N/A", growthConditions: controller.identifyPlantData.value.data.plantDetails?.flowerDetails?.growthConditions ?? "N/A"),
                  FruitDetailsScreen(fruitColor: controller.identifyPlantData.value.data.plantDetails?.fruitDetails?.fruitColor ?? "N/A", fruitingTime: controller.identifyPlantData.value.data.plantDetails?.fruitDetails?.fruitDetailsTime ?? "N/A", harvestTime: controller.identifyPlantData.value.data.plantDetails?.fruitDetails?.harvestTime ?? "N/A"),
                  ToxicityInformationScreen(toxicityToHumans: controller.identifyPlantData.value.data.plantDetails?.toxicity?.toxicToHumans == true ? "yes".tr : "no".tr, toxicityToPets: controller.identifyPlantData.value.data.plantDetails?.toxicity?.toxicToPets == true ? "yes".tr : "no".tr, weedPotential: "N/A"),
                  CareConditionsScreen(temperature: controller.identifyPlantData.value.data.plantDetails?.careConditions?.temperatureRange ?? "N/A", hardinessZones: controller.identifyPlantData.value.data.plantDetails?.careConditions?.hardinessZone ?? "N/A", sunlightRequirements: controller.identifyPlantData.value.data.plantDetails?.careConditions?.sunlight ?? "N/A", soilRequirements: controller.identifyPlantData.value.data.plantDetails?.careConditions?.soil ?? "N/A"),
                  UsesScreen(data: controller.identifyPlantData.value.data.plantDetails?.basicInfo?.uses ?? []),
                  GeoLocationScreen(locations: controller.identifyPlantData.value.data.plantDetails?.geoLocation ?? []),
                ]
              : [
                  BasicInformationScreen(description: controller.plantDetailData.value.data.description ?? "N/A", characteristics: controller.plantDetailData.value.data.basicInfo?.characteristics ?? [], plantType: controller.plantDetailData.value.data.basicInfo?.plantType ?? "N/A", scientificName: controller.plantDetailData.value.data.scientificName ?? "N/A", lifespan: controller.plantDetailData.value.data.basicInfo?.lifespan ?? "N/A", distribution: (controller.plantDetailData.value.data.geoLocation ?? []).join(', '), commonName: controller.plantDetailData.value.data.commonName ?? "N/A", controller: controller, tags: controller.plantDetailData.value.data.tags ?? "", bannerImages: controller.galleryImages),
                  OtherDetailsScreen(matureHeight: controller.plantDetailData.value.data.otherDetails?.matureHeight ?? "N/A", spread: controller.plantDetailData.value.data.otherDetails?.spread ?? "N/A", color: controller.plantDetailData.value.data.otherDetails?.plantColor ?? "N/A", type: controller.plantDetailData.value.data.basicInfo?.plantType ?? "N/A", plantingTime: controller.plantDetailData.value.data.otherDetails?.plantingTime ?? "N/A"),
                  GalleryScreen(images: controller.galleryImages),
                  FlowerDetailScreen(bloomingTime: controller.plantDetailData.value.data.flowerDetails?.bloomingTime ?? "N/A", flowerColor: controller.plantDetailData.value.data.flowerDetails?.flowerColor ?? "N/A", flowerSize: controller.plantDetailData.value.data.flowerDetails?.flowerSize ?? "N/A", growthConditions: controller.plantDetailData.value.data.flowerDetails?.growthConditions ?? "N/A"),
                  FruitDetailsScreen(fruitColor: controller.plantDetailData.value.data.fruitDetails?.fruitColor ?? "N/A", fruitingTime: controller.plantDetailData.value.data.fruitDetails?.fruitDetailsTime ?? "N/A", harvestTime: controller.plantDetailData.value.data.fruitDetails?.harvestTime ?? "N/A"),
                  ToxicityInformationScreen(toxicityToHumans: controller.plantDetailData.value.data.toxicity?.toxicToHumans == true ? "yes".tr : "no".tr, toxicityToPets: controller.plantDetailData.value.data.toxicity?.toxicToPets == true ? "yes".tr : "no".tr, weedPotential: "N/A"),
                  CareConditionsScreen(temperature: controller.plantDetailData.value.data.careConditions?.temperatureRange ?? "N/A", hardinessZones: controller.plantDetailData.value.data.careConditions?.hardinessZone ?? "N/A", sunlightRequirements: controller.plantDetailData.value.data.careConditions?.sunlight ?? "N/A", soilRequirements: controller.plantDetailData.value.data.careConditions?.soil ?? "N/A"),
                  UsesScreen(data: controller.plantDetailData.value.data.basicInfo?.uses ?? []),
                  GeoLocationScreen(locations: controller.plantDetailData.value.data.geoLocation ?? []),
                ],
        ),
      ),
    ],
  );
}

Widget _buildBottomBar(BuildContext context, PlantDetailController controller) {
  return Obx(
    ()=> (controller.isLoading.value == true || controller.isDataEmpty.value == true) ?  SizedBox.shrink():Container(
      height: Platform.isAndroid ? 68 : 78,
      padding: EdgeInsets.all(DimensionResource.marginSizeSmall),
      decoration: BoxDecoration(
        color: ColorResource.instance.white,
        boxShadow: DecorationResource.instance.containerLightBoxShadow(),
      ),
      child: Row(
        children: [
          if (controller.backScreenData["type"] == 3 && controller.isFeedback.value == false)
            Expanded(
              child: CommonWidgetButton(
                color: ColorResource.instance.btnGreenColor,
                widget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_note_sharp, size: 15, color: ColorResource.instance.white),
                    Gap(DimensionResource.marginSizeExtraSmall),
                    Text(
                      "give_feedback".tr,
                      style: StyleResource.instance.styleMedium(
                        DimensionResource.fontSizeSmall,
                        ColorResource.instance.white,
                      ),
                    ),
                  ],
                ),
                loading: controller.isLoading.value,
                onPressed: () => controller.showFeedbackPopup(),
              ).paddingOnly(right: 4),
            ),
          if (controller.backScreenData["type"] == 3 && controller.isFeedback.value == false)
            (controller.identifyPlantData.value.data.plantDetails?.isAdded ?? false)
              ? CommonWidgetButton(
                  width: 120,
                  color: ColorResource.instance.btnGreenColor,
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark, size: 16, color: ColorResource.instance.white),
                      Gap(DimensionResource.marginSizeExtraSmall),
                      Text(
                        "saved".tr,
                        style: StyleResource.instance.styleMedium(
                          DimensionResource.fontSizeSmall,
                          ColorResource.instance.white,
                        ),
                      ),
                    ],
                  ),
                  loading: false,
                  onPressed: () async {
                    await controller.getCollection();
                    controller.plantsBottomSheet();
                  },
                )
              : CommonWidgetButton(
                  width: 120,
                  color: ColorResource.instance.textColor_2,
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(ImageResource.instance.saveIcon, height: 12),
                      Gap(DimensionResource.marginSizeExtraSmall),
                      Text(
                        "save".tr,
                        style: StyleResource.instance.styleMedium(
                          DimensionResource.fontSizeSmall,
                          ColorResource.instance.white,
                        ),
                      ),
                    ],
                  ),
                  loading: false,
                  onPressed: () async {
                    await controller.getCollection();
                    controller.plantsBottomSheet();
                  },
                ),
          if (controller.backScreenData["type"] == 3 && controller.isFeedback.value == true)
            Expanded(
              child: (controller.identifyPlantData.value.data.plantDetails?.isAdded ?? false)
                ? CommonWidgetButton(
                    color: ColorResource.instance.btnGreenColor,
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bookmark, size: 16, color: ColorResource.instance.white),
                        Gap(DimensionResource.marginSizeExtraSmall),
                        Text(
                          "saved".tr,
                          style: StyleResource.instance.styleMedium(
                            DimensionResource.fontSizeSmall,
                            ColorResource.instance.white,
                          ),
                        ),
                      ],
                    ),
                    loading: false,
                    onPressed: () async {
                      await controller.getCollection();
                      controller.plantsBottomSheet();
                    },
                  )
                : CommonWidgetButton(
                    color: ColorResource.instance.textColor_2,
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(ImageResource.instance.saveIcon, height: 12),
                        Gap(DimensionResource.marginSizeExtraSmall),
                        Text(
                          "save".tr,
                          style: StyleResource.instance.styleMedium(
                            DimensionResource.fontSizeSmall,
                            ColorResource.instance.white,
                          ),
                        ),
                      ],
                    ),
                    loading: false,
                    onPressed: () async {
                      await controller.getCollection();
                      controller.plantsBottomSheet();
                    },
                  ),
            ),
          if (controller.backScreenData["type"] != 3)
            Expanded(
              child: (controller.backScreenData["type"] == 3 ? controller.identifyPlantData.value.data.plantDetails?.isAdded : controller.plantDetailData.value.data.isAdded) ?? false
                ? CommonWidgetButton(
                    color: ColorResource.instance.btnGreenColor,
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bookmark, size: 16, color: ColorResource.instance.white),
                        Gap(DimensionResource.marginSizeExtraSmall),
                        Text(
                          "saved".tr,
                          style: StyleResource.instance.styleMedium(
                            DimensionResource.fontSizeSmall,
                            ColorResource.instance.white,
                          ),
                        ),
                      ],
                    ),
                    loading: controller.isLoading.value,
                    onPressed: () async {
                      await controller.getCollection();
                      controller.plantsBottomSheet();
                    },
                  )
                : CommonWidgetButton(
                    color: ColorResource.instance.textColor_2,
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(ImageResource.instance.saveIcon, height: 12),
                        Gap(DimensionResource.marginSizeExtraSmall),
                        Text(
                          "save".tr,
                          style: StyleResource.instance.styleMedium(
                            DimensionResource.fontSizeSmall,
                            ColorResource.instance.white,
                          ),
                        ),
                      ],
                    ),
                    loading: controller.isLoading.value,
                    onPressed: () async {
                      await controller.getCollection();
                      controller.plantsBottomSheet();
                    },
                  ),
            ),
        ],
      ),
    ),
  );
}

Widget _buildTabs(BuildContext context, PlantDetailController controller) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Obx(
      () => Row(
        children: List.generate(
          controller.orderCategory.length,
              (index) => GestureDetector(
            key: controller.tabKeys[index],
            onTap: () => controller.onChangeButtonTapped(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 50),
              padding: const EdgeInsets.symmetric(
                horizontal: DimensionResource.marginSizeSmall,
                vertical: DimensionResource.marginSizeSmall,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: ColorResource.instance.btnBorderGreen.withValues(
                    alpha: 0.6,
                  ),
                ),
                color:
                controller.selectCategoryIndex.value == index
                    ? ColorResource.instance.btnGreenColor
                    : ColorResource.instance.socialButtonGreenColor,
              ),
              child: Container(
                width: 75,
                height: 75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    YRoundedContainer(
                      height: 30,
                      width: 30,
                      padding: EdgeInsets.all(
                        DimensionResource.paddingSizeExtraSmall,
                      ),
                      child: Center(
                        child: Image.asset(
                          controller.orderCategory[index]["image"],
                          height: 15,
                        ),
                      ),
                    ).paddingOnly(
                      bottom: DimensionResource.marginSizeSmall,
                    ),
                    Flexible(
                      child: Text(
                        controller.orderCategory[index]["title"],
                        style: StyleResource.instance.styleSemiBold(
                          DimensionResource.fontSizeSmallTo,
                          controller.selectCategoryIndex.value == index
                              ? ColorResource.instance.white
                              : ColorResource.instance.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).paddingOnly(right: DimensionResource.marginSizeSmall),
          ),
        ),
      ).paddingOnly(left: DimensionResource.paddingSizeSmall),
    ),
  );
}

class PlantInfoItem extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final double? height;
  final int? maxLines;

  const PlantInfoItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.height,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            YRoundedContainer(
              height: 30,
              width: 30,
              padding: EdgeInsets.all(DimensionResource.paddingSizeExtraSmall),
              child: Center(child: Image.asset(icon, height: 15)),
            ),

            Gap(DimensionResource.paddingSizeExtraSmall),

            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: StyleResource.instance.styleBold(
                      DimensionResource.fontSizeSmallTo,
                      ColorResource.instance.textDarkGreenColor,
                    ),
                  ),

                  Text(
                    value,
                    maxLines: maxLines ?? 5,
                    overflow: TextOverflow.ellipsis,
                    style: StyleResource.instance.styleMedium(
                      DimensionResource.fontSizeSmallTo,
                      ColorResource.instance.textColor_10.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ).paddingOnly(right: DimensionResource.paddingSizeSmall),
            ),
          ],
        ),
      ),
    );
  }
}



class TimelineItem extends StatelessWidget {
  final String title;
  final String description;
  final bool isLast;
  final List<String> imageUrls;
  final void Function(BuildContext context) onTap;


  const TimelineItem({
    super.key,
    required this.title,
    required this.description,
    this.isLast = false,
    required this.imageUrls, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// TIMELINE
          Column(
            children: [
              Image.asset(ImageResource.instance.clockOutlinedIcon, height: 18),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.only(top: 2),
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: NotesDetailCard(
              title: title,
              value: description,
              imageUrls: imageUrls, onTap: onTap ,
            ).marginOnly(bottom: DimensionResource.marginSizeSmall),
          ),
        ],
      ),
    );
  }
}
class NotesDetailCard extends StatelessWidget {
  final String title;
  final String value;
  final EdgeInsetsGeometry? padding;
  final List<String>? imageUrls;
  final void Function(BuildContext context) onTap;


  const NotesDetailCard({
    super.key,
    required this.title,
    required this.value,
    this.padding, this.imageUrls,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        YRoundedContainer(
          radius: 5,
          width: HelperFunction.screenWidth(),
          showBorder: true,
          backgroundColor: ColorResource.instance.socialButtonGreenColor,
          borderColor:
          ColorResource.instance.btnGreenColor.withValues(alpha: 0.05),
          padding: padding ??
              EdgeInsets.all(DimensionResource.paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TITLE
              Text(
                title.tr,
                style: StyleResource.instance.styleSemiBold(
                  DimensionResource.fontSizeDefault,
                  ColorResource.instance.black,
                ),
              ).paddingOnly(
                bottom: DimensionResource.marginSizeExtraSmall,
              ),

              /// VALUE
              Text(
                value,
                style: StyleResource.instance.styleRegular(
                  DimensionResource.fontSizeSmall,
                  ColorResource.instance.textColor_2,
                ),
              ).paddingOnly(
                bottom: DimensionResource.marginSizeExtraSmall,
              ),
              if(imageUrls?.isNotEmpty ?? false)
                SizedBox(
                  width: HelperFunction.screenWidth(),
                  child: Wrap(
                    children: List.generate(imageUrls?.length??0, (index) => SizedBox(width: 70,height: 70,child:
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(8),
                      child: YRoundedImage(
                        borderRadius: 0,
                        imageUrl: imageUrls?[index]??"N/A",
                        fit: BoxFit.cover,
                        height: 70,width: 70,
                      ),
                    ),
                    ).paddingOnly(right:DimensionResource.paddingSizeSmall,top: DimensionResource.paddingSizeExtraSmall,bottom: DimensionResource.paddingSizeExtraSmall),
                    ),
                  ),
                )

            ],
          ),
        ),
        Positioned(right:5,top:7,child: YInkwell(onTap:() => onTap.call(context) ,child: Icon(Icons.more_vert,color: ColorResource.instance.grey_5,)))
      ],
    );
  }
}

class DetailMenuOverlay extends StatelessWidget {
  final double top;
  final double left;
  final VoidCallback onRename;
  final VoidCallback onDelete;
  final VoidCallback onClose;

  const DetailMenuOverlay({
    super.key,
    required this.top,
    required this.left,
    required this.onRename,
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
                  _menuItem(ImageResource.instance.editPenOutlined, 'edit'.tr, onRename),
                  Divider(color: ColorResource.instance.lightGrey.withValues(alpha: 0.2),).paddingSymmetric(horizontal: DimensionResource.paddingSizeDefault),
                  _menuItem(ImageResource.instance.binIcon, 'delete'.tr, onDelete),
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