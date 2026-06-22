import 'dart:io';


import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:plants_spotify/model/services/auth_service.dart';
import 'package:plants_spotify/view/screens/root_view/account_view/account_view_screen.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/screens/root_view/force_update_screen.dart';
import 'package:plants_spotify/view/widgets/toast_view/showtoast.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';
import 'package:lottie/lottie.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';


import '../../../model/utils/color_resource.dart';
import '../../../model/utils/decoration_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/style_resource.dart';
import '../../../view_model/controller/root_view_contrller/root_view_controller.dart';


class RootView extends StatelessWidget {
  const RootView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RootViewController controller =Get.put(RootViewController());
    return PopScope(
      onPopInvoked: (value)=>controller.onWillPopClick.call(),
      canPop: false,
      child: SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: Platform.isAndroid ? true : false,
        child: Container(
          height: double.infinity,
          color: ColorResource.instance.white,
          child: Obx(
                ()=> !controller.isValidVersion.value
                ? const ForceUpdateScreen()
                : Column(
                children: [
                Expanded(
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    drawer: const AccountViewScreen(),
                    key: controller.scaffoldKey,
                    body:Stack(
                      children: [
                        Positioned.fill(child: _buildRootMainView(context, controller)),
                        Positioned(left:0,right:0,bottom:0,child: _buildBottomNavigationBar(context,controller)),
                        Positioned(
                            bottom: Platform.isAndroid ? 14 : 24,
                            left: HelperFunction.screenWidth() / 2 - 30,
                            right: HelperFunction.screenWidth() /2 - 30,
                            child: GestureDetector(
                              onTap: (){
                                if((Get.find<AuthService>().user.value.name?.trim().toLowerCase() == "user")){
                                controller.completeProfile();
                                }else{
                                  controller.identifyProcess();
                                }
                              },
                              child: YRoundedContainer(
                                padding: EdgeInsets.all(DimensionResource.marginSizeDefault),
                                radius: 40,
                                width: 60,
                                height: 60,
                                borderWidth: 1,
                                borderColor: ColorResource.instance.btnBorderGreen,
                                boxshadow: DecorationResource.instance.rootButtonBoxShadow(ColorResource.instance.black.withValues(alpha: 0.15)),
                                showBorder: true,
                                backgroundColor: ColorResource.instance.socialButtonGreenColor,
                                child: Center(
                                    child: Image.asset(ImageResource.instance.scanIcon,height: 30,)
                                ),
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                ),
                !controller.isNetConnect.value ? _buildInternetErrorBar(context: context, errorMessage: "No internet connection".tr, controller: controller): const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildRootMainView(BuildContext context, RootViewController controller) {
  return Obx(() =>controller.widgetOptions.elementAt(controller.selectedIndex.value));
}

Widget _buildBottomNavigationBar(BuildContext context, RootViewController controller) {
  return ClipRRect(
      borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
      child: Container(
        height: Platform.isAndroid ? 70 : 80,
      padding:const EdgeInsets.only(left: DimensionResource.marginSizeSmall,right: DimensionResource.marginSizeSmall,top: DimensionResource.marginSizeSmall-2),

      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ColorResource.instance.grey.withValues(alpha: 0.1),
            offset: const Offset(0, -2), // shadow only on top
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
          color: ColorResource.instance.white,
        border: Border(
          top: BorderSide(
            color: ColorResource.instance.black.withValues(alpha: 0.05),
            width: 1,
          ),
        ),

      ),
      child: Obx(()=>Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:List.generate(controller.images.length, (index) => _buildBottomBarIconTap(controller.images[index]["image"],controller.images[index]["title"],(){controller.onItemTapped(index);},index==controller.selectedIndex.value?ColorResource.instance.btnGreenColor:ColorResource.instance.rootTextColor,index==controller.selectedIndex.value?ColorResource.instance.btnGreenColor:ColorResource.instance.white)),
      )),
    ),
  );
}

Widget _buildBottomBarIconTap(String image,String title,VoidCallback onTap,Color color,Color indicatorColor){
  return InkWell(
    onTap: onTap,
    child: Column(
      children: [
        SizedBox(
          height: 40,
          width: 40,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: image.isNotEmpty ? Image.asset(image,color: color,) : SizedBox(),
          ),
        ),
        Text(title.tr,style: StyleResource.instance.styleMedium(DimensionResource.fontSizeSmall-2, color).copyWith(height: 1),)
      ],
    ),
  );
}
Widget _buildInternetErrorBar({required BuildContext context ,required String errorMessage,required RootViewController controller}){
  return Material(
    child: Obx(
          ()=> Container(
          color: !controller.isNetConnect.value && controller.isBackOnline.value ? ColorResource.instance.black:ColorResource.instance.greenColor,
          height: 20,
          width: double.infinity,
          child: Center(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(!controller.isNetConnect.value  && controller.isBackOnline.value ? errorMessage : "Back online".tr,style: StyleResource.instance.styleMedium(DimensionResource.fontSizeExtraSmall, ColorResource.instance.white),),
              const Gap(DimensionResource.marginSizeExtraSmall),
              Lottie.asset(!controller.isNetConnect.value  && controller.isBackOnline.value ? ImageResource.instance.noWifiAnimation :ImageResource.instance.wifiConnectedAnimation ,height: DimensionResource.iconSizeSmall,repeat: false,key: ValueKey(!controller.isNetConnect.value && controller.isBackOnline.value ? "noWifiAnimation" : "wifiConnectedAnimation",),)
            ],
          ))
      ),
    ),
  );
}

class IsIosPadding extends StatelessWidget {
  const IsIosPadding({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: child),
        Platform.isIOS ? Gap(DimensionResource.paddingSizeDefault) : Gap(0),
      ],
    );
  }
}
