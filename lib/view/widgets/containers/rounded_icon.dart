
import 'package:flutter/material.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';

class YCircularIcon extends StatelessWidget {
  //  a custom circular icon widget with a background color

  //properties are
  //container widht, heught and background color
  //icon size color and on pressed
  const YCircularIcon({
    super.key,
    this.width,
    this.height,
    this.size =DimensionResource.lg,
    required this.icon,
    this.color,
    this.onpressed, this.backgroundColor,
  });

  final double? width,height,size;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onpressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: backgroundColor != null ? backgroundColor! :  ColorResource.instance.mainColor.withOpacity(0.9) ,
      ),
      child: IconButton(onPressed: onpressed, icon: Icon(icon,color: color,size: size)),
    );
  }
}