

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
import 'package:plants_spotify/view/screens/root_view/home_view/home_view_screen.dart';
import 'package:plants_spotify/view/widgets/app_common/app_heading/app_heading.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
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
import '../../../../widgets/text_field_view/regex/regex.dart';
import '../../../base_view/base_view_screen.dart';


class TrendingScreen extends StatelessWidget {
  const TrendingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(viewControl: TrendingScreenController(),
        appbarPerimeter: AppbarPerimeter(title: "trending".tr,titleColor: ColorResource.instance.black,centerTitle: true),
        onPageBuilder: (BuildContext context,TrendingScreenController controller)=>_buildMainView(context,controller));
  }
}

Widget _buildMainView(BuildContext context,TrendingScreenController controller){

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: DimensionResource.paddingSizeDefault),
    child: Obx(() {
      if (controller.trendingPlantData.value.status != false && controller.trendingPlantPaginationViewController.itemList.isNotEmpty) {
        return PaginationView<SearchPlantData>(
          isGrid: true,
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          mainAxisExtent: 240,
          sidePadding: EdgeInsets.zero,
          onRefresh: () async {controller.onInit();},
          showItemList:
          controller.trendingPlantPaginationViewController.itemList,
          pagingScrollController:
          controller.trendingPlantPaginationViewController,
          mainView: (context, index, item) {
             return TrendingPlantCard(
              title: item.commonName ?? "N/A",
              subtitle: item.scientificName ?? "N/A",
              image: item.image ?? "N/A",
              onTap: () => Get.toNamed(Routes.plantsDetailScreen,arguments: {"id":item.id,"type":1}),
            );
          },
        );
      }

      if (controller.trendingPlantData.value.status == true && controller.trendingPlantPaginationViewController.itemList.isEmpty) {
        return NoDataFoundScreen(message: "no_data_found".tr,onRefresh: ()=>controller.onInit(),);
      }
      return PlantGridShimmer();
    }),
  );



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





