import 'package:flutter/cupertino.dart';

import '../../../model/utils/color_resource.dart';
class CustomSwitchButton extends StatelessWidget {
  final Function(bool) onChange;
  final bool value;
  const CustomSwitchButton({Key? key,required this.value,required this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.9,
      child: CupertinoSwitch(
        activeColor: ColorResource.instance.greenColor,
        onChanged: onChange,
        value: value,
        thumbColor: ColorResource.instance.white,
        trackColor: ColorResource.instance.lightGrey,
      ),
    );
  }
}
