

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/model/auth_model/country_model.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/plant_categories_model.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/search_results_model.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/font_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/search_screen/search_screen.dart';
import 'package:plants_spotify/view/widgets/app_common/app_heading/app_heading.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
import 'package:plants_spotify/view/widgets/common/dropdown_button_helper.dart' show DropdownButtonHelper, DropdownButtonHelperWithSearch;
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_image.dart';
import 'package:plants_spotify/view/widgets/layout/grid_layout.dart';
import 'package:plants_spotify/view/widgets/layout/list_view_layout.dart';
import 'package:plants_spotify/view/widgets/no_data_screen/noDataScreen.dart';
import 'package:plants_spotify/view/widgets/pagination_view/pagination_view_screen.dart';
import 'package:plants_spotify/view/widgets/shimmer_box/view_shimmers/search_list_shimmer.dart';
import 'package:plants_spotify/view/widgets/sliders/horizontal_slider.dart';
import 'package:plants_spotify/view/widgets/text_field_view/common_textfield.dart' show CommonTextField;
import 'package:plants_spotify/view/widgets/text_field_view/lable_container.dart';
import 'package:plants_spotify/view_model/controller/auth_controllers/profile_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/home_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/plant_index_controller/plant_index_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/tending_screen/trending_screen_controller.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';

import '../../../../../model/utils/input_formatters_resource.dart';
import '../../../../widgets/text_field_view/regex/regex.dart';
import '../../../base_view/base_view_screen.dart';


class PlantIndexScreen extends StatelessWidget {
  const PlantIndexScreen
      ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(viewControl: PlantIndexController(),
        appbarPerimeter: AppbarPerimeter(title: "plant_index".tr,titleColor: ColorResource.instance.black,centerTitle: true),
        onPageBuilder: (BuildContext context,PlantIndexController controller)=>_buildMainView(context,controller));
  }
}






Widget _buildMainView(BuildContext context,PlantIndexController controller){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal : DimensionResource.marginSizeDefault ,),
    child: Column(
      children: [
        CommonTextField(
          controller: controller.searchController,
          hintText: "search_here".tr,
          inputFormatters: InputFormattersResource.instance.nameInputFormatters,
          keyboardType: TextInputType.name,
          onValueChanged: (value)=>controller.searchPlants(),
          prefixIcon:  Padding(padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),child: Image.asset(ImageResource.instance.searchIcon)),
          validator: (val)=>val?.isValidNameValidation(onError:(error)=>controller.searchError.value =error),
          errorText: controller.searchError.value,
        ).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
        Expanded(
          child: SingleChildScrollView(
            controller: controller.searchPlantPaginationViewController.scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text("plants_index".tr,style: StyleResource.instance.styleBold(DimensionResource.fontSizeDefault, ColorResource.instance.black),),
                Obx(()=> StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  children: List.generate(controller.plantIndexData.value.data.data?.length ?? 0 , (index) {
                    final item = controller.plantIndexData.value.data.data?[index];
                    int position = (index + 1) % 6;
                    return StaggeredGridTile.fit(
                      crossAxisCellCount: (index + 1) % 6 == 0  ? 2 : 1,
                      child: PlantIndexCard(
                          imageUrl: item?.image??"",
                          title: item?.name ?? "",
                          isNetworkImage: true,
                          height: position == 3 ? 218 : position == 4 || position == 5 ? 100 : 150,
                          width: double.infinity,
                          isSelected: item?.id == controller.selectCategory.value.id,
                          onTap: ()=>controller.onChangeButtonTapped(item??PlantCategoryData()),
                      ),
                    );
                  },
                  ),
                ),).paddingOnly(bottom: DimensionResource.marginSizeDefault),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(controller.selectCategory.value.name??"",style: StyleResource.instance.styleBold(DimensionResource.fontSizeLarge, ColorResource.instance.black),).paddingOnly(top: DimensionResource.marginSizeSmall,bottom: DimensionResource.marginSizeDefault),
                    Obx(()=>SizedBox(
                      width: 120,
                      height:45,
                      child: DropdownButtonHelperWithSearch<CountryData>(
                        borderColor: ColorResource.instance.btnGreenColor,
                        hintText: controller.selectedCountry.value.name?.isEmpty??true?"country".tr:controller.selectedCountry.value.name??"",
                        valueSelectedOrNot: controller.selectedCountry.value.name != null,
                        itemList:(controller.countriesData.value.data.data??<CountryData>[]).obs,
                        itemView: (CountryData value)=>controller.selectedCountry.value.id == value.id ? "✓ ${value.name}" : value.name ??"",
                        onValueChanged:(CountryData value){ controller.selectedCountry.value = value; controller.getPlantCategoryDataApi(pageNumber: 1, forPaginate: false);},
                      ),
                    ))
                  ],
                ).paddingOnly(bottom: DimensionResource.marginSizeDefault),
                _buildCategoryDataList(context,controller),
                // _buildServices(context,controller),
              ],
            ),
          ),
        ),
      ],
    ),
  );

}

Widget _buildCategoryDataList(BuildContext context,PlantIndexController controller){
  return Obx(() {
    if (controller.searchPlantData.value.status != false && controller.searchPlantPaginationViewController.itemList.isNotEmpty) {
      return PaginationView<SearchPlantData>(
        isGrid: true,
        crossAxisCount: 2,
        gridPhysics: NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        sidePadding: EdgeInsets.zero,
        mainAxisExtent: 280,
        isCustomScrollController:true,
        onRefresh: () async {
          // controller.getArticles(isRefresh: true);
        },
        showItemList: controller.searchPlantPaginationViewController.itemList,
        pagingScrollController: controller.searchPlantPaginationViewController,
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
      );
    }
    else if (controller.searchPlantData.value.status == true && controller.searchPlantPaginationViewController.itemList.isEmpty) {
      return Center(child: Text("no_data_found".tr, style: StyleResource.instance.styleMedium(DimensionResource.fontSizeDefault, ColorResource.instance.textColor_2),textAlign: TextAlign.center,));
    }else {
      return PlantGridShimmer();
    }
  });
}


class PlantIndexCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final bool isSelected;
  final bool isNetworkImage;
  final bool isShowLocation;
  final String? location;
  final double? height;
  final double? width;
  final VoidCallback? onTap;


  const PlantIndexCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.isSelected = false,
    this.height = 120,
    this.width,
    this.onTap,
    this.isNetworkImage = false, this.isShowLocation = false,this.location,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: YRoundedContainer(
        padding: EdgeInsets.all(DimensionResource.marginSizeExtraSmall),
        backgroundColor: ColorResource.instance.white,
        radius: 5,
        width: width ?? HelperFunction.screenWidth(),
        showBorder: true,
        borderColor:
        ColorResource.instance.lightGrey.withValues(alpha: .2),
        boxshadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.09),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Stack(
            children: [
              /// IMAGE
              YRoundedImage(
                isNetworkImage: isNetworkImage,
                imageUrl: imageUrl,
                height: height,
                width: width ?? HelperFunction.screenWidth(),
                fit: BoxFit.cover,
              ),

              /// VERTICAL GRADIENT
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        ColorResource.instance.black.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              /// LEFT DARK OVERLAY
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.2),
                        Colors.transparent
                      ],
                    ),
                  ),
                ),
              ),

              /// TITLE
              Positioned(
                bottom: 10,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start  ,
                  children: [
                    Text(
                      title.tr,
                      style: StyleResource.instance.styleBold(
                        DimensionResource.fontSizeSmall,
                        ColorResource.instance.white,
                      ),
                    ),
                    if(isShowLocation)
                    Row(
                      children: [
                        Image.asset(ImageResource.instance.locationPinIcon,height: 10,color: ColorResource.instance.btnGreenColor,),
                        Gap(DimensionResource.marginSizeExtraSmall),
                        Text(location??"",style: StyleResource.instance.styleRegular(DimensionResource.fontSizeExtraSmall, ColorResource.instance.btnGreenColor))
                      ],
                    )
                  ],
                ),
              ),

              /// SELECTED ICON (TRUE / FALSE)
              if (isSelected)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Image.asset(
                    ImageResource.instance.selectedTrueIcon,
                    height: 18,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
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
// Widget _buildServices(BuildContext context, PlantIndexController controller) {
//
//   return  Column(
//     children: [
//       Obx(() => SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: List.generate(controller.orderCategory.length, (index) => GestureDetector(
//             onTap: () => controller.onChangeButtonTapped(index),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 500),
//               padding: const EdgeInsets.symmetric(
//                   horizontal: DimensionResource.marginSizeLarge,
//                   vertical: DimensionResource.marginSizeExtraSmall),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(50),
//                   color: controller.selectCategory.value == controller.orderCategory[index] ? ColorResource.instance.black : ColorResource.instance.textColor_9.withValues(alpha: 0.3)),
//               child: Text(
//                 controller.orderCategory[index].tr,
//                 style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, controller.selectCategory.value == controller.orderCategory[index] ? ColorResource.instance.white : ColorResource.instance.black),
//               ),
//             ).paddingOnly(right: DimensionResource.marginSizeSmall),
//           )),
//         ),
//       )),
//       Gap(DimensionResource.marginSizeDefault),
//       SizedBox(
//         height: HelperFunction.screenHeight() * .80,
//         child: TabBarView(
//           controller: controller.pageController,
//           children: [
//             YGridLayout(itemCount: 8, itemBuilder: (context,index){
//               return YRoundedContainer(
//                 padding: EdgeInsets.all(DimensionResource.marginSizeDefault),
//                 backgroundColor: ColorResource.instance.white,
//                 radius: 5,
//                 width: 150,
//                 showBorder: true,
//                 borderColor: ColorResource.instance.cardBgGreenColor.withValues(alpha: .4),
//                 boxshadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 8,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     YRoundedImage(
//                       imageUrl: ImageResource.instance.plantImage,
//                       borderRadius: 0,
//                       isNetworkImage: false,
//                       fit: BoxFit.contain,
//                       height: 120,
//                       width: HelperFunction.screenWidth(),
//                       backgroundColor: ColorResource.instance.cardBgGreenColor,
//                       padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
//                     ).paddingOnly(bottom: DimensionResource.marginSizeSmall),
//                     Row(
//                       children: [
//                         Image.asset(ImageResource.instance.homeDrop,height: 18,),
//                         Gap(DimensionResource.marginSizeSmall),
//                         Text("outdoor".tr,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.mainColor),),
//                       ],
//                     ).paddingOnly(bottom: DimensionResource.marginSizeSmall/2),
//                     Text("Tulsi",style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeDefault, ColorResource.instance.black),).paddingOnly(bottom: DimensionResource.marginSizeExtraSmall/2),
//                     Text("Keep your plants alive watering",style: StyleResource.instance.styleRegular(DimensionResource.fontSizeExtraSmall, ColorResource.instance.textColor_2),),
//
//                   ],
//                 ),
//               );
//             }, crossAxisSpacing: 10, mainAxisSpacing: 10,mainAxisExtent: 245,),
//             SizedBox(),
//             SizedBox(),
//             SizedBox(),
//             SizedBox(),
//           ],
//         ),
//       ),
//
//     ],
//   );
// }




