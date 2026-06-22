
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/services/auth_service.dart';
import 'package:plants_spotify/model/services/auth_service.dart';
import 'package:plants_spotify/model/services/globleService.dart';
import 'package:plants_spotify/model/utils/app_constants.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/widgets/common/custome_switch_button.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/common/profile_image_widget.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/text_field_view/lable_container.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/account_view_controller/account_view_controller.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';

import '../../../../model/utils/color_resource.dart';

class AccountViewScreen extends StatelessWidget {
  const AccountViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Drawer(
        elevation: 10,
        backgroundColor: ColorResource.instance.grey_1,
        child: BaseView(
            viewControl: AccountViewController(),
            showNetworkStatusBar: false,
            bottomSafeArea: false,
            onPageBuilder: (BuildContext context, AccountViewController controller) => buildMainPage(context, controller)),
      ),
    );
  }
}

buildMainPage(BuildContext context ,AccountViewController controller){
  return YRoundedContainer(
    height: HelperFunction.screenHeight(),
    width: HelperFunction.screenWidth(),
    radius: 0,
    gradient: LinearGradient(
      colors: [ColorResource.instance.gradientGreenColor,ColorResource.instance.white ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [
        0.0, 0.2
      ],
    ),
   
    child: Column(
      children: [
        Platform.isIOS ? Gap(DimensionResource.defaultIos) : Gap(DimensionResource.defaultTop),
        _buildHeaderView(context,controller),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(right:0,top:0,child: Image.asset(ImageResource.instance.leafImage,width: HelperFunction.screenWidth() * 0.5,)),
              Positioned(left:0,bottom:0,child: Image.asset(ImageResource.instance.leaf8Image,width: HelperFunction.screenWidth() * 0.35,)),
              Positioned(right:0,bottom:0,child: Image.asset(ImageResource.instance.leaf9Image,width: HelperFunction.screenWidth() * 0.34,)),
              Positioned(bottom:10,child: Text("${"app_version".tr}: ${controller.appVersion}",style: StyleResource.instance.styleMedium(DimensionResource.fontSizeExtraSmall, ColorResource.instance.textColor_2),)),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeDefault),
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  padding:const  EdgeInsets.symmetric(vertical: DimensionResource.marginSizeDefault),
                  children: [
                    LabelContainer(
                      label: 'general'.tr,
                      labelColor: ColorResource.instance.textDarkGreenColor2,
                      child: YRoundedContainer(
                          boxshadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 12,
                              spreadRadius: 0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          padding: EdgeInsets.all(DimensionResource.paddingSizeSmall),
                          child: Column(
                              children:[
                                optionTile(
                                    onTap: ()=>Get.toNamed(Routes.profileScreen),
                                    title: "user_profile".tr,
                                    topBorder: false
                                ),
                                optionTile(
                                  onTap: ()=>Get.toNamed(Routes.scanHistoryScreen),
                                  title: "scan_history".tr,
                                ),
                                optionTile(
                                  onTap: ()=>Get.toNamed(Routes.subscriptionScreen),
                                  title: "subscription".tr,
                                ),
                                optionTile(
                                  onTap: ()=>Get.toNamed(Routes.contactUsScreen),
                                  title: "contact_us".tr,
                                ),
                                // optionTile(
                                //   onTap: ()=>Get.toNamed(Routes.ratingScreen),
                                //   title: "rate_us".tr,
                                //
                                // ),
                                optionTile(
                                  onTap: ()=> HelperFunction.shareApp(),
                                  title: "share_with_your_friends".tr,

                                ),
                              ]
                          )
                      ),
                    ).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
                    LabelContainer(
                      label: 'help_and_support'.tr,
                      labelColor: ColorResource.instance.textDarkGreenColor2,
                      child: YRoundedContainer(
                          boxshadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 12,
                              spreadRadius: 0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          padding: EdgeInsets.all(DimensionResource.paddingSizeSmall),
                          child: Column(
                              children:[
                                optionTile(
                                  onTap: ()=>Get.toNamed(Routes.htmlContentView,arguments: {"type":2,"title":"terms_of_use".tr}),
                                  title: "terms_of_use".tr,
                                  topBorder: false
                                ),
                                optionTile(
                                  onTap: ()=>Get.toNamed(Routes.htmlContentView,arguments: {"type":3,"title":"privacy_policy".tr}),
                                  title: "privacy_policy".tr,
                                ),
                                optionTile(
                                  onTap: ()=>HelperFunction.openStoreForRating(),
                                  title: "review_key".tr,
                                ),
                                optionTile(
                                  onTap: ()=>Get.toNamed(Routes.helpScreen),
                                  title: "help&faq".tr,
                                ),
                                optionTile(
                                  onTap: ()=>Get.toNamed(Routes.htmlContentView,arguments: {"type":1,"title":"about_us".tr}),
                                  title: "about_us".tr,
                                ),
                                optionTile(
                                  onTap: ()=>controller.openDeleteDialog(controller),
                                  title: "delete_account".tr,

                                ),
                                optionTile(
                                  onTap: ()=>controller.logout(),
                                  title: "logout".tr,
                                )
                              ]
                          )
                      ),
                    ).paddingOnly(bottom: DimensionResource.paddingSizeSmall),


                  ],
                ),
              )

            ],
          ),
        )
      ],
    )
  );

}
Widget _buildHeaderView(BuildContext context, AccountViewController controller){
  return Container(
    padding: EdgeInsets.only(left: DimensionResource.marginSizeDefault,right: DimensionResource.marginSizeDefault,top: DimensionResource.marginSizeDefault),
    child:Row(
      children: [
       ProfileImageViewHelper(imageUrl: "",boxRound: 60,borderWidth: 0).paddingOnly(right: DimensionResource.marginSizeDefault),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Get.find<AuthService>().user.value.name??"",style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeLarge, ColorResource.instance.black),),
              Text(Get.find<AuthService>().user.value.countryName??Get.find<AuthService>().userIp.value.country??"",style: StyleResource.instance.styleRegular(DimensionResource.fontSizeExtraSmall, ColorResource.instance.textDarkGreenColor),),
            ],
          ),
        ),
        YRoundedContainer(
          onTap: ()=>Get.toNamed(Routes.editProfileScreen),
          height: 30,
          width: 30,
          backgroundColor: ColorResource.instance.btnGreenColor,
          padding: EdgeInsets.all(DimensionResource.marginSizeSmall),
          radius: 30,
          child: Image.asset(ImageResource.instance.editPenIcon,),
        )
      ],

    ),
  );
}


Widget optionTile({required VoidCallback onTap, bool ?topBorder,required String title}) {
  return Container(
    height: 42,
    width: double.infinity,
    decoration: BoxDecoration(
        border: Border(
            top: BorderSide(color: topBorder == null ? ColorResource.instance.dividerGrey : topBorder == true ? ColorResource.instance.dividerGrey : Colors.transparent,width: .5),
            bottom: BorderSide(color: topBorder == null ? ColorResource.instance.transparent : topBorder == false ? ColorResource.instance.dividerGrey : Colors.transparent,width: .5))),
    child: MaterialButton(
      padding:const  EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeDefault),
      onPressed: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              style: StyleResource.instance.styleRegular(DimensionResource.fontSizeDefault, ColorResource.instance.textDarkGreenColor),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: ColorResource.instance.textColor_2,
          )
        ],
      ),
    ),
  );
}



