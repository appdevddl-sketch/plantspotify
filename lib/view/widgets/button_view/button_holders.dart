import 'package:flutter/material.dart';

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/style_resource.dart';



class ButtonResource{
  static ButtonResource ?_instance;
  static ButtonResource get instance => _instance ??=ButtonResource._init();
  ButtonResource._init();

  Widget smallBottomButton({double ?borderRadius,Color ?borderColor,required Color backGroundColor, String ?title, Color ?titleColor, Widget? suffixIcon, Widget? prefixIcon, VoidCallback ?onTap}){
    return GestureDetector(
      onTap: onTap ?? (){},
      child: Container(
        padding:const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeSmall,vertical: DimensionResource.marginSizeExtraSmall),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(borderRadius??8),color: backGroundColor,border: Border.all(color: borderColor??backGroundColor,width: 1.5)),
        child: Row(
          children: [
            Visibility(visible:prefixIcon!=null?true:false ,child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: prefixIcon ??const SizedBox(),
            )),
            Text(title ?? "",style: StyleResource.instance.styleMedium(DimensionResource.fontSizeDefault, titleColor ?? ColorResource.instance.white),),
            Visibility(visible:suffixIcon!=null?true:false ,child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: suffixIcon ??const SizedBox(),
            ))
          ],
        ),
      ),
    );
  }

  Widget buildIconButton({required String image,required VoidCallback onTap, AlignmentGeometry? alignmentGeometry,double ?height,Color ?color}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: height??40,
        width: height??40,
        child: Align(
            alignment: alignmentGeometry ?? Alignment.center,
            child: Image.asset(
              image,
              height: (height??40)/1.5,
              color: color,
            )),
      ),
    );
  }

  Widget borderIconButton({required Color borerColor ,required Color backGroundColor,required IconData icon,required Color iconColor,required VoidCallback onTap}){
    return InkWell(
      onTap: onTap,
      child: Container(
        padding:const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borerColor),
          color: backGroundColor,
        ),
        child: Icon(icon,color: iconColor,size: 18,),
      ),
    );
  }

  Widget borderImageButton({ required Color borerColor ,required Color backGroundColor,required String image,required Color imageColor,required VoidCallback onTap, double ?borderRadius, double ?imageHeight, double ?imagePadding}){
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(imagePadding??5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius??4),
          border: Border.all(color: borerColor),
          color: backGroundColor,
        ),
        child: Image.asset(image,color: imageColor,height: imageHeight??15,),
      ),
    );
  }
  Widget buildPasswordButton({required bool value,required VoidCallback onChange}){
    return InkWell(
      onTap:onChange,
      child: Container(
        margin: const EdgeInsets.only(right: DimensionResource.marginSizeDefault, left: DimensionResource.marginSizeDefault),
        height: 18,
        width: 18,
        child: Icon(
          value ? Icons.visibility_off:Icons.visibility,
          color: ColorResource.instance.black,
          size: 20,
        ),
      ),
    );
  }
}
