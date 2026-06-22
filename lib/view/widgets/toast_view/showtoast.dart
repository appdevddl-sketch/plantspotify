import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/style_resource.dart';
import '../common/helper.dart';

toastShow({required String message, required bool error}) {
  showFlash(
    context: Get.context!,
    duration: const Duration(seconds: 2),
    builder: (context, controller) {
      controller.controller.duration = const Duration(milliseconds: 1400);
      controller.controller.reverseDuration = const Duration(milliseconds: 1400);

      return Flash(
        controller: controller,
        position: FlashPosition.bottom,

        forwardAnimationCurve: Curves.fastEaseInToSlowEaseOut,
        reverseAnimationCurve: Curves.easeOut,
        child: SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 40,
                left: DimensionResource.marginSizeLarge,
                right: DimensionResource.marginSizeLarge,
              ),
              child: Material(
                color: Colors.transparent,
                child: YRoundedContainer(
                  boxshadow: DecorationResource.instance.containerLightBoxShadow(),
                  radius: 5,
                  width: HelperFunction.screenWidth(),
                  backgroundColor: error ? ColorResource.instance.redColor : ColorResource.instance.btnGreenColor,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(DimensionResource.marginSizeSmall),
                        child: Icon(
                          error ? Iconsax.warning_2 : Iconsax.tick_circle,
                          color: ColorResource.instance.white,
                          size: DimensionResource.iconSizeDefault,
                        ),
                      ),

                      Expanded(
                        child: YRoundedContainer(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DimensionResource.marginSizeDefault,
                            vertical: DimensionResource.marginSizeDefault,
                          ),
                          radius: 5,
                          showBorder: true,
                          borderColor: ColorResource.instance.white,
                          backgroundColor: ColorResource.instance.white,
                          child: Text(
                            message,
                            textAlign: TextAlign.start,
                            style: StyleResource.instance.styleRegular(
                              DimensionResource.fontSizeSmall,
                              ColorResource.instance.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}








