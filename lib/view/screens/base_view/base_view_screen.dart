
import 'dart:async';


import 'package:plants_spotify/model/utils/decoration_resource.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view/widgets/app_common/commonappbar/common_app_bar.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/root_view_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/inernet_connection_util.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
import 'package:plants_spotify/view/widgets/loader_helper/loader_helper_ui.dart';
import 'package:plants_spotify/view/widgets/no_data_screen/noDataScreen.dart';

import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/style_resource.dart';

class BaseView <T extends BaseViewController> extends GetView {
  final T viewControl;
  final AppbarPerimeter ?appbarPerimeter;
  final PreferredSizeWidget  Function(BuildContext context, T value)?customAppbar;
  final Color ?backgroundColor;
  final String? tag;
  final bool bottomSafeArea;
  final bool showNetworkStatusBar;
  final bool? resizeToAvoidBottomInset;
  final BottomBarPerimeter ?bottomBarPerimeter;
  final FloatingActionButtonLocation ?floatingActionButtonLocation;
  final Widget Function(BuildContext context, T value) onPageBuilder;
  final Widget Function(BuildContext context, T value) ?floatingActionButton;
  const BaseView( {Key? key,this.customAppbar,this.tag,required this.viewControl, required this.onPageBuilder, this.appbarPerimeter,this.bottomBarPerimeter,this.floatingActionButton,this.backgroundColor,this.floatingActionButtonLocation, this.showNetworkStatusBar = true, this.bottomSafeArea = false, this.resizeToAvoidBottomInset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final T controller = (tag != null)?Get.put(viewControl,tag: tag):Get.put(viewControl);
    return Obx(
          ()=> Column(
        children: [
          Expanded(
            child: SafeArea(
              top: false,
              left: false,
              right: false,
              bottom: bottomSafeArea,
              child: Scaffold(
                resizeToAvoidBottomInset: resizeToAvoidBottomInset,
                appBar: customAppbar!=null?customAppbar!(context, controller) : (appbarPerimeter!=null?_buildAppBar(context, controller, appbarPerimeter!) : _buildBlankAppBar()),
                backgroundColor:backgroundColor?? ColorResource.instance.white,
                body: Obx(() => controller.isNoDataFoundViewShow.value ? const NoDataFoundScreen() : controller.isPageLoading.value ? Center(child: loaderHelperUi(),)
                    : controller.errorText.value.isNotEmpty
                    ? _buildErrorPage<T>(context: context, errorMessage: controller.errorText.value, controller: controller)
                    : SizedBox(height: double.infinity, width: double.infinity, child: onPageBuilder(context, controller),
                )),
                bottomNavigationBar: bottomBarPerimeter!=null ? bottomBarWidget(bottomBarPerimeter!,controller) :const SizedBox(),
                floatingActionButton: floatingActionButton==null ? const SizedBox() : floatingActionButton!(context, controller),
                floatingActionButtonLocation:floatingActionButtonLocation?? FloatingActionButtonLocation.endDocked,
              ),
            ),
          ),
          !controller.isNetConnect.value  && showNetworkStatusBar ? _buildInternetErrorBar(context: context, errorMessage: "No internet connection".tr, controller: controller): const SizedBox(),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, T controller, AppbarPerimeter appbarPerimeter) {
    return AppBar(
      centerTitle: appbarPerimeter.centerTitle,
      elevation: appbarPerimeter.elevation ?? 0,
      toolbarHeight: DimensionResource.appBarHeight,
      backgroundColor: appbarPerimeter.appBarBackGroundColor ?? ColorResource.instance.extraLightMainColor,
      automaticallyImplyLeading: false,
      flexibleSpace: appbarPerimeter.appBarWidget == null
          ? Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
        decoration: BoxDecoration(
          color: appbarPerimeter.appBarBackGroundColor ?? ColorResource.instance.white,
          border: Border(
            bottom: BorderSide(color: ColorResource.instance.lightMainColor),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // back button or placeholder
            if (appbarPerimeter.backButtonShow == true)
              InkWell(
                onTap: appbarPerimeter.onTapBackButton ?? () => Get.back(),
                child: Container(
                  height: 35,
                  width: 35,
                  padding: const EdgeInsets.all(DimensionResource.marginSizeSmall),
                  decoration: BoxDecoration(
                    color: ColorResource.instance.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: DecorationResource.instance.containerBoxShadow(ColorResource.instance.grey),
                  ),
                  child: Image.asset(
                    ImageResource.instance.backArrowIcon,
                    height: 11,
                    color: ColorResource.instance.black,
                  ),
                ),
              )
            else
              const SizedBox(height: 38, width: 38),

            // title area (centered or left-aligned)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: DimensionResource.paddingSizeDefault),
                child: appbarPerimeter.centerTitle
                    ? Center(
                  child: Text(
                    appbarPerimeter.title,
                    style: StyleResource.instance.styleSemiBold(
                      DimensionResource.fontSizeDefault,
                      appbarPerimeter.titleColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
                    : Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    appbarPerimeter.title,
                    style: StyleResource.instance.styleSemiBold(
                      DimensionResource.fontSizeDefault,
                      appbarPerimeter.titleColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),

            // action buttons or placeholder
            appbarPerimeter.actionButton.isNotEmpty
                ? Row(mainAxisSize: MainAxisSize.min, children: appbarPerimeter.actionButton)
                : const SizedBox(height: 38, width: 38),
          ],
        ),
      )
          : appbarPerimeter.appBarWidget!(context, controller),
    );
  }

  PreferredSize _buildBlankAppBar() {
    return const PreferredSize(
        preferredSize:  Size(0.0, 0.0),
        child: SizedBox());
  }

  Widget bottomBarWidget(BottomBarPerimeter bottomBarPerimeter,T controller){
    return Container(
      height: bottomBarPerimeter.bottomBarHeight,
      width: double.infinity,
      color: bottomBarPerimeter.bottomBarBackGroundColor,
      child: bottomBarPerimeter.widget(bottomBarPerimeter.context,controller),
    );
  }

}

class AppbarPerimeter{
  Color ?appBarBackGroundColor ;
  Color backButtonColor;
  Color titleColor;
  bool backButtonShow ;
  bool centerTitle ;
  String title ;
  double ?elevation;
  VoidCallback ?onTapBackButton;
  List<Widget> actionButton;
  Widget Function(BuildContext context, dynamic value)? appBarWidget;
  AppbarPerimeter({this.centerTitle = false,this.backButtonShow = true,this.title= "",this.actionButton =const [],this.appBarBackGroundColor ,this.backButtonColor = Colors.black,this.titleColor =  const Color(0xff103303),this.onTapBackButton,this.elevation,this.appBarWidget});
}

class BottomBarPerimeter {
  Color bottomBarBackGroundColor ;
  double bottomBarHeight;
  BuildContext context;
  Widget Function(BuildContext context, dynamic value) widget;
  BottomBarPerimeter({this.bottomBarHeight = 60,required this.widget ,this.bottomBarBackGroundColor= Colors.transparent,required this.context});
}


Widget _buildErrorPage<T extends GetxController>({required BuildContext context ,required String errorMessage,required T controller}){
  return Container(
      color: ColorResource.instance.white,
      height: double.infinity,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(ImageResource.instance.somethingWrongImage,height: MediaQuery.of(context).size.height*.3,),
          const SizedBox(height: DimensionResource.roundButtonRadius,),
          Text("There's something wrong here.",style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeExtraLarge, ColorResource.instance.black),),
          const SizedBox(height: DimensionResource.marginSizeSmall,),
          Text(errorMessage,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeDefault, ColorResource.instance.textColor_2),textAlign: TextAlign.center,),
          const SizedBox(height: DimensionResource.marginSizeExtraLarge,),
          CommonButton(height: 45,width: 150,text: "Refresh", loading: false, onPressed: (){controller.onInit();},textSize: DimensionResource.fontSizeLarge,),
          const SizedBox(height: 100,),
        ],
      )
  );
}
Widget _buildInternetErrorBar({required BuildContext context ,required String errorMessage,required BaseViewController controller}){
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

class BaseViewController extends GetxController{
  RxString errorText = "".obs;
  RxBool isLoading = false.obs;
  RxBool isPageLoading = false.obs;
  RxBool isNoDataFoundViewShow = false.obs;
  RxBool isNetConnect = true.obs;
  RxBool isBackOnline = false.obs;
  RxBool homeControllerActive = true.obs;
  StreamSubscription? internetListener;
  @override
  void onInit() {
    super.onInit();
    Get.isRegistered<HomeController>() && Get.currentRoute =='/homeScreen' ? homeControllerActive.value = false : homeControllerActive.value = true;
    _internetCheck();
  }

  void _internetCheck(){
    internetListener =
        InternetConnectionUtil.instance.registerCallBack(onConnected: () {
          isBackOnline.value = false;
          Timer(const Duration(seconds: 4), () {
            isNetConnect.value = true;
          });
        }, onDisconnected: () {
          isBackOnline.value = true;
          isNetConnect.value = false;
        });
  }
  @override
  void onClose() {
    super.onClose();
    internetListener?.cancel();
  }
}

