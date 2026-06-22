import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/style_resource.dart';

void showImagePicker(context,{required VoidCallback onCamaraTap,required VoidCallback onGalleryTap}) {
  showModalBottomSheet(
      context: context,
      backgroundColor: ColorResource.instance.transparent,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ColorResource.instance.white,
              ),
              child:  Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child:  ListTile(
                        leading:  Icon(
                          Icons.photo_library,
                          color: ColorResource.instance.black,
                        ),
                        title:  Text(
                          "Gallery".tr,
                          style: StyleResource.instance.styleMedium(DimensionResource.fontSizeDefault, ColorResource.instance.black),
                        ),
                        onTap:onGalleryTap),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child:  ListTile(
                      leading:  Icon(
                        Icons.photo_camera,
                        color: ColorResource.instance.black,
                      ),
                      title:  Text("Camera".tr, style: StyleResource.instance.styleMedium(DimensionResource.fontSizeDefault, ColorResource.instance.black)),
                      onTap:onCamaraTap,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
