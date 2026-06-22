import 'dart:ui';

import 'package:flutter/material.dart';

class ColorResource {
  static ColorResource? _instance;

  static ColorResource get instance => _instance ??= ColorResource._init();

  ColorResource._init();

  Color get transparent => const Color(0x00ffffff);

  /// Theme Color
  Color get extraLightMainColor =>  const Color(0xffEFFAFF);
  Color get lightMainColor =>  const Color(0xffF8FDFF);
  Color get lightToMainColor =>  const Color(0xffCEF1FF) ;
  Color get mainColor =>  const Color(0xFF0F9D58);
  Color get secondMainColor =>  const Color(0xFFebf1ff);
  Color get darkMainColor =>  const Color(0xff064360);
  Color get hintStyleColor =>  const Color(0xff8a9cc2);
  Color get statusMainColor =>  const Color(0xff037EDD);
  Color get backgroundMainColor => const Color(0xfffcfcff);
  Color get tabBgColor => const Color(0xffF6F6F6);


  /// Text Color
    Color get textColor => const Color(0xff222222);
  Color get textColor_2 => const Color(0xff70736F);
  Color get textColor_3 => const Color(0xff999AA0);
  Color get textColor_4 => const Color(0xffD2D2D2);
  Color get textColor_5 => const Color(0xff666666);
  Color get textColor_6 => const Color(0xff5F5F5F);
  Color get textColor_7 => const Color(0xff5D5D5D);
  Color get textColor_8 => const Color(0xffA09EAF);
  Color get textColor_9 => const Color(0xff777777);
  Color get textColor_10 => const Color(0xff1E1E1E);
  Color get textColor_11 => const Color(0xff987102);



  Color get textBlueColor => const Color(0xffC2C7FD);
  Color get textGreenColor => const Color(0xff2f4f4f);
  Color get textDarkGreenColor => const Color(0xff103303);
  Color get textDarkGreenColor2 => const Color(0xff255F38);




  Color get white => const Color(0xffffffff);
  Color get black => const Color(0xff000000);
  Color get lightBlack => const Color(0xff1F262E);
  Color get backgroundColor => const Color(0xffF8FDFF);



  Color get buttonFirstColor => const Color(0xffFC3862);
  Color get buttonSecondColor => const Color(0xff00CEC9);

  Color get brownColor => const Color(0xffC38154);
  Color get textBrownColor => const Color(0xff964B00);



  Color get borderColor => const Color(0xffaaafb5);
  Color get lightBorderColor => const Color(0xffF5F5F5);
  Color get borderProfile => const Color(0xffDDB671);

  Color get extraDarkGrey => const Color(0xff5E6A71);
  Color get darkGrey => const Color(0xff707070);
  Color get grey => const Color(0xff9CA0A6);
  Color get lightGrey => const Color(0xffC9C9C9);
  Color get extraDoubleLightGrey => const Color(0xffF9F9F9);
  Color get grey_1 => const Color(0xffF7F7F7);
  Color get grey_2 => const Color(0xffE7E7E7);
  Color get grey_3 => const Color(0xffD2D2D2);
  Color get grey_4 => const Color(0xffC4C4C4);
  Color get grey_5 => const Color(0xff757575);
  Color get grey_6 => const Color(0xffF4F5FA);
  Color get dividerGrey => const Color(0xffF0F0F0);
  Color get rootTextColor => const Color(0xffB9B9B9);



  Color get lineGreyColor => const Color(0xffF5F5F5);
  Color get lineGrey2Color => const Color(0xffE7E7E7);
  Color get boxShadow => const Color(0xffE4E4E4);


  Color get darkBlueStatus => const Color(0xff575FCF);
  Color get blueStatus => const Color(0xff4E8FD1);
  Color get extraLightBlueStatus => const Color(0xffE0F9FF);
  Color get blueLightStatus => const Color(0xffC2EDF7);
  Color get redLightStatus => const Color(0xffF9D6EB);
  Color get blueBgColor => const Color(0xffEAF2FE);
  Color get blueBgBorderColor => const Color(0xff4285f4);





  Color get star => const Color(0xfff1b90a);
  Color get selectTabColor => const Color(0xfff1b90a);
  Color get orangeColor => const Color(0xffF39C12);
  Color get cardOrangeColor => const Color(0xffE8AD00);
  Color get orangeGradientColor1 => const Color(0xffFBBC05);
  Color get orangeGradientColor2 => const Color(0xffFFE087);
  Color get orangeGradientColor3 => const Color(0xc8ffe087);
  Color get orangeTextBg => const Color(0xffD69F00);
  Color get orangeBoxBg => const Color(0xffFFF5DA);
  Color get orangeBoxBorder => const Color(0xffFFF5DA);






  Color get lightGreenColor => const Color(0xffEAFFEF);
  Color get greenColor => const Color(0xff09B838);
  Color get darkGreenColor => const Color(0xff15A10F);
  Color get payNowColor => const Color(0xff00AA7C);
  Color get greenLightColor => const Color(0xff00CEC9);
  Color get btnGreenColor => const Color(0xff00A53B);
  Color get btnGreenBorderColor => const Color(0xffE1FFBE);
  Color get gradientGreenColor => const Color(0xffE6FFDF);
  Color get bgGreen => const Color(0xff13714f);
  Color get bgLiteGreen => const Color(0xffDAFFDD);
  Color get borderLiteGreen => const Color(0xff89CE63);





  Color get btnBorderGreen => const Color(0xffA7D7A2);
  Color get toastSuccessColor => const Color(0xff1ABC9C);
  Color get cardBgGreenColor => const Color(0xffDBFFD8);



  Color get extraDarkRedColor => const Color(0xff7C0001);
  Color get darkRedColor => const Color(0xffEA2027);
  Color get redColor => const Color(0xffEA4335);
  Color get lightRed => const Color(0xffF94144);
  Color get dimLightRed => const Color(0xffFFEEEE);
  Color get btnRed => const Color(0xffE71200);
  Color get textRed => const Color(0xffEB4335);
  Color get cardBgRed => const Color(0xffFFECEA);





  Color get socialButtonGreenColor => const Color(0xffF0FFDF);




}
