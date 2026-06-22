import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/common/custome_redio_button.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_image.dart';

class GenderBoxUi extends StatelessWidget {
  const GenderBoxUi({
    super.key, this.height, this.width, required this.image, required this.title, this.inageHeight, this.value, required this.onTap,
  });
  final double? height;
  final double? width;
  final double? inageHeight;
  final String image;
  final String title;
  final bool? value;
  final VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: YRoundedContainer(
        showBorder: false,
        width: 180,
        height: height,
        padding: EdgeInsets.symmetric(vertical:DimensionResource.marginSizeLarge,horizontal: DimensionResource.marginSizeLarge),
        boxshadow: [
          BoxShadow(
            color: ColorResource.instance.lightGrey,
            offset: Offset(0, 2),
            blurRadius: 9,
          ),
        ],
        child: Column(
          children: [
            Align(alignment: Alignment.centerRight,child: CustomRadioButton(value: value ?? false, onTap:onTap,height: 15,width: 15,)),
            Gap(DimensionResource.marginSizeSmall),
            YRoundedImage(isNetworkImage:false,imageUrl: image,height: inageHeight,),
            Gap(DimensionResource.marginSizeSmall ),
            Text(title,style: StyleResource.instance.styleBold(DimensionResource.fontSizeDefault, ColorResource.instance.textColor_3),)
          ],
        ),
      ),
    );
  }
}
