

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/model/root_view_models/nursery_models/collection_model.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/font_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/input_formatters_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/save_plants_bottomsheet.dart';
import 'package:plants_spotify/view/widgets/app_common/app_heading/app_heading.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
import 'package:plants_spotify/view/widgets/common/dropdown_button_helper.dart' show DropdownButtonHelper;
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_image.dart';
import 'package:plants_spotify/view/widgets/layout/grid_layout.dart';
import 'package:plants_spotify/view/widgets/layout/list_view_layout.dart';
import 'package:plants_spotify/view/widgets/no_data_screen/noDataScreen.dart';
import 'package:plants_spotify/view/widgets/shimmer_box/view_shimmers/nursery_screen_shimmer.dart';
import 'package:plants_spotify/view/widgets/sliders/horizontal_slider.dart';
import 'package:plants_spotify/view/widgets/text_field_view/common_textfield.dart' show CommonTextField;
import 'package:plants_spotify/view/widgets/text_field_view/lable_container.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view_model/controller/auth_controllers/profile_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/create_collection_screen/create_collection_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/home_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/plant_index_controller/plant_index_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/tending_screen/trending_screen_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/my_nursery_controller/my_nursery_controller.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';




class MyNurseryScreen extends StatelessWidget {
  const MyNurseryScreen
      ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(viewControl: MyNurseryController(),
        showNetworkStatusBar: Get.currentRoute != Routes.rootView ? true : false,
        bottomSafeArea: false,
        floatingActionButton: (BuildContext context,MyNurseryController controller)=> _buildFloatingButton(context,controller),
        appbarPerimeter: AppbarPerimeter(title: "my_nursery".tr,centerTitle: true,backButtonShow: (Get.currentRoute ==Routes.rootView) ? false : true,appBarBackGroundColor: ColorResource.instance.grey_1),
        onPageBuilder: (BuildContext context,MyNurseryController controller)=>_buildMainView(context,controller));
  }
}

Widget _buildMainView(BuildContext context,MyNurseryController controller){
 return Obx((){
    if(controller.collectionList.value.data.isNotEmpty){
      return Container(
        padding: EdgeInsets.only(top: DimensionResource.marginSizeDefault,left: DimensionResource.marginSizeDefault,right: DimensionResource.marginSizeDefault,),
        child: RefreshIndicator(
          color: ColorResource.instance.mainColor,
          onRefresh: () async { controller.collectionList.value = ListResponse<CollectionData>(data:[]);  controller.onInit();},
          child: ListView(
            children: [
              Text("my_collections".tr,style: StyleResource.instance.styleBold(DimensionResource.fontSizeDefault, ColorResource.instance.black),).paddingOnly(bottom: DimensionResource.paddingSizeDefault),
              ...List.generate(controller.collectionList.value.data.length, (index){
                return CollectionCard(
                    onCardTap: ()=>Get.toNamed(Routes.myCollectionScreen,arguments: controller.collectionList.value.data[index]),
                    showSubtitle: true,
                    subtitle: "${controller.collectionList.value.data[index].plantsCount} ${"plants_saved".tr}",
                    isNetworkImage: true,title: controller.collectionList.value.data[index].name??"",
                    image: controller.collectionList.value.data[index].image??"",
                    isEdit: true,
                    onSaveTap: (ctx)=>controller.showCollectionMenu(ctx,controller.collectionList.value.data[index].id.toString()??"0",
                    controller.collectionList.value.data[index].name??"")).paddingOnly(bottom: DimensionResource.paddingSizeDefault);
              }),
            Gap(200)

            ],
          ),
        ),
      );
    }else if(controller.collectionList.value.data.isEmpty && controller.isLoading.value == false){
      return NoDataFoundScreen(message: "no_data_found".tr,onRefresh: () =>controller.onInit(),);
    }else{
    return NurseryScreenShimmer();
    }
  });


}

Widget _buildFloatingButton(BuildContext context,MyNurseryController controller){
  return YRoundedContainer(
    onTap: ()=>Get.toNamed(Routes.createCollectionScreen)?.then((e){
      controller.onInit();
    }),
    backgroundColor:
    ColorResource.instance.socialButtonGreenColor,
    showBorder: true,
    borderColor:
    ColorResource.instance.btnGreenBorderColor,
    radius: 50,
    height: 50,
    width: 50,
    child: Center(
      child: Icon(
        Icons.add,
        color: ColorResource.instance.btnGreenColor,
        size: 20,
      ),
    ),
  ).paddingOnly(bottom: Get.currentRoute != Routes.rootView ? 20 : 90);

}


class CollectionMenuOverlay extends StatelessWidget {
  final double top;
  final double left;
  final VoidCallback onRename;
  final VoidCallback onDelete;
  final VoidCallback onClose;

  const CollectionMenuOverlay({
    super.key,
    required this.top,
    required this.left,
    required this.onRename,
    required this.onDelete,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.translucent,
            ),
          ),

          Positioned(
            top: top,
            left: left,
            child: Container(
              width: 180,
              decoration: BoxDecoration(
                color: ColorResource.instance.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: ColorResource.instance.btnBorderGreen.withValues(alpha: 0.4)),
                boxShadow: [
                  BoxShadow(
                    color: ColorResource.instance.btnBorderGreen.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _menuItem(ImageResource.instance.editPenOutlined, 'Rename', onRename),
                  Divider(color: ColorResource.instance.lightGrey.withValues(alpha: 0.2),).paddingSymmetric(horizontal: DimensionResource.paddingSizeDefault),
                  _menuItem(ImageResource.instance.binIcon, 'Delete', onDelete),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
      String icon,
      String title,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFDFF2D7),
              child:  Image.asset(icon, height: 16,),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}






