import 'package:flutter/material.dart';

import 'color_resource.dart';


class DecorationResource {
  static DecorationResource? _instance;

  static DecorationResource get instance => _instance ??= DecorationResource._init();

  DecorationResource._init();

  BoxDecoration decorationFilterSpinnerNoRadius() {
    return BoxDecoration(
      border: Border.all(color: const Color(0xffFFDDDD), width: 1),
    );
  }
  BoxDecoration decorationFullRoundedCorner() {
    return BoxDecoration(
        color: ColorResource.instance.mainColor,
        border: Border.all(color: ColorResource.instance.mainColor, width: 1),
        shape: BoxShape.circle);
  }
  LinearGradient decorationBoxGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        ColorResource.instance.mainColor,
        ColorResource.instance.hintStyleColor,
      ],
    );
  }
  List<BoxShadow> containerBoxShadow([Color? shadowColor]){
    return [
      BoxShadow(
      color: shadowColor??ColorResource.instance.lightGrey.withValues(alpha: .5),
      blurRadius: 50.0,
    ),];
  }

  List<BoxShadow> rootButtonBoxShadow([Color? shadowColor]){
    return  [
      BoxShadow(
        color: shadowColor??Colors.black.withValues(alpha: 0.05),
        blurRadius: 8,
        offset: const Offset(0, 3),
      ),
    ];
  }

  List<BoxShadow> bannerBoxShadow(){
    return [
      BoxShadow(
        color: ColorResource.instance.secondMainColor,
        blurRadius: 12.0,
          blurStyle : BlurStyle.solid
      ),];
  }

  List<BoxShadow> containerDarkBoxShadow(){
    return  [BoxShadow(
        color: ColorResource.instance.grey.withValues(alpha: .8),
        blurRadius: 20.0,
        blurStyle : BlurStyle.solid
    ),];
  } List<BoxShadow> containerLightBoxShadow(){
    return  [BoxShadow(
        color: ColorResource.instance.grey_3.withValues(alpha: .4),
        blurRadius: 15.0,
        blurStyle : BlurStyle.solid
    ),];
  }

}
