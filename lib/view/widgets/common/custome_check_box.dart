

import 'package:flutter/material.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';
import '../../../model/utils/color_resource.dart';
import '../../../model/utils/image_resource.dart';


class CustomCheckBox extends StatelessWidget {
  final VoidCallback onTap;
  final bool value;
  final double ?height;
  final double ?width;
  const CustomCheckBox({Key? key,required this.value, required this.onTap,this.height,this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: height,
          width: width,
          padding:const EdgeInsets.all(4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color:!value? ColorResource.instance.white:ColorResource.instance.mainColor,
              gradient: value? DecorationResource.instance.decorationBoxGradient():null,
              border: Border.all(color:!value? ColorResource.instance.lightGrey:ColorResource.instance.mainColor,width: 2)
          ),
          child:Image.asset(ImageResource.instance.checkIcon,height: 18,color:ColorResource.instance.white,)
      ),
    );
  }
}



