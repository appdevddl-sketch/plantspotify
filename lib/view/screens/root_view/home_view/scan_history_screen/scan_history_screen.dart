

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/model/root_view_models/accountview_models/scan_history_list_model.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/font_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
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
import 'package:plants_spotify/view/widgets/shimmer_box/view_shimmers/scan_history_shimmer.dart';
import 'package:plants_spotify/view/widgets/sliders/horizontal_slider.dart';
import 'package:plants_spotify/view/widgets/text_field_view/common_textfield.dart' show CommonTextField;
import 'package:plants_spotify/view/widgets/text_field_view/lable_container.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view_model/controller/auth_controllers/profile_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/home_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/plant_index_controller/plant_index_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/scan_history/scan_history_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/tending_screen/trending_screen_controller.dart';

import '../../../../../model/utils/input_formatters_resource.dart';



class ScanHistoryScreen extends StatelessWidget {
  const ScanHistoryScreen
      ({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(viewControl: ScanHistoryController(),
        backgroundColor: ColorResource.instance.grey_1,
        appbarPerimeter: AppbarPerimeter(title: "scan_history".tr,centerTitle: true,appBarBackGroundColor: ColorResource.instance.grey_1),
        onPageBuilder: (BuildContext context,ScanHistoryController controller)=>_buildMainView(context,controller));
  }
}

Widget _buildMainView(BuildContext context,ScanHistoryController controller){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeDefault,vertical: DimensionResource.marginSizeLarge),
        color: ColorResource.instance.white,
        child: CommonTextField(
          controller: controller.searchController,
          outlineBorderColor: ColorResource.instance.btnBorderGreen.withValues(alpha: .4),
          hintText: "search_plants_by_name".tr,
          inputFormatters: InputFormattersResource.instance.nameInputFormatters,
          keyboardType: TextInputType.name,
          onValueChanged: (value)=>controller.searchScanHistory(),
          prefixIcon:  Padding(padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),child: Image.asset(ImageResource.instance.searchIcon)),
          validator: (val)=>val?.isValidNameValidation(onError:(error)=>controller.searchError.value =error),
          errorText: controller.searchError.value,
        ),
      ),
      Expanded(child: _buildView(context,controller))
    ],
  );

}

Widget _buildView(BuildContext context , ScanHistoryController controller) {
  return Obx((){
    if(controller.scanHistoryData.value.status!=false && controller.scanHistoryPaginationViewController.itemList.isNotEmpty) {
      return PaginationView<ScanLisData>(
          onRefresh: (){
            controller.scanHistoryData = SingleResponse<ScanHistoryListModel>(data: ScanHistoryListModel()).obs;
            controller.scanHistoryPaginationViewController.itemList.clear();
            controller.onInit();
          },
          sidePadding:const EdgeInsets.symmetric(vertical: DimensionResource.marginSizeDefault,horizontal: DimensionResource.marginSizeDefault),
          showItemList: controller.scanHistoryPaginationViewController.itemList,
          pagingScrollController:controller.scanHistoryPaginationViewController,
          mainView:(BuildContext context, int index,ScanLisData itemData) =>
              ScanHistoryCard(
            titleKey: itemData.plantDetails?.commonName??"",
            botanicalName: itemData.plantDetails?.scientificName??"",
            imageUrl: itemData.image??"",
            onTap: ()=> controller.getScanHistoryDetail(scanListData: itemData) ,
            onMoveTap: (){},
            typeKey:  itemData.scanType?.tr??"",
          ).paddingOnly(bottom: DimensionResource.marginSizeDefault)
      );
    }
    else if(controller.scanHistoryData.value.status==true && controller.scanHistoryPaginationViewController.itemList.isEmpty){
      return   NoDataFoundScreen(message: "no_data_found".tr,onRefresh: ()=>controller.onInit(),);
    }
    else {
      return ScanHistoryShimmer();
    }
  });
  return YRoundedContainer(
        padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
        radius: 0,
        backgroundColor: ColorResource.instance.grey_1,
        child: YRoundedContainer(
          radius: 5,
          padding: EdgeInsets.all(DimensionResource.marginSizeSmall),
          child: Row(
            children: [
              YRoundedImage(
                imageUrl: "https://m.media-amazon.com/images/I/71FfPN-zUGL.jpg",
                width: 85,
              ),
              Gap(DimensionResource.marginSizeDefault),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("snack".tr,style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeDefault, ColorResource.instance.textDarkGreenColor)).paddingOnly(bottom: 1),
                    Text("Ocimum tenuiflorum", style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.textColor_2,),).paddingOnly(bottom: 1),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(ImageResource.instance.homeDrop,height: 15,),
                        Gap(DimensionResource.marginSizeExtraSmall),
                        Text("indoor".tr, style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.btnGreenColor,),),
                      ],
                    ).paddingOnly(bottom: DimensionResource.marginSizeExtraSmall),
                    YRoundedContainer(
                      radius: 5,
                      backgroundColor: ColorResource.instance.textDarkGreenColor,
                      padding: EdgeInsets.all(DimensionResource.marginSizeExtraSmall),
                      child: Text("move_collection".tr,style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeExtraSmall, ColorResource.instance.white),),
                    )
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,color: ColorResource.instance.grey_5,)
            ],
          ),
        ),
      );
}

