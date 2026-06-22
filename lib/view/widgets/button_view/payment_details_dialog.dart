

import 'package:flutter/material.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
class PopupDialog extends StatelessWidget {
  const PopupDialog({
    super.key, required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorResource.instance.white,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
          decoration: BoxDecoration(
            color: ColorResource.instance.white,
            borderRadius: BorderRadius.circular(15),
          ),
          width: double.infinity,
          child: child
      ),
    );
  }
}