

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/screens/root_view/force_update_screen.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view_model/controller/auth_controllers/social_signIn_controller.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';

import '../../base_view/base_view_screen.dart';


class SocialSigninScreen extends StatelessWidget {
  const SocialSigninScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(viewControl: SocialSignInController(),
        onPageBuilder: (BuildContext context,SocialSignInController controller)=>
        Obx(() => !controller.isValidVersion.value
            ? const ForceUpdateScreen()
            : _buildLoginView(context, controller)));
  }
}

Widget _buildLoginView(BuildContext context,SocialSignInController controller){
  return Stack(
    children: [
      Positioned(
        bottom: 0,
          left: 0,
          child: Image.asset(ImageResource.instance.leafTransparent,height: 300,width: HelperFunction.screenWidth() * .70,)
      ),
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(DimensionResource.paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      Gap(70),
                      RoundedScanBorder(
                        cornerRadius: 20,
                        cornerLength:90,
                        strokeWidth: 2,
                        color: ColorResource.instance.btnGreenColor,
                        child: Column(
                          children: [
                            Gap(85),
                            Image.asset(
                              ImageResource.instance.plantImage,
                              width: 350,
                              height: 350,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(top:0,child: Image.asset(ImageResource.instance.appLogoImage,height: 200,width: 200,).paddingOnly(bottom: DimensionResource.paddingSizeDefault)),

                ],
              ).paddingOnly(bottom: DimensionResource.marginSizeDefault * 3 ,top: DimensionResource.marginSizeDefault * 3),

              if(Platform.isIOS)
              _buildSocialBtn(ImageResource.instance.appleIcon,"sign_in_apple".tr,()=>controller.apple()).paddingOnly(bottom: DimensionResource.paddingSizeDefault),
              _buildSocialBtn(ImageResource.instance.googleIcon,"sign_in_google".tr,()=>controller.google()).paddingOnly(bottom: DimensionResource.paddingSizeDefault),


            ],
          ),
        ),
      ),
    ],
  );
}

YRoundedContainer _buildSocialBtn(String image, String text, VoidCallback? onTap) {
  return YRoundedContainer(
      radius: 25,
      onTap: onTap,
      showBorder: true,
      borderColor: ColorResource.instance.socialButtonGreenColor,
      backgroundColor: ColorResource.instance.socialButtonGreenColor,
      padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image,height: 18,),
          Gap(DimensionResource.paddingSizeSmall),
          Text(text,style: StyleResource.instance.styleMedium(DimensionResource.fontSizeDefault, ColorResource.instance.black),),
        ],
      ),
    );
}

class RoundedScanBorder extends StatelessWidget {
  final Widget child;
  final double cornerRadius;
  final double cornerLength;
  final double strokeWidth;
  final Color color;

  const RoundedScanBorder({
    super.key,
    required this.child,
    this.cornerRadius = 22,
    this.cornerLength = 60,
    this.strokeWidth = 3,
    this.color = const Color(0xff00A53B),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child, // full width, not affected
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _RoundedCornerPainter(
                radius: cornerRadius,
                cornerLength: cornerLength,
                strokeWidth: strokeWidth,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class _RoundedCornerPainter extends CustomPainter {
  final double radius;
  final double cornerLength;
  final double strokeWidth;
  final Color color;

  _RoundedCornerPainter({
    required this.radius,
    required this.cornerLength,
    required this.strokeWidth,
    required this.color,
  });

  void _drawTopLeftCorner(Canvas canvas, Size size, Paint paint) {
    // draws an outward rounded corner at origin (0,0) extending right and down
    final Path p = Path()
      ..moveTo(0, radius)
      ..arcToPoint(Offset(radius, 0), radius: Radius.circular(radius))
      ..lineTo(cornerLength, 0); // top horizontal short line
    canvas.drawPath(p, paint);

    // left vertical short line
    canvas.drawLine(Offset(0, radius), Offset(0, cornerLength), paint);

    // small top horizontal piece from (0) already drawn by arcTo+lineTo,
    // but keep symmetry consistent if needed: draw horizontal from (radius..cornerLength) would overlap arc.
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Top-left at (0,0)
    _drawTopLeftCorner(canvas, size, paint);

    // Top-right: mirror horizontally around right edge
    canvas.save();
    canvas.translate(size.width, 0);
    canvas.scale(-1, 1);
    _drawTopLeftCorner(canvas, size, paint);
    canvas.restore();

    // Bottom-left: mirror vertically around bottom edge
    canvas.save();
    canvas.translate(0, size.height);
    canvas.scale(1, -1);
    _drawTopLeftCorner(canvas, size, paint);
    canvas.restore();

    // Bottom-right: mirror both axes
    canvas.save();
    canvas.translate(size.width, size.height);
    canvas.scale(-1, -1);
    _drawTopLeftCorner(canvas, size, paint);
    canvas.restore();

    // draw small horizontal segments that sit flush with the corner arcs
    // (optional) draw top horizontal pieces (left + right)
    canvas.drawLine(Offset(radius, 0), Offset(cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width - cornerLength, 0),
        Offset(size.width - radius, 0), paint);

    // bottom horizontal pieces
    canvas.drawLine(Offset(radius, size.height),
        Offset(cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width - cornerLength, size.height),
        Offset(size.width - radius, size.height), paint);

    // left vertical pieces
    canvas.drawLine(Offset(0, radius), Offset(0, cornerLength), paint);
    canvas.drawLine(Offset(0, size.height - cornerLength),
        Offset(0, size.height - radius), paint);

    // right vertical pieces
    canvas.drawLine(Offset(size.width, radius),
        Offset(size.width, cornerLength), paint);
    canvas.drawLine(Offset(size.width, size.height - cornerLength),
        Offset(size.width, size.height - radius), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}






