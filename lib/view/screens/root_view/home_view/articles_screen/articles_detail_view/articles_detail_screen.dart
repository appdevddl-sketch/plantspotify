

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/loader_helper/loader_helper_ui.dart';
import 'package:plants_spotify/view/widgets/no_data_screen/noDataScreen.dart';
import 'package:plants_spotify/view/widgets/sliders/promo_slider.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/articles_controller/articles_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/articles_controller/articles_detail_controller/articles_detail_controller.dart';






class ArticlesDetailScreen extends StatelessWidget {
  const ArticlesDetailScreen
      ({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(viewControl: ArticlesDetailController(),
        appbarPerimeter: AppbarPerimeter(title: "".tr,centerTitle: true,appBarBackGroundColor: ColorResource.instance.white,actionButton: [
        //   YRoundedContainer(
        // margin: const EdgeInsets.only(right: 10),
        // backgroundColor:
        // ColorResource.instance.socialButtonGreenColor,
        // radius: 30,
        // height: 36,
        // width: 36,
        // child: Center(
        //   child: Image.asset(
        //     ImageResource.instance.shareIcon,
        //     height: 18,
        //   ),)
        //   )
        ]),
        onPageBuilder: (BuildContext context,ArticlesDetailController controller)=>_buildMainView(context,controller));
  }
}

Widget _buildMainView(BuildContext context,ArticlesDetailController controller){
  return Obx((){
    if(controller.articleDetailData.value.status!=false && controller.articleDetailData.value.data.id !=null && controller.isLoading.value == false) {
      return _buildDetailPage(context,controller);
    } else {
      return loaderHelperUi();
    }
  });


}

Widget _buildDetailPage(BuildContext context,ArticlesDetailController controller){
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(DimensionResource.marginSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YPromoSlider(
              height: 200,
              width: HelperFunction.screenWidth(),
              autoplay: false,
              imageBorderRadius: 5,
              viewportFraction:1,
              aspectRatio:1,
              fit: BoxFit.cover,
              banners: controller.articleDetailData.value.data.images!.map((e) => e).whereType<String>().toList() ?? []
          ).paddingOnly(bottom: DimensionResource.paddingSizeDefault),
          Text(controller.articleDetailData.value.data.title??"",style: StyleResource.instance.styleBold(DimensionResource.fontSizeLarge, ColorResource.instance.textDarkGreenColor),).paddingOnly(bottom: DimensionResource.paddingSizeDefault),
          Html(data: controller.articleDetailData.value.data.content??"",),
          // Text(controller.articleDetailData.value.data.content??"",style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.textColor_2),)

        ],

      ),
    ),
  );
}




