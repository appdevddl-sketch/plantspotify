import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppbarPerimeter appbarPerimeter;

  const CustomAppBar({super.key, required this.appbarPerimeter});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: appbarPerimeter.elevation ?? 0,
      backgroundColor: appbarPerimeter.appBarBackGroundColor ?? ColorResource.instance.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 15, right: 15),
        decoration: BoxDecoration(
          color: appbarPerimeter.appBarBackGroundColor ?? ColorResource.instance.transparent,
          border: Border(bottom: BorderSide(color: ColorResource.instance.lightMainColor)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Button
            if (appbarPerimeter.backButtonShow)
              InkWell(
                onTap: appbarPerimeter.onTapBackButton ?? () => Get.back(),
                child: Image.asset(
                  ImageResource.instance.backArrowIcon,
                  height: 18,
                  color: appbarPerimeter.backButtonColor,
                ),
              )
            else
              const SizedBox(width: 38), // Placeholder to maintain spacing

            // Title
            Expanded(
              child: Center(
                child: Text(
                  appbarPerimeter.title,
                  style: StyleResource.instance.styleSemiBold(
                    18, // Customizable font size
                    appbarPerimeter.titleColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Action Buttons
            if (appbarPerimeter.actionButton.isNotEmpty)
              Row(children: appbarPerimeter.actionButton)
            else
              const SizedBox(width: 38), // Placeholder for alignment
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0); // Standard app bar height
}
