import 'package:flutter/material.dart';
import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/style_resource.dart';

class CheckBoxTitleView extends StatelessWidget {
  final bool value;
  final String chapterName;
  final int no;
  final VoidCallback onTap;
  final bool isChecked;
  const CheckBoxTitleView({super.key, required this.value, required this.chapterName, required this.onTap, required this.no, required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeSmall, vertical: DimensionResource.marginSizeDefault),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(
            color: ColorResource.instance.borderColor,
            width: 1.5
        )),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("$no",style: StyleResource.instance.styleRegular(DimensionResource.fontSizeDefault, ColorResource.instance.black),),
            const SizedBox(width: DimensionResource.marginSizeSmall,),
            Expanded(child: Text(
              chapterName,
              softWrap: true,
              style: StyleResource.instance.styleSemiBold(
                  DimensionResource.fontSizeExtraLarge,
                  ColorResource.instance.textColor),
            )),
            const SizedBox(
              width: DimensionResource.marginSizeDefault,
            ),
            const SizedBox(width: DimensionResource.marginSizeExtraSmall,),
            isChecked ? Container(margin: const EdgeInsets.only(right: 10),height: 50,width: 50,child: Center(child: CircularProgressIndicator(color: ColorResource.instance.mainColor,),)) : Checkbox(value: value,checkColor: ColorResource.instance.white,activeColor: ColorResource.instance.mainColor, onChanged: (bool? value)=>onTap(),),
          ],
        ),
      ),
    );
  }
}
