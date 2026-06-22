

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/services/auth_service.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
import 'package:plants_spotify/view/widgets/button_view/yinkwell.dart';
import 'package:plants_spotify/view/widgets/common/dropdown_button_helper.dart' show DropdownButtonHelper;
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/common/profile_image_widget.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/text_field_view/common_textfield.dart' show CommonTextField;
import 'package:plants_spotify/view/widgets/text_field_view/lable_container.dart';
import 'package:plants_spotify/view_model/controller/auth_controllers/complete_profile_controller.dart';
import 'package:plants_spotify/view_model/controller/auth_controllers/profile_controller.dart';
import 'package:plants_spotify/view_model/controller/auth_controllers/social_signIn_controller.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';

import '../../../../../model/utils/input_formatters_resource.dart';
import '../../../../widgets/text_field_view/regex/regex.dart';
import '../../../base_view/base_view_screen.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(viewControl: ProfileController(),
        bottomSafeArea: false,
        showNetworkStatusBar: Get.currentRoute != Routes.rootView ? true : false,
        onPageBuilder: (BuildContext context,ProfileController controller)=>_buildLoginView(context,controller));
  }
}

Widget _buildLoginView(BuildContext context,ProfileController controller){
  return SizedBox(
    height: HelperFunction.screenHeight(),
    width: HelperFunction.screenWidth(),
    child: Column(
      children: [
        SizedBox(
          width: HelperFunction.screenWidth(),
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(ImageResource.instance.leafTransparentImage,height:300,fit: BoxFit.cover,),
              Positioned(
                top: 30,
                left: 10,
                child: Get.currentRoute != Routes.rootView ? YInkwell(
                  onTap: () => Get.back(),
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
                      color: ColorResource.instance.textDarkGreenColor,
                    ),
                  ),
                ).paddingSymmetric(vertical: DimensionResource.paddingSizeExtraSmall) :  SizedBox.shrink(),
              ),
              Positioned(left: 0,bottom:0,child: Image.asset(ImageResource.instance.leaf10Image,width: HelperFunction.screenWidth() * 0.50,)),
              Positioned(top:55,child: Text("profile".tr,style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeLarge, ColorResource.instance.textDarkGreenColor),).paddingOnly(bottom: DimensionResource.marginSizeSmall)),
              Positioned(
                bottom: 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProfileImageViewHelper(imageUrl: "",boxRound: 90,borderWidth: 2).paddingOnly(bottom: DimensionResource.marginSizeDefault),
                    Text(Get.find<AuthService>().user.value.name??"",style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeLarge, ColorResource.instance.black),),
                    YInkwell(onTap: ()=>Get.toNamed(Routes.editProfileScreen),child: Text("edit".tr,style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeSmall, ColorResource.instance.textRed),)),
                  ],
                ),
              ),

            ],
          ),
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  if(Get.find<AuthService>().user.value.homeType?.name !=null)
                  ProfileInfoRow(
                    title: "name".tr,
                    subTitle: Get.find<AuthService>().user.value.name??"",
                    icon: ImageResource.instance.userOutlinedIcon,
                    extraContentSubtitle: Get.find<AuthService>().user.value.age.toString()??"",
                    extraContentTitle: "age".tr,
                    showBottomBorder: true,
                    showExtraContent: true,
                  ),
                  if(Get.find<AuthService>().user.value.homeType?.name !=null)
                  ProfileInfoRow(
                    title: "type_of_home_living".tr,
                    subTitle:  Get.find<AuthService>().user.value.homeType?.name??"",
                    icon: ImageResource.instance.homeOutlinedIcon,
                    showExtraContent: false,
                    showBottomBorder: true,
                  ),
                  if(Get.find<AuthService>().user.value.countryName !=null)
                  ProfileInfoRow(
                    title: "location".tr,
                    subTitle: Get.find<AuthService>().user.value.countryName??"",
                    icon: ImageResource.instance.locationOutlinedIcon,
                    showBottomBorder: false,
                  )
                ],
              ).paddingOnly(top: DimensionResource.marginSizeDefault),
              Positioned(bottom: Get.currentRoute == Routes.rootView ? 50 : 0,left: 0,child: Image.asset(ImageResource.instance.leaf11Image,width: HelperFunction.screenWidth() * .50,))
            ],
          ),
        ),


      ],
    ),
  );
}

class ProfileInfoRow extends StatelessWidget {
  const ProfileInfoRow({
    super.key,
    required this.subTitle,
    this.extraContentTitle,
    this.extraContentSubtitle,

    this.showBottomBorder = true,
    this.showExtraContent = false,
    this.icon, required this.title,
  });

  final String subTitle;
  final String title;


  final String? extraContentTitle;
  final String? extraContentSubtitle;
  final bool showBottomBorder;
  final bool showExtraContent;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Colors.white,
        border: showBottomBorder
            ? Border(
          bottom: BorderSide(
            color: ColorResource.instance.dividerGrey
                .withValues(alpha: 0.5),
            width: 1,
          ),
        )
            : null,
      ),
      child: Row(
        children: [
          /// Avatar
          YRoundedContainer(
            backgroundColor:
            ColorResource.instance.socialButtonGreenColor,
            radius: 30,
            height: 40,
            width: 40,
            child: Center(
              child: Image.asset(
                icon ?? "",
                height: 18,
              ),
            ),
          ),

          Gap(DimensionResource.marginSizeSmall),

          /// Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: StyleResource.instance.styleMedium(
                    DimensionResource.fontSizeDefault,
                    ColorResource.instance.textColor_2,
                  ),
                ),
                Text(
                  subTitle,
                  style: StyleResource.instance.styleMedium(
                    DimensionResource.fontSizeDefault,
                    ColorResource.instance.textDarkGreenColor,
                  ),
                ),
              ],
            ),
          ),

          /// Age (Optional)
          if (showExtraContent && (extraContentSubtitle?.isEmpty??false))...[
            SizedBox(
              height: 30,
              child: VerticalDivider(
                color: ColorResource.instance.dividerGrey
                    .withValues(alpha: 0.5),
                width: 20,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  extraContentTitle??"",
                  style: StyleResource.instance.styleMedium(
                    DimensionResource.fontSizeDefault,
                    ColorResource.instance.textColor_2,
                  ),
                ),
                Text(
                  extraContentSubtitle??"",
                  style: StyleResource.instance.styleMedium(
                    DimensionResource.fontSizeDefault,
                    ColorResource.instance.textDarkGreenColor,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}


// class ProfileItem extends StatelessWidget {
//   final String title;
//   final String subtitle;
//
//   final bool showBottomBorder;
//
//   const ProfileItem({
//     super.key,
//     this.showBottomBorder = true, required this.title, required this.subtitle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: showBottomBorder
//             ? Border(
//           bottom: BorderSide(
//             color: ColorResource.instance.dividerGrey
//                 .withValues(alpha: 0.5),
//             width: 1,
//           ),
//         )
//             : null,
//       ),
//       child: Row(
//         children: [
//           YRoundedContainer(
//             backgroundColor:
//             ColorResource.instance.socialButtonGreenColor,
//             radius: 30,
//             height: 40,
//             width: 40,
//             child: Center(
//               child: Image.asset(
//                 ImageResource.instance.notificationBellOutlinedIcon,
//                 height: 18,
//               ),
//             ),
//           ),
//           Gap(DimensionResource.marginSizeSmall),
//           Expanded(
//             child: Text(
//               text,
//               style: StyleResource.instance.styleRegular(
//                 DimensionResource.fontSizeDefault,
//                 ColorResource.instance.textColor_2,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



