

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/search_results_model.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/font_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/app_common/app_heading/app_heading.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
import 'package:plants_spotify/view/widgets/button_view/yinkwell.dart';
import 'package:plants_spotify/view/widgets/common/dropdown_button_helper.dart' show DropdownButtonHelper;
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_image.dart';
import 'package:plants_spotify/view/widgets/layout/grid_layout.dart';
import 'package:plants_spotify/view/widgets/layout/list_view_layout.dart';
import 'package:plants_spotify/view/widgets/loader_helper/loader_helper_ui.dart';
import 'package:plants_spotify/view/widgets/no_data_screen/noDataScreen.dart';
import 'package:plants_spotify/view/widgets/pagination_view/pagination_view_screen.dart';
import 'package:plants_spotify/view/widgets/shimmer_box/view_shimmers/search_list_shimmer.dart';
import 'package:plants_spotify/view/widgets/sliders/horizontal_slider.dart';
import 'package:plants_spotify/view/widgets/text_field_view/common_textfield.dart' show CommonTextField;
import 'package:plants_spotify/view/widgets/text_field_view/lable_container.dart';
import 'package:plants_spotify/view_model/controller/auth_controllers/profile_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/home_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/tending_screen/trending_screen_controller.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';

import '../../../../../model/utils/input_formatters_resource.dart';
import '../../../../../view_model/controller/root_view_contrller/home_controller/search_screen_controller/search_screen_controller.dart';
import '../../../../widgets/text_field_view/regex/regex.dart';
import '../../../base_view/base_view_screen.dart';


class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(viewControl: SearchScreenController(),
        showNetworkStatusBar: Get.currentRoute != Routes.rootView ? true : false,
        onPageBuilder: (BuildContext context,SearchScreenController controller)=>_buildMainView(context,controller));
  }
}

Widget _buildMainView(BuildContext context,SearchScreenController controller){

  return Padding(
    padding: EdgeInsets.only(left:DimensionResource.marginSizeDefault,right:DimensionResource.marginSizeDefault,top:DimensionResource.marginSizeDefault),
    child: Column(
      children: [
        Platform.isIOS ? Gap(DimensionResource.defaultIos) : Gap(DimensionResource.defaultTop),
        Row(
          children: [
            (Get.currentRoute != Routes.rootView) ? YInkwell(onTap: Get.back,child: Image.asset(ImageResource.instance.backArrowIcon,height: 18,)):SizedBox.shrink(),
            Gap(DimensionResource.marginSizeSmall),
            Expanded(
              child: CommonTextField(
                outlineBorderColor: ColorResource.instance.btnBorderGreen.withValues(alpha: .4),
                controller: controller.searchController,
                hintText: "search_here".tr,
                onFieldSubmitted: (value)=>controller.searchPlants(),
                onValueChanged: (value){value.isEmpty ? controller.searchPlants() : null;},
                inputFormatters: InputFormattersResource.instance.nameInputFormatters,
                keyboardType: TextInputType.name,
                prefixIcon:  Padding(padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),child: Image.asset(ImageResource.instance.searchIcon)),
                validator: (val)=>val?.isValidNameValidation(onError:(error)=>controller.searchError.value =error),
                errorText: controller.searchError.value,
              ),
            ),
            Gap(DimensionResource.marginSizeSmall),
            YRoundedContainer(
              onTap: (){
                FocusScope.of(context).unfocus();
                controller.searchPlants();
              },
              backgroundColor: ColorResource.instance.btnGreenColor,

              padding: EdgeInsets.all(DimensionResource.paddingSizeSmall),
              radius: 5,
              child: Center(child: Text("search".tr,style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeSmall, ColorResource.instance.white),)),
            )
          ],
        ).paddingOnly(bottom: DimensionResource.marginSizeDefault),
        Expanded(child: _buildScreen(context,controller)),
      ],
    ),
  );




  return Padding(
    padding: EdgeInsets.all(DimensionResource.marginSizeDefault),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Platform.isIOS ? Gap(DimensionResource.defaultIos) : Gap(DimensionResource.defaultTop),
          Row(
            children: [
              (Get.currentRoute != Routes.rootView) ? YInkwell(onTap: Get.back,child: Image.asset(ImageResource.instance.backArrowIcon,height: 18,)):SizedBox.shrink(),
              Gap(DimensionResource.marginSizeSmall),
              Expanded(
                child: CommonTextField(
                  outlineBorderColor: ColorResource.instance.btnBorderGreen.withValues(alpha: .4),
                  controller: controller.searchController,
                  hintText: "search_here".tr,
                  onValueChanged: (value)=>controller.searchPlants(),
                  inputFormatters: InputFormattersResource.instance.nameInputFormatters,
                  keyboardType: TextInputType.name,
                  prefixIcon:  Padding(padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),child: Image.asset(ImageResource.instance.searchIcon)),
                  validator: (val)=>val?.isValidNameValidation(onError:(error)=>controller.searchError.value =error),
                  errorText: controller.searchError.value,
                ),
              ),
            ],
          ).paddingOnly(bottom: DimensionResource.marginSizeDefault),


          Text("Search results for “${controller.searchController.text}",style: StyleResource.instance.styleBold(DimensionResource.fontSizeLarge, ColorResource.instance.black),).paddingOnly(bottom: DimensionResource.marginSizeDefault),
          YGridLayout(itemCount: 8, itemBuilder: (context,index){
            return SearchPlantCard(
              title: "Tulsi",
              subtitle: "Keep your plants alive watering",
              image: ImageResource.instance.plantImage,
              typeIcon: ImageResource.instance.homeDrop,
              typeText: "indoor",
              onTap: () => Get.toNamed(Routes.plantsDetailScreen),
            );
          }, crossAxisSpacing: 10, mainAxisSpacing: 10,mainAxisExtent: 280,)

        ],
      ),
    ),
  );

}

