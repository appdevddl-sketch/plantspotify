

import 'dart:convert';
import 'dart:io';

import 'package:gap/gap.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/notification_model.dart';
import 'package:plants_spotify/view/widgets/button_view/yinkwell.dart';
import 'package:plants_spotify/view_model/notification/notifiction_redirection.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/loader_helper/loader_helper_ui.dart';
import 'package:plants_spotify/view/widgets/no_data_screen/noDataScreen.dart';
import 'package:plants_spotify/view/widgets/pagination_view/pagination_view_screen.dart';
import 'package:plants_spotify/view/widgets/shimmer_box/view_shimmers/nursery_screen_shimmer.dart';

import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/notification_screen_controller/notification_screen_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/shimmer_box/view_shimmers/noification_shimmer.dart';



class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
        viewControl:  NotificationScreenController(),
        // appbarPerimeter: AppbarPerimeter(title: "notification".tr,centerTitle: true),
        onPageBuilder: (BuildContext context, NotificationScreenController controller)=> _builMainView(context, controller));
  }
}
Widget _builMainView(BuildContext context, NotificationScreenController controller) {

return SingleChildScrollView(
  child: YRoundedContainer(
    height: HelperFunction.screenHeight(),
    width: HelperFunction.screenWidth(),
    radius: 0,
    gradient: LinearGradient(
      colors: [ColorResource.instance.gradientGreenColor,ColorResource.instance.white ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [
        0.0, 0.2
      ],
    ),
    padding: const EdgeInsets.all(DimensionResource.marginSizeDefault),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Platform.isIOS ? Gap(DimensionResource.defaultIos) : Gap(DimensionResource.defaultTop),
        _buildNotificationHeader(context,controller).paddingOnly(bottom: DimensionResource.marginSizeDefault),
        Expanded(
          child: Obx((){
            if(controller.notificationData.value.status!=false && controller.notificationPaginationViewController.itemList.isNotEmpty) {
              return PaginationView<NotificationData>(
                  onRefresh: () => controller.getNotificationList(pageNumber: 1, forPaginate: false),
                  sidePadding:const EdgeInsets.symmetric(vertical: DimensionResource.marginSizeDefault),
                  showItemList: controller.notificationPaginationViewController.itemList,
                  pagingScrollController:controller.notificationPaginationViewController,
                  mainView:(BuildContext context, int index,NotificationData itemData) => NotificationSection(
                    heading: itemData.group??"",
                    notifications: itemData.notifications??[],
                    onTap: (i) {
                      NotificationRedirection.notificationRedirectionFromPayload(
                        notificationPayload: jsonEncode(itemData.notifications?[i].toJson()),
                      );
                    },
                  ).paddingOnly(bottom: DimensionResource.marginSizeDefault),
              );
            }
            else if(controller.notificationData.value.status==true && controller.notificationPaginationViewController.itemList.isEmpty){
              return   NoDataFoundScreen(message: "no_data_found".tr,onRefresh: ()=>controller.onInit(),);
            } else {
              return NotificationScreenShimmer();
            }
          }),
        )



      ],
    ),
  ),
);
}

SizedBox _buildNotificationHeader(BuildContext context, NotificationScreenController controller) {
  return SizedBox(
        height: DimensionResource.appBarHeight,
        width: HelperFunction.screenWidth(),
        child: Row(
          children: [

            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                height: 35,
                width: 35,
                padding: const EdgeInsets.all(
                  DimensionResource.marginSizeSmall,
                ),
                decoration: BoxDecoration(
                  color: ColorResource.instance.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: DecorationResource.instance
                      .containerBoxShadow(ColorResource.instance.grey),
                ),
                child: Image.asset(
                  ImageResource.instance.backArrowIcon,
                  height: 11,
                  color: ColorResource.instance.textDarkGreenColor,
                ),
              ),
            ),

            // Center Title
            Expanded(
              child: Center(
                child: Text(
                  "notifications".tr,
                  style: StyleResource.instance.styleSemiBold(
                    DimensionResource.fontSizeLarge,
                    ColorResource.instance.textDarkGreenColor,
                  ),
                ),
              ),
            ),

            // Right spacer (balances back button)
            const SizedBox(width: 35),
          ],
        ),
      );
}

class NotificationSection extends StatelessWidget {
  final String heading;
  final List<NotificationElement> notifications;
  final Function(int index)? onTap;

  const NotificationSection({
    super.key,
    required this.heading,
    required this.notifications,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Heading
        Text(
          heading,
          style: StyleResource.instance.styleSemiBold(
            DimensionResource.fontSizeDefault,
            ColorResource.instance.textDarkGreenColor,
          ),
        ),

        Gap(DimensionResource.marginSizeSmall),

        /// Notification List
        Column(
          children: List.generate(
            notifications.length,
            (index) {
              return YInkwell(
                onTap: () => onTap?.call(index),
                child: NotificationItem(
                  text: notifications[index].message ?? "",
                  showBottomBorder: index != notifications.length - 1,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String text;
  final bool showBottomBorder;

  const NotificationItem({
    super.key,
    required this.text,
    this.showBottomBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Colors.white,
        border: showBottomBorder
            ? Border(
          bottom: BorderSide(
            color: ColorResource.instance.dividerGrey
                .withValues(alpha: 0.5),
            width: 1,
          ),
        )
            : null,
      ),
      child: Row(
        children: [
          YRoundedContainer(
            backgroundColor:
            ColorResource.instance.socialButtonGreenColor,
            radius: 30,
            height: 40,
            width: 40,
            child: Center(
              child: Image.asset(
                ImageResource.instance.notificationBellOutlinedIcon,
                height: 18,
              ),
            ),
          ),
          Gap(DimensionResource.marginSizeSmall),
          Expanded(
            child: Text(
              text,
              style: StyleResource.instance.styleRegular(
                DimensionResource.fontSizeDefault,
                ColorResource.instance.textColor_2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




