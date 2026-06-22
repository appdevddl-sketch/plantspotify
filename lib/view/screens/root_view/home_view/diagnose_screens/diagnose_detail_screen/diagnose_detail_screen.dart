import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/diagnose_screens/diagnose_detail_screen/view_holder/diagnose_analysis_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/diagnose_screens/diagnose_detail_screen/view_holder/diagnose_basic_information_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/diagnose_screens/diagnose_detail_screen/view_holder/diagnose_prevention_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/diagnose_screens/diagnose_detail_screen/view_holder/diagnose_solutions_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/diagnose_screens/diagnose_detail_screen/view_holder/diagnose_symptoms_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/care_conditions_screen/care_conditions_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/flower_details_screen/flower_detail_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/fruit_details_screen/fruit_details_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/gallery_screen/gallery_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/geo_location/geo_location_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/other_details_screen/other_details_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/toxicity_information_screen/toxicity_information_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/uses_screen/uses_screen.dart';
import 'package:plants_spotify/view/widgets/button_view/common_widget_button.dart';
import 'package:plants_spotify/view/widgets/no_data_screen/noDataScreen.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/diagnose_screens_controller/diagnose_detail_controller/diagnose_detail_controller.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';


class DiagnoseDetailScreen extends StatelessWidget {
  const DiagnoseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DiagnoseDetailController controller = Get.put(DiagnoseDetailController());
    return BaseView(
        viewControl: controller,
        appbarPerimeter: AppbarPerimeter(
          title: controller.commonName.value,
          titleColor: ColorResource.instance.black,
          centerTitle: true,
        ),
        bottomSafeArea: Platform.isAndroid ? true : false,
        showNetworkStatusBar: Get.currentRoute != Routes.rootView ? true : false,
        bottomBarPerimeter: BottomBarPerimeter(
          bottomBarHeight: Platform.isAndroid ? 68 : 78,
          context: context,
          widget: (BuildContext context, controller) => _buildBottomBar(context, controller),
        ),
        onPageBuilder: (BuildContext context, DiagnoseDetailController controller) =>
            _buildMainView(context, controller),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN VIEW
// ─────────────────────────────────────────────────────────────────────────────

Widget _buildMainView(BuildContext context, DiagnoseDetailController controller) {
  if (controller.isDataEmpty.value == true) {
    return NoDataFoundScreen(
      message: "no_data_found".tr,
    );
  }

  final bool isHealthy = (controller.diagnoseData.value.overallHealthScore ?? 0) >= 9;

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
          children: _buildTabChildren(controller, isHealthy),
        ),
      ),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB CHILDREN
// ─────────────────────────────────────────────────────────────────────────────

List<Widget> _buildTabChildren(DiagnoseDetailController controller, bool isHealthy) {
  final d = controller.diagnoseData.value;

  // ── Shared plant-detail tabs (reused exactly as in plant_detail_view.dart) ─
  final otherDetails = OtherDetailsScreen(
    matureHeight: d.plantDetails?.otherDetails?.matureHeight ?? "N/A",
    spread: d.plantDetails?.otherDetails?.spread ?? "N/A",
    color: d.plantDetails?.otherDetails?.plantColor ?? "N/A",
    type: d.plantDetails?.basicInfo?.plantType ?? "N/A",
    plantingTime: d.plantDetails?.otherDetails?.plantingTime ?? "N/A",
  );
  final flowerDetails = FlowerDetailScreen(
    bloomingTime: d.plantDetails?.flowerDetails?.bloomingTime ?? "N/A",
    flowerColor: d.plantDetails?.flowerDetails?.flowerColor ?? "N/A",
    flowerSize: d.plantDetails?.flowerDetails?.flowerSize ?? "N/A",
    growthConditions: d.plantDetails?.flowerDetails?.growthConditions ?? "N/A",
  );
  final fruitDetails = FruitDetailsScreen(
    fruitColor: d.plantDetails?.fruitDetails?.fruitColor ?? "N/A",
    fruitingTime: d.plantDetails?.fruitDetails?.fruitDetailsTime ?? "N/A",
    harvestTime: d.plantDetails?.fruitDetails?.harvestTime ?? "N/A",
  );
  final toxicity = ToxicityInformationScreen(
    toxicityToHumans: d.plantDetails?.toxicity?.toxicToHumans == true ? "yes".tr : "no".tr,
    toxicityToPets: d.plantDetails?.toxicity?.toxicToPets == true ? "yes".tr : "no".tr,
    weedPotential: "N/A",
  );
  final careConditions = CareConditionsScreen(
    temperature: d.plantDetails?.careConditions?.temperatureRange ?? "N/A",
    hardinessZones: d.plantDetails?.careConditions?.hardinessZone ?? "N/A",
    sunlightRequirements: d.plantDetails?.careConditions?.sunlight ?? "N/A",
    soilRequirements: d.plantDetails?.careConditions?.soil ?? "N/A",
  );
  final uses = UsesScreen(data: d.plantDetails?.basicInfo?.uses ?? []);
  final geoLocation = GeoLocationScreen(locations: d.plantDetails?.geoLocation ?? []);

  // ── Tab 1 – Basic Info (healthy variant shows happy-plant card inside) ──────
  final basicInfo = DiagnoseBasicInformationScreen(
    commonName: d.plantDetails?.commonName ?? "N/A",
    plantType: d.plantDetails?.basicInfo?.plantType ?? "N/A",
    scientificName: d.plantDetails?.scientificName ?? "N/A",
    lifespan: d.plantDetails?.basicInfo?.lifespan ?? "N/A",
    distribution: (d.plantDetails?.geoLocation ?? []).join(', '),
    tags: d.plantDetails?.tags ?? "",
    description: d.plantDetails?.description ?? "N/A",
    characteristics: d.plantDetails?.basicInfo?.characteristics ?? [],
    isHealthy: isHealthy,
    healthMessage: d.message,
    bannerImages: controller.diagnoseBanner,
  );

  final gallery = GalleryScreen(images: d.plantDetails?.images?.map((e) => e.url).whereType<String>().toList() ?? []);

  if (isHealthy) {
    // 9 tabs – plant is healthy, no diagnosis tabs needed
    return [
      basicInfo,
      otherDetails,
      gallery,
      flowerDetails,
      fruitDetails,
      toxicity,
      careConditions,
      uses,
      geoLocation,
    ];
  } else {
    // 13 tabs – diagnosis data + plant detail tabs + gallery
    return [
      basicInfo,
      DiagnoseSymptomsScreen(controller: controller),
      DiagnoseAnalysisScreen(controller: controller),
      DiagnoseSolutionsScreen(controller: controller),
      DiagnosePreventionScreen(controller: controller),
      otherDetails,
      gallery,
      flowerDetails,
      fruitDetails,
      toxicity,
      careConditions,
      uses,
      geoLocation,
    ];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB BAR  (identical animated-button pattern from plant_detail_view.dart)
// ─────────────────────────────────────────────────────────────────────────────

Widget _buildTabs(BuildContext context, DiagnoseDetailController controller) {
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
                  color: ColorResource.instance.btnBorderGreen.withValues(alpha: 0.6),
                ),
                color: controller.selectCategoryIndex.value == index
                    ? ColorResource.instance.btnGreenColor
                    : ColorResource.instance.socialButtonGreenColor,
              ),
              child: SizedBox(
                width: 75,
                height: 75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    YRoundedContainer(
                      height: 30,
                      width: 30,
                      padding: EdgeInsets.all(DimensionResource.paddingSizeExtraSmall),
                      child: Center(
                        child: Image.asset(
                          controller.orderCategory[index]["image"],
                          height: 15,
                        ),
                      ),
                    ).paddingOnly(bottom: DimensionResource.marginSizeSmall),
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

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM BAR  (unchanged from original)
// ─────────────────────────────────────────────────────────────────────────────

Widget _buildBottomBar(BuildContext context, DiagnoseDetailController controller) {
  return Obx(
    () => controller.isDataEmpty.value == true ? SizedBox.shrink() : Container(
      height: Platform.isAndroid ? 68 : 78,
      padding: EdgeInsets.all(DimensionResource.marginSizeSmall),
      decoration: BoxDecoration(
        color: ColorResource.instance.white,
        boxShadow: DecorationResource.instance.containerLightBoxShadow(),
      ),
      child: Row(
        children: [
          if (controller.isFeedback.value == false)
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
          if (controller.isFeedback.value == false)
            controller.diagnoseData.value.plantDetails?.isAdded ?? false
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
          if (controller.isFeedback.value == true)
            controller.diagnoseData.value.plantDetails?.isAdded ?? false
              ? Expanded(
                  child: CommonWidgetButton(
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
                  ),
                )
              : Expanded(
                  child: CommonWidgetButton(
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
        ],
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED WIDGETS  (kept here so view_holder tab files can import them)
// ─────────────────────────────────────────────────────────────────────────────

class SymptomDetailCard extends StatelessWidget {
  final String title;
  final dynamic value;
  final double? titleSize;
  final double? height;
  final double? subTitleSize;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;

  const SymptomDetailCard({
    super.key,
    required this.title,
    required this.value,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.titleSize,
    this.subTitleSize,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: YRoundedContainer(
        radius: 5,
        height: height,
        width: HelperFunction.screenWidth(),
        showBorder: true,
        backgroundColor: backgroundColor ?? ColorResource.instance.socialButtonGreenColor,
        borderColor: borderColor ?? ColorResource.instance.btnGreenColor.withValues(alpha: 0.05),
        padding: padding ?? EdgeInsets.all(DimensionResource.paddingSizeDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.tr.isNotEmpty)
              Text(
                title.tr,
                style: StyleResource.instance.styleSemiBold(
                  titleSize ?? DimensionResource.fontSizeDefault,
                  ColorResource.instance.black,
                ),
              ).paddingOnly(bottom: DimensionResource.marginSizeExtraSmall),
            _buildValue(),
          ],
        ),
      ),
    );
  }

  Widget _buildValue() {
    if (value is List && value.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: (value as List)
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  "• $item",
                  style: StyleResource.instance.styleRegular(
                    subTitleSize ?? DimensionResource.fontSizeSmall,
                    ColorResource.instance.textColor_2,
                  ),
                ),
              ),
            )
            .toList(),
      );
    }

    if (value is String && value.isNotEmpty) {
      return Text(
        value,
        style: StyleResource.instance.styleRegular(
          subTitleSize ?? DimensionResource.fontSizeSmall,
          ColorResource.instance.textColor_2,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
