import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/view/widgets/cached_network_image_widget/cachednetworkimagewidget.dart';

class YRoundedImage extends StatelessWidget {
  const YRoundedImage({
    super.key,
    this.width,
    this.height,
    required this.imageUrl,
    this.applyImageRadius=true,
    this.border,
    this.backgroundColor,
    this.fit=BoxFit.contain,
    this.padding,
    this.isNetworkImage=true,
    this.onPressed,
    this.borderRadius = DimensionResource.sm,this.imageHeight, this.imageColor, this.gradient
    ,

  });
  final double? width, height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color? backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;
  final double? imageHeight;
  final Color? imageColor;
  final LinearGradient? gradient;




  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(borderRadius),color: backgroundColor,border: border,gradient: gradient),
        child: ClipRRect(
            borderRadius: applyImageRadius ? BorderRadius.circular(borderRadius): BorderRadius.zero,
            child: isNetworkImage ?
            CachedNetworkImageWidget(
              imageUrl: imageUrl,height: height,width: width,fit: fit,
            ) : Image.asset(imageUrl, fit: fit,height: imageHeight,width: width,color: imageColor,),
        ),
      ),
    );
  }
}