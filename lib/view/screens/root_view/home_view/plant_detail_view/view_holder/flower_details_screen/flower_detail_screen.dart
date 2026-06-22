import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/fruit_details_screen/fruit_details_screen.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_image.dart';
class FlowerDetailScreen extends StatelessWidget {
  const FlowerDetailScreen({
    super.key,
    this.bloomingTime,
    this.flowerSize,
    this.flowerColor,
    this.growthConditions,
  });

  final String? bloomingTime;
  final String? flowerSize;
  final String? flowerColor;
  final String? growthConditions;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Text(
            "flower_details".tr,
            style: StyleResource.instance.styleSemiBold(
              DimensionResource.fontSizeDefault,
              ColorResource.instance.textDarkGreenColor2,
            ),
          ).paddingOnly(
            bottom: DimensionResource.marginSizeExtraSmall,
          ),

          /// bloomingTime
          if (bloomingTime?.isNotEmpty ?? false)
            FruitDetailCard(
              icon: ImageResource.instance.plantDetailIcon,
              title: "blooming_time".tr,
              value: bloomingTime!,
            ).paddingOnly(
                bottom: DimensionResource.marginSizeDefault),

          /// flowerSize
          if (flowerSize?.isNotEmpty ?? false)
            FruitDetailCard(
              icon: ImageResource.instance.plantDetailIcon,
              title: "flower_size".tr,
              value: flowerSize!,
            ).paddingOnly(
                bottom: DimensionResource.marginSizeDefault),

          /// flowerColor
          if (flowerColor?.isNotEmpty ?? false)
            FruitDetailCard(
              icon: ImageResource.instance.plantDetailIcon,
              title: "flower_color".tr,
              value: flowerColor!,
            ).paddingOnly(
                bottom: DimensionResource.marginSizeDefault),

          /// growthConditions
          if (growthConditions?.isNotEmpty ?? false)
            FruitDetailCard(
              icon: ImageResource.instance.plantDetailIcon,
              title: "growth_conditions".tr,
              value: growthConditions!,
            ).paddingOnly(
                bottom: DimensionResource.marginSizeDefault),
          // Column(
          //   children: [
          //     /// ROW 1
          //     IntrinsicHeight(
          //       child: Row(
          //         crossAxisAlignment: CrossAxisAlignment.stretch,
          //         children: [
          //           if (bloomingTime?.isNotEmpty ?? false)
          //             Expanded(
          //               child: FlowerDetailCard(
          //                 title: "blooming_time".tr,
          //                 value: bloomingTime!,
          //               ),
          //             ),
          //
          //           if ((bloomingTime?.isNotEmpty ?? false) &&
          //               (flowerSize?.isNotEmpty ?? false))
          //             const Gap(12),
          //
          //           if (flowerSize?.isNotEmpty ?? false)
          //             Expanded(
          //               child: FlowerDetailCard(
          //                 title: "flower_size".tr,
          //                 value: flowerSize!,
          //               ),
          //             ),
          //         ],
          //       ),
          //     ),
          //
          //     const Gap(12),
          //
          //     /// ROW 2
          //     IntrinsicHeight(
          //       child: Row(
          //         crossAxisAlignment: CrossAxisAlignment.stretch,
          //         children: [
          //           if (flowerColor?.isNotEmpty ?? false)
          //             Expanded(
          //               child: FlowerDetailCard(
          //                 title: "flower_color".tr,
          //                 value: flowerColor!,
          //               ),
          //             ),
          //
          //           if ((flowerColor?.isNotEmpty ?? false) &&
          //               (growthConditions?.isNotEmpty ?? false))
          //             const Gap(12),
          //
          //           if (growthConditions?.isNotEmpty ?? false)
          //             Expanded(
          //               child: FlowerDetailCard(
          //                 title: "growth_conditions".tr,
          //                 value: growthConditions!,
          //               ),
          //             ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ).paddingAll(DimensionResource.paddingSizeSmall),
    );
  }
}

class FlowerDetailCard extends StatelessWidget {
  final String title;
  final String value;
  final EdgeInsetsGeometry? padding;
  final List<String>? imageUrls;


  const FlowerDetailCard({
    super.key,
    required this.title,
    required this.value,
    this.padding, this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    return YRoundedContainer(
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
                    imageUrl: imageUrls?[index]??"",
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
    );
  }
}
