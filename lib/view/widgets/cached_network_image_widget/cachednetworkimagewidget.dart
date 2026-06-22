import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../model/utils/image_resource.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final Widget? errorWidget;
  final Widget? placeholder;

  final Color? color;
  const CachedNetworkImageWidget(
      {super.key, this.color, this.fit = BoxFit.cover, required this.imageUrl,this.height, this.width, this.errorWidget, this.placeholder});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      color: color,
      placeholder: (context, url) => placeholder ?? Image.asset(
        ImageResource.instance.placeholderImage,
        fit: BoxFit.contain,
      ),
      errorWidget: (context, url, error) => errorWidget?? Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          ImageResource.instance.errorImage,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
