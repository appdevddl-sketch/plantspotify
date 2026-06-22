

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/articel_list_model.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/font_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
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
import 'package:plants_spotify/view/widgets/sliders/horizontal_slider.dart';
import 'package:plants_spotify/view/widgets/text_field_view/common_textfield.dart' show CommonTextField;
import 'package:plants_spotify/view/widgets/text_field_view/lable_container.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view_model/controller/auth_controllers/profile_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/articles_controller/articles_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/home_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/plant_index_controller/plant_index_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/scan_history/scan_history_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/tending_screen/trending_screen_controller.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';

import '../../../../../model/utils/input_formatters_resource.dart';



class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen
      ({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(viewControl: ArticlesController(),
        appbarPerimeter: AppbarPerimeter(title: "articles".tr,centerTitle: true,appBarBackGroundColor: ColorResource.instance.grey_1),
        onPageBuilder: (BuildContext context,ArticlesController controller)=>_buildMainView(context,controller));
  }
}

Widget _buildMainView(BuildContext context, ArticlesController controller) {
  
  return Padding(
    padding: EdgeInsets.all(DimensionResource.marginSizeDefault),
    child: Column(
      children: [
        CommonTextField(
          controller: controller.searchController,
          hintText: "search_articles".tr,
          inputFormatters: InputFormattersResource.instance.nameInputFormatters,
          outlineBorderColor: ColorResource.instance.btnBorderGreen.withValues(alpha: .4),
          keyboardType: TextInputType.name,
          prefixIcon: Padding(
            padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
            child: Image.asset(ImageResource.instance.searchIcon),
          ),
          validator: (val) => val?.isValidNameValidation(
            onError: (error) => controller.searchError.value = error,
          ),
          errorText: controller.searchError.value,
          onValueChanged: (value){
            controller.searchArticles();
          },
        ).paddingOnly(bottom: DimensionResource.marginSizeDefault),
        Expanded(child: buildMainContent(context,controller)),
      ],
    ),
  );
  
}

Widget buildMainContent(BuildContext context , ArticlesController controller){
  return Obx(() {
    if (controller.articleListData.value.status != false &&
        controller.articleListPaginationViewController.itemList.isNotEmpty) {
      return PaginationView<ArticleListData>(
        isGrid: true,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 200,
        onRefresh: () async {
          controller.onInit();
        },
        showItemList:
        controller.articleListPaginationViewController.itemList,
        pagingScrollController:
        controller.articleListPaginationViewController,
        mainView: (context, index, item) {
          return ArticlesCard(
            onPressed: () => Get.toNamed(Routes.articlesDetailScreen, arguments: item,),
            imageUrl: item.image ?? '',
            title: item.title ?? '',
          );
        },
      );
    }

    if (controller.articleListData.value.status == false &&
        controller.articleListPaginationViewController.itemList.isEmpty) {
      return NoDataFoundScreen(message: "no_data_found".tr,onRefresh: ()=>controller.onInit(),);
    }

    return loaderHelperUi();
  });
}