Widget _buildScreen(BuildContext context,SearchScreenController controller){

  return Obx(() {
    if (controller.searchPlantData.value.status != false && controller.searchPlantPaginationViewController.itemList.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Search results for “${controller.searchController.text}”",style: StyleResource.instance.styleBold(DimensionResource.fontSizeLarge, ColorResource.instance.black),).paddingOnly(bottom: DimensionResource.marginSizeDefault),
          Expanded(
            child: PaginationView<SearchPlantData>(
              isGrid: true,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 280,
              onRefresh: () async {
                // controller.getArticles(isRefresh: true);
              },
              showItemList:
              controller.searchPlantPaginationViewController.itemList,
              pagingScrollController:
              controller.searchPlantPaginationViewController,
              mainView: (context, index, item) {
                return SearchPlantCard(
                  title: item.commonName??"",
                  subtitle: item.description??"",
                  image: item.image??"",
                  typeIcon: ImageResource.instance.homeDrop,
                  typeText: "indoor".tr,
                  onTap: () => Get.toNamed(Routes.plantsDetailScreen,arguments: {"id":item.id,"type":1}),
                );
              },
            ),
          ),
        ],
      );
    }
    else if (controller.searchPlantData.value.status == true && controller.searchPlantPaginationViewController.itemList.isEmpty) {
      return NoDataFoundScreen(message: "no_data_found".tr);
    }else if (controller.searchController.text.isEmpty) {
      return NoDataFoundScreen(message: "search_to_get_plants".tr);
    }else {
      return PlantGridShimmer();
    }
  });
}

Widget _buildNotificationBox(HomeController controller){
  return Obx(()=>Stack(
    children: [
      Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ColorResource.instance.borderColor,
            boxShadow: DecorationResource.instance.containerBoxShadow()
        ),
        child:buildIconButton(image: ImageResource.instance.bellIcon, onTap: (){},height: 35),
      ),
      if(controller.notificationCount.value!=0)
        Positioned(top: 8,
          right: 6,
          child: Container(
            height: 13,
            width: 13,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
              border: Border.all(color: ColorResource.instance.borderColor),
              color: ColorResource.instance.mainColor,
            ),
            child: Center(
              child: Text(
                  controller.notificationCount.value.toString(),
                  style: StyleResource.instance.styleSemiBold(7, ColorResource.instance.white)
              ),
            ),
          ),
        ),
      InkWell(
        onTap: (){
          // Get.toNamed(Routes.notificationScreen);
        },
        child:const  SizedBox(
          height: 40,
          width: 40,
        ),
      )
    ],
  ));
}


Widget buildIconButton({required String image,required VoidCallback onTap, AlignmentGeometry? alignmentGeometry,double ?height}) {
  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
      height: height??40,
      width: height??40,
      child: Align(
          alignment: alignmentGeometry ?? Alignment.center,
          child: Image.asset(
            image,
            height: (height??40)/1.5,
          )),
    ),
  );
}




class SearchPlantCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final String typeIcon;
  final String typeText;
  final VoidCallback? onTap;
  final double width;

  const SearchPlantCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.typeIcon,
    required this.typeText,
    this.onTap,
    this.width =  200,
  });

  @override
  Widget build(BuildContext context) {
    return YRoundedContainer(
      onTap: onTap,
      padding: EdgeInsets.all(DimensionResource.marginSizeSmall),
      backgroundColor: ColorResource.instance.white,
      radius: 5,
      width: width,
      showBorder: true,
      borderColor:
      ColorResource.instance.btnBorderGreen.withValues(alpha: .4),
      boxshadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          YRoundedImage(
            imageUrl: image,
            isNetworkImage: image.startsWith('http'),
            borderRadius: 0,
            fit: BoxFit.cover,
            height: 150,
            width: width,
            backgroundColor:
            ColorResource.instance.cardBgGreenColor.withValues(alpha: 0.40),
            padding:
            EdgeInsets.all(DimensionResource.paddingSizeDefault),
          ).paddingOnly(
              bottom: DimensionResource.marginSizeSmall),

          /// TYPE ROW
          // Row(
          //   children: [
          //     Image.asset(typeIcon, height: 18),
          //     Gap(DimensionResource.marginSizeSmall),
          //     Text(
          //       typeText.tr,
          //       style: StyleResource.instance.styleRegular(
          //         DimensionResource.fontSizeSmall,
          //         ColorResource.instance.mainColor,
          //       ),
          //     ),
          //   ],
          // ).paddingOnly(
          //     bottom: DimensionResource.marginSizeSmall / 2),

          /// TITLE
          Text(
            title,
            style: StyleResource.instance.styleSemiBold(
              DimensionResource.fontSizeDefault,
              ColorResource.instance.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ).paddingOnly(
              bottom:
              DimensionResource.marginSizeExtraSmall / 2),

          /// SUBTITLE
          Text(
            subtitle,
            style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmallTo, ColorResource.instance.textColor_2,),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

