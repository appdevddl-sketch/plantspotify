import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/input_formatters_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/button_holders.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
import 'package:plants_spotify/view/widgets/button_view/payment_details_dialog.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/text_field_view/common_textfield.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';

import '../../../../model/utils/color_resource.dart';

class LoaderPopup extends StatelessWidget {
  final dynamic controller;


  const LoaderPopup({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: PopupDialog(
        child: YRoundedContainer(
          padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                SizedBox(),
                SizedBox(),
                // InkWell(onTap: Get.back,child: Image.asset(ImageResource.instance.closeOutlinedIcon,height: 18,).paddingOnly(top: 10,right: 10))
                ],
              ),
              Image.asset(ImageResource.instance.leafLoaderGif,height: 150,),
              Text("fetching_the_details".tr,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeDefault, ColorResource.instance.textColor_9),textAlign: TextAlign.center,)
            ],

          ),

        )
      ),
    );
  }
}
