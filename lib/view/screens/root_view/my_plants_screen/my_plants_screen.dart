

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/scan_history_screen/scan_history_screen.dart';
import 'package:plants_spotify/view/screens/root_view/my_nursery_view/my_nursery_screen.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/my_plants_controller/my_plants_controller.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';




class MyPlantsScreen extends StatelessWidget {
  const MyPlantsScreen
      ({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(viewControl: MyPlantsController(),
        appbarPerimeter: AppbarPerimeter(title: "my_plants".tr,centerTitle: true,backButtonShow: (Get.currentRoute ==Routes.rootView) ? false : true,appBarBackGroundColor: ColorResource.instance.grey_1),
        onPageBuilder: (BuildContext context,MyPlantsController controller)=>_buildMainView(context,controller));
  }
}

Widget _buildMainView(BuildContext context,MyPlantsController controller){
  return Column(
    children: [
      const SizedBox(height: DimensionResource.marginSizeDefault,),
      Container(
        // margin: const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeDefault),
        padding: const EdgeInsets.all(DimensionResource.paddingSizeSmall),
        decoration: BoxDecoration(
            color: ColorResource.instance.tabBgColor,
            borderRadius: BorderRadius.circular(50),
        ),
        child: Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(controller.tabsCategory.length, (index) => Expanded(
            child: GestureDetector(
              onTap: () => controller.onChangeButtonTapped(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.symmetric(
                    horizontal: DimensionResource.marginSizeLarge,
                    vertical: DimensionResource.marginSizeExtraSmall+2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: controller.selectCategory.value == controller.tabsCategory[index] ? ColorResource.instance.btnGreenColor : ColorResource.instance.white),
                child: Text(
                  controller.tabsCategory[index].tr,
                  style: StyleResource.instance.styleMedium(DimensionResource.fontSizeDefault, controller.selectCategory.value == controller.tabsCategory[index] ? ColorResource.instance.white : ColorResource.instance.textColor_2),
                ),
              ),
            ),
          )),
          ),
        ),
      ),
      Expanded(
        child: TabBarView(
        controller: controller.pageController,
        children: [
         MyNurseryScreen(),
         ScanHistoryScreen()
        ],
      ))
    ],
  );

}








