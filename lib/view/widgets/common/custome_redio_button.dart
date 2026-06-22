import 'package:flutter/material.dart';

import '../../../model/utils/color_resource.dart';


class CustomRadioButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool value;
  final double ?height;
  final double ?width;
  const CustomRadioButton({Key? key,required this.value,required this.onTap,this.height,this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: height ?? 18,
          width: width??18,
          padding:const EdgeInsets.all(2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color:value? ColorResource.instance.mainColor:ColorResource.instance.borderColor,width:1.5)
          ),
        child: value?Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: value? ColorResource.instance.mainColor:ColorResource.instance.white
          ),
        ):const SizedBox(),
      ),
    );
  }
}
