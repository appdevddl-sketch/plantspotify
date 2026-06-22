import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
import 'package:plants_spotify/view/widgets/button_view/payment_details_dialog.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';

/// A popup dialog to show subscription cancellation result.
///
/// [isError] — `false` (default) shows success state, `true` shows error state.
/// [onDismiss] — called when the user taps the button or close icon.
/// [message] — optional custom message to display.
class SubscriptionCancelledPopup extends StatelessWidget {
  final bool isError;
  final VoidCallback onDismiss;
  final String? message;

  const SubscriptionCancelledPopup({
    super.key,
    this.isError = false,
    required this.onDismiss,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return PopupDialog(
      child: YRoundedContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                    onDismiss();
                  },
                  child: Image.asset(
                    ImageResource.instance.closeOutlinedIcon,
                    height: 18,
                  ).paddingOnly(top: 10, right: 10),
                ),
              ],
            ),

            // Icon
            isError
                ? Image.asset(ImageResource.instance.errorIcon, height: 80)
                : Image.asset(ImageResource.instance.successfullyImage, height: 200),

            // Content
            Container(
              padding: const EdgeInsets.all(DimensionResource.marginSizeDefault),
              child: Column(
                children: [
                  // Title
                  Text(
                    isError ? "cancellation_failed".tr : "subscription_cancelled".tr,
                    style: StyleResource.instance.styleBold(
                      DimensionResource.fontSizeDefault,
                      ColorResource.instance.black,
                    ),
                    textAlign: TextAlign.center,
                  ).paddingOnly(bottom: DimensionResource.paddingSizeSmall),

                  // Message
                  Text(
                    message ??
                        (isError
                            ? "subscription_cancel_error_message".tr
                            : "subscription_cancel_success_message".tr),
                    style: StyleResource.instance.styleRegular(
                      DimensionResource.fontSizeSmall - 1,
                      ColorResource.instance.textColor_9,
                    ),
                    textAlign: TextAlign.center,
                  ).paddingOnly(bottom: DimensionResource.marginSizeDefault * 2),

                  // Button
                  CommonButton(
                    text: isError ? "Ok".tr : "done".tr,
                    loading: false,
                    onPressed: () {
                      Get.back();
                      onDismiss();
                    },
                    height: 40,
                    color: isError
                        ? ColorResource.instance.btnRed
                        : ColorResource.instance.btnGreenColor,
                    textSize: DimensionResource.fontSizeSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