class ScanHistoryCard extends StatelessWidget {

  final String titleKey;          // translation key e.g "snack"
  final String botanicalName;
  final String typeKey;
  final String imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onMoveTap;

  const ScanHistoryCard({
    super.key,
    required this.titleKey,
    required this.botanicalName,
    required this.imageUrl,
    this.onTap,
    this.onMoveTap,
    required this.typeKey,
  });

  @override
  Widget build(BuildContext context) {

    return YRoundedContainer(

      radius: 5,
      boxshadow: [
        BoxShadow(
            color: ColorResource.instance.grey.withValues(alpha: 0.2),

        )
      ],
      padding: EdgeInsets.all(DimensionResource.marginSizeSmall),

      onTap: onTap,

      child: Row(

        crossAxisAlignment: CrossAxisAlignment.center,

        children: [

          /// dynamic image
          YRoundedImage(
            imageUrl: imageUrl,
            width: 85,
            height: 85,
            fit: BoxFit.cover,
          ),

          Gap(DimensionResource.marginSizeDefault),

          /// dynamic content
          Expanded(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  titleKey.tr,
                  style: StyleResource.instance.styleSemiBold(
                    DimensionResource.fontSizeDefault,
                    ColorResource.instance.textDarkGreenColor,
                  ),
                ).paddingOnly(bottom: 1),

                Text(
                  botanicalName,
                  style: StyleResource.instance.styleRegular(
                    DimensionResource.fontSizeSmall,
                    ColorResource.instance.textColor_2,
                  ),
                ).paddingOnly(bottom: 1),

                /// dynamic type row
                Row(

                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [

                    Image.asset(
                      ImageResource.instance.scanOutlinedIcon,
                      height: 12,
                      color: ColorResource.instance.btnGreenColor,
                    ),

                    Gap(DimensionResource.marginSizeExtraSmall),

                    Text(
                      typeKey,
                      style: StyleResource.instance.styleRegular(
                        DimensionResource.fontSizeSmall,
                        ColorResource.instance.btnGreenColor,
                      ),
                    ),

                  ],
                ).paddingOnly(bottom: DimensionResource.marginSizeExtraSmall),

                /// dynamic move button
                // YRoundedContainer(
                //
                //   radius: 5,
                //
                //   backgroundColor: ColorResource.instance.textDarkGreenColor,
                //
                //   padding: EdgeInsets.all(
                //       DimensionResource.marginSizeExtraSmall),
                //
                //   onTap: onMoveTap,
                //
                //   child: Text(
                //     "move_collection".tr,
                //     style: StyleResource.instance.styleSemiBold(
                //       DimensionResource.fontSizeExtraSmall,
                //       ColorResource.instance.white,
                //     ),
                //   ),
                // )

              ],
            ),
          ),

          /// arrow
          Icon(
            Icons.arrow_forward_ios,
            color: ColorResource.instance.grey_5,
            size: 16,
          ),

        ],
      ),
    );
  }
}



