
import 'package:flutter/material.dart';


import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/style_resource.dart';

Widget textBottomWithUnderLine(String text ,VoidCallback onPressed,) {
  return GestureDetector(
      onTap: onPressed,
      child: Text(text, style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeLarge, ColorResource.instance.mainColor).copyWith( decoration: TextDecoration.underline,),));
}
Widget textBottomWithoutUnderLine(String text ,VoidCallback onPressed,) {
  return GestureDetector(
      onTap: onPressed,
      child: Text(text, style:StyleResource.instance.styleRegular(DimensionResource.fontSizeDefault, ColorResource.instance.mainColor)));
}