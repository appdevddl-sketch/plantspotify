import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/common/image_enlarge_widget.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_image.dart';

class GalleryScreen extends StatelessWidget {
  final List<String> images;

  const GalleryScreen({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Center(
        child: Text(
          "no_images_found".tr,
          style: StyleResource.instance.styleRegular(
            DimensionResource.fontSizeDefault,
            ColorResource.instance.lightGrey,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(DimensionResource.paddingSizeSmall),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                barrierDismissible: true,
                pageBuilder: (BuildContext context, _, __) =>
                    ImageEnlargeWidget(
                  imageUrl: images[index],
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: YRoundedImage(
              imageUrl: images[index],
              isNetworkImage: true,
              fit: BoxFit.cover,
              borderRadius: 0,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
        );
      },
    );
  }
}
