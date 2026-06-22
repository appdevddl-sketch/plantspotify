import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/common/custome_redio_button.dart';

class ValidationTile extends StatelessWidget {
  const ValidationTile({
    super.key,this.value = false, this.onTap,required this.title,
  });
  final bool value;
  final VoidCallback? onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomRadioButton(value: value, onTap: onTap ?? (){},height: 15,width: 15,),
        Gap(DimensionResource.marginSizeSmall),
        Text(title ?? "",style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeSmall,ColorResource.instance.textColor_3),textAlign: TextAlign.start,),
      ],
    );
  }
}