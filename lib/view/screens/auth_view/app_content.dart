import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/widgets/no_data_screen/noDataScreen.dart';
import 'package:plants_spotify/view_model/controller/auth_controllers/app_content_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';



class AppContentScreen extends StatelessWidget {
  const AppContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppContentController controller = Get.put(AppContentController());
    return BaseView(
        viewControl: AppContentController(),
        appbarPerimeter: AppbarPerimeter(
            title:controller.backData.containsKey("type")?controller.backData["type"]??"":"",
            elevation: .5,
          titleColor: ColorResource.instance.mainColor
        ),
        onPageBuilder: (BuildContext context, AppContentController controller) =>  _buildLockView(context,controller));
  }
}

Widget _buildLockView(BuildContext context, AppContentController controller) {
  return Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Obx(()=>Visibility(
            visible: controller.progressCount.value!=100,
            child: LinearProgressIndicator(
              backgroundColor: ColorResource.instance.mainColor,
              valueColor: AlwaysStoppedAnimation(ColorResource.instance.lightMainColor),
              minHeight: 5,
            ),
          )),
          if(controller.backData['url']!='')
            Expanded(
            child: controller.backData["url"]!="" ? WebViewWidget(
              layoutDirection: TextDirection.ltr, controller: controller.controllerWv,
            ) : const NoDataFoundScreen(),
          ),
        ],
      ),
    ),
  );
}
