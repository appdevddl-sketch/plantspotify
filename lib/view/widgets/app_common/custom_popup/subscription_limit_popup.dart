import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
import 'package:plants_spotify/view/widgets/button_view/payment_details_dialog.dart';
import 'package:plants_spotify/view/widgets/button_view/yinkwell.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';

/// A popup dialog shown when the user hits a 429 (rate limit) error.
///
/// Offers an "Upgrade Now" button that navigates to the subscription screen,
/// and a "Cancel" link that simply closes the dialog.
class SubscriptionLimitPopup extends StatelessWidget {
  final String? message;
  final VoidCallback? onDismiss;

  const SubscriptionLimitPopup({
    super.key,
    this.message,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return PopupDialog(
      child: YRoundedContainer(
        height: 420,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Top row: leaf decoration + close button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(ImageResource.instance.leaf4Image, width: 100),
                InkWell(
                  onTap: () {
                    Get.back();
                    onDismiss?.call();
                  },
                  child: Image.asset(
                    ImageResource.instance.closeOutlinedIcon,
                    height: 18,
                  ).paddingOnly(top: 10, right: 10),
                ),
              ],
            ),

            // Icon
            Image.asset(ImageResource.instance.errorIcon, height: 80),

            // Content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(DimensionResource.marginSizeDefault),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "limit_reached".tr,
                          style: StyleResource.instance.styleBold(
                            DimensionResource.fontSizeDefault,
                            ColorResource.instance.black,
                          ),
                          textAlign: TextAlign.center,
                        ).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
                        Text(
                          message ?? "usage_limit_message".tr,
                          style: StyleResource.instance.styleRegular(
                            DimensionResource.fontSizeSmall - 1,
                            ColorResource.instance.textColor_9,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        CommonButton(
                          text: "upgrade_now".tr,
                          loading: false,
                          onPressed: () {
                            Get.back();
                            Get.toNamed(Routes.subscriptionScreen);
                          },
                          height: 40,
                          color: ColorResource.instance.btnGreenColor,
                          textSize: DimensionResource.fontSizeSmall,
                        ).paddingOnly(bottom: DimensionResource.marginSizeSmall),
                        YInkwell(
                          onTap: () {
                            Get.back();
                            if(Get.currentRoute != Routes.rootView){
                              Get.offAllNamed(Routes.rootView);
                            }
                            onDismiss?.call();
                          },
                          child: Text(
                            (Get.currentRoute != Routes.rootView) ? "explore_more_plants".tr : "cancel".tr,
                            style: StyleResource.instance.styleRegular(
                              DimensionResource.fontSizeSmall,
                              ColorResource.instance.textColor_9,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
