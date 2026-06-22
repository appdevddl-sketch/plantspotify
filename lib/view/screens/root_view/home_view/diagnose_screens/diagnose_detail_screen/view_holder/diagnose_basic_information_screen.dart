import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/plant_detail_view.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/basic_information_screen/basic_information_screen.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/sliders/promo_slider.dart';

/// Tab 1 for the DiagnoseDetailScreen.
/// Mirrors the UI of [BasicInformationScreen] from plant_detail_view,
/// but works with DiagnoseDetailController data passed as parameters.
/// When [isHealthy] is true the happy-plant status card is shown inside this tab.
class DiagnoseBasicInformationScreen extends StatelessWidget {
  final String commonName;
  final String plantType;
  final String scientificName;
  final String lifespan;
  final String distribution;
  final String tags;
  final String description;
  final List<String> characteristics;
  final bool isHealthy;
  final String? healthMessage;
  final List<String> bannerImages;

  const DiagnoseBasicInformationScreen({
    super.key,
    required this.commonName,
    required this.plantType,
    required this.scientificName,
    required this.lifespan,
    required this.distribution,
    required this.tags,
    required this.description,
    required this.characteristics,
    required this.isHealthy,
    this.healthMessage,
    this.bannerImages = const [],
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (bannerImages.isNotEmpty)
            Stack(
              alignment: Alignment.topRight,
              children: [
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
                ),
                Obx(() {
                  final promoController = Get.put(PromoSliderController());
                  return promoController.carouselCurrentIndex.value == 0
                    ? Positioned(
                        left: 0,
                        child: YRoundedContainer(
                          padding: EdgeInsets.all(DimensionResource.paddingSizeExtraSmall),
                          backgroundColor: ColorResource.instance.textRed,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6),
                            bottomRight: Radius.circular(6),
                          ),
                          child: Text(
                            isHealthy ? "your_scanned_plant".tr : "your_affected_plant".tr,
                            style: StyleResource.instance.styleMedium(
                              DimensionResource.fontSizeExtraSmall - 3,
                              ColorResource.instance.white,
                            ),
                          ),
                        ),
                      )
                    : Positioned(
                        right: 0,
                        child: YRoundedContainer(
                          padding: EdgeInsets.all(DimensionResource.paddingSizeExtraSmall),
                          backgroundColor: ColorResource.instance.black,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            bottomLeft: Radius.circular(6),
                          ),
                          child: Text(
                            "healthy_plant".tr,
                            style: StyleResource.instance.styleMedium(
                              DimensionResource.fontSizeExtraSmall - 3,
                              ColorResource.instance.white,
                            ),
                          ),
                        ),
                      );
                }),
              ],
            ).paddingOnly(bottom: DimensionResource.paddingSizeExtraSmall),
          if (bannerImages.isNotEmpty)
            Text("image_expand_text".tr, style: StyleResource.instance.styleRegularItalic(DimensionResource.fontSizeExtraSmall - 2, ColorResource.instance.lightGrey)).paddingOnly(bottom: DimensionResource.paddingSizeDefault),
          if (bannerImages.isNotEmpty)
            Divider(color: ColorResource.instance.dividerGrey, thickness: 2).paddingOnly(bottom: DimensionResource.paddingSizeDefault),
          /// ── Orange summary card (same as BasicInformationScreen) ──────────
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
                      value: plantType,
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
                    if (tags.isNotEmpty)
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

          /// ── Healthy-plant status card (Tab 1 only when healthy) ───────────
          if (isHealthy)
            YRoundedContainer(
              height: 210,
              radius: 8,
              padding: EdgeInsets.all(DimensionResource.paddingSizeSmall),
              width: HelperFunction.screenWidth(),
              gradient: LinearGradient(
                colors: [
                  ColorResource.instance.gradientGreenColor,
                  ColorResource.instance.gradientGreenColor.withValues(alpha: 0.7),
                  ColorResource.instance.gradientGreenColor.withValues(alpha: 0.9),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImageResource.instance.happyPlantImage,
                    height: 100,
                    fit: BoxFit.contain,
                  ).paddingOnly(bottom: DimensionResource.paddingSizeExtraSmall),
                  Text(
                    healthMessage ?? "",
                    style: StyleResource.instance.styleMedium(
                      DimensionResource.fontSizeSmall,
                      ColorResource.instance.textDarkGreenColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ).paddingOnly(bottom: DimensionResource.marginSizeDefault),

          /// ── Basic Information heading + description ───────────────────────
          Text(
            "basic_information".tr,
            style: StyleResource.instance.styleSemiBold(
              DimensionResource.fontSizeDefault,
              ColorResource.instance.textDarkGreenColor2,
            ),
          ).paddingOnly(bottom: DimensionResource.marginSizeSmall),

          Text(
            description,
            style: StyleResource.instance.styleRegular(
              DimensionResource.fontSizeSmall,
              ColorResource.instance.textColor_2,
            ),
          ).paddingOnly(bottom: DimensionResource.marginSizeDefault),

          /// ── Characteristics card ─────────────────────────────────────────
          if (characteristics.isNotEmpty)
            YRoundedContainer(
              width: HelperFunction.screenWidth(),
              backgroundColor: ColorResource.instance.socialButtonGreenColor,
              padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "characterstics".tr,
                    style: StyleResource.instance.styleSemiBold(
                      DimensionResource.fontSizeDefault,
                      ColorResource.instance.textDarkGreenColor,
                    ),
                  ).paddingOnly(bottom: DimensionResource.marginSizeExtraSmall),

                  ...characteristics.map(
                    (item) => PlantCharactersticRow(
                      icon: ImageResource.instance.leafIcon,
                      text: item,
                    ).paddingOnly(bottom: DimensionResource.marginSizeExtraSmall),
                  ),
                ],
              ),
            ),
        ],
      ).paddingSymmetric(horizontal:DimensionResource.paddingSizeSmall),
    );
  }
}
