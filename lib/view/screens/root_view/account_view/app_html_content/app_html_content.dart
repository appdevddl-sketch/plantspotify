import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/font_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/widgets/no_data_screen/noDataScreen.dart';
import 'package:plants_spotify/view/widgets/shimmer_box/view_shimmers/cms_shimmer.dart';
import 'package:plants_spotify/view_model/controller/auth_controllers/app_content_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/account_view_controller/app_html_content_controller/app_html_content_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';



class AppHtmlContent extends StatelessWidget {
  const AppHtmlContent({super.key});

  @override
  Widget build(BuildContext context) {
    AppHtmlContentController controller = Get.put(AppHtmlContentController());
    return BaseView(
        viewControl: AppHtmlContentController(),
        appbarPerimeter: AppbarPerimeter(
          centerTitle: true,
            title:controller.backData.containsKey("title")?controller.backData["title"]??"":"",
            elevation: .5,
            titleColor: ColorResource.instance.mainColor
        ),
        onPageBuilder: (BuildContext context, AppHtmlContentController controller) =>  _buildLockView(context,controller));
  }
}

Widget _buildLockView(BuildContext context, AppHtmlContentController controller) {
  return Obx(() {
    if (controller.isLoading.value) {
      return const CmsShimmer();
    }else{
      return  SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Html(
                data: controller.backData.containsKey("type") && controller.backData["type"] == 1 ? controller.cmsData.value.data.aboutUs??"" :  controller.backData.containsKey("type") && controller.backData["type"] == 2 ? controller.cmsData.value.data.termsOfUse ??"" : controller.cmsData.value.data.privacyPolicy ??""
            ),
            // child: Text(controller.backData.containsKey("type") && controller.backData["type"] == 1 ? controller.cmsData.value.data.aboutUs??"" :  controller.cmsData.value.data.termsOfUse ??"",style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.textColor_2),)
        ),

      );
    }
  });


}
