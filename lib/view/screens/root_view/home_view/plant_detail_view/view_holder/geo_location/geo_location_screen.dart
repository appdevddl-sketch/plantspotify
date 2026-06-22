import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_image.dart';
import 'package:plants_spotify/view/widgets/layout/grid_layout.dart';
class GeoLocationScreen extends StatelessWidget {
  const GeoLocationScreen({
    super.key,
    required this.locations,
  });

  /// List of locations (countries / regions)
  final List<String> locations;

  @override
  Widget build(BuildContext context) {
    if (locations.isEmpty) return  SizedBox(child: Center(child: Text("no_data_found".tr,style: StyleResource.instance.styleMedium(DimensionResource.fontSizeLarge, ColorResource.instance.textColor_2),textAlign: TextAlign.center,)));

    return SingleChildScrollView(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Text(
            "geo_location_title".tr,
            style: StyleResource.instance.styleSemiBold(
              DimensionResource.fontSizeDefault,
              ColorResource.instance.textDarkGreenColor2,
            ),
          ).paddingOnly(
              bottom: DimensionResource.marginSizeDefault),

          /// GRID
          YGridLayout(
            crossAxisCount: 2,
            itemCount: locations.length,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            mainAxisExtent: 50,
            itemBuilder: (context, index) {
              return IconTextRow(
                image: ImageResource.instance.geoLocationDetailIcon,
                text: locations[index],
              );
            },
          ),
        ],
      ).paddingAll(DimensionResource.paddingSizeSmall),
    );
  }
}


class IconTextRow extends StatelessWidget {
  const IconTextRow({
    super.key, required this.image, required this.text,
  });

  final String image;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(image,height: 18,),
        Gap(DimensionResource.marginSizeExtraSmall),
        Flexible(child: Text(text,style: StyleResource.instance.styleMedium(DimensionResource.fontSizeSmall, ColorResource.instance.textColor_2),)),

      ],
    );
  }
}

