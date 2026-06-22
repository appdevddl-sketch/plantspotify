//
//
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:get/get_utils/src/extensions/internacionalization.dart';
// import 'package:plants_spotify/model/utils/color_resource.dart';
// import 'package:plants_spotify/model/utils/decoration_resource.dart';
// import 'package:plants_spotify/model/utils/dimensions_resource.dart';
// import 'package:plants_spotify/model/utils/font_resource.dart';
// import 'package:plants_spotify/model/utils/image_resource.dart';
// import 'package:plants_spotify/model/utils/style_resource.dart';
// import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
//
// import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
// import 'package:plants_spotify/view/widgets/common/dropdown_button_helper.dart' show DropdownButtonHelper;
// import 'package:plants_spotify/view/widgets/common/helper.dart';
// import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
// import 'package:plants_spotify/view/widgets/text_field_view/common_textfield.dart' show CommonTextField;
// import 'package:plants_spotify/view/widgets/text_field_view/lable_container.dart';
// import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
// import 'package:plants_spotify/view_model/controller/root_view_contrller/account_view_controller/contact_us_controller/contact_us_controller.dart';
// import 'package:plants_spotify/view_model/controller/root_view_contrller/account_view_controller/help_controller/help_controller.dart';
// import 'package:plants_spotify/view_model/controller/root_view_contrller/account_view_controller/rating_controller/rating_controller.dart';
//
// import '../../../../../model/utils/input_formatters_resource.dart';
// import 'package:custom_rating_bar/custom_rating_bar.dart';
//
//
// class RatingScreen extends StatelessWidget {
//   const RatingScreen
//       ({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BaseView(viewControl: RatingController(),
//
//         onPageBuilder: (BuildContext context,RatingController controller)=>_buildMainView(context,controller));
//   }
// }
//
// Widget _buildMainView(BuildContext context,RatingController controller){
//   return YRoundedContainer(
//     radius: 0,
//     width: HelperFunction.screenWidth(),
//     height: HelperFunction.screenHeight(),
//     child: Stack(
//       alignment: Alignment.center,
//       children: [
//         Image.asset(ImageResource.instance.leafTransparentVertical,height: HelperFunction.screenHeight(),width: HelperFunction.screenWidth(),fit: BoxFit.cover,),
//         YRoundedContainer(
//           radius: 0,
//           height: HelperFunction.screenHeight(),
//           width: HelperFunction.screenWidth(),
//           backgroundColor: ColorResource.instance.bgGreen.withValues(alpha: 0.6),
//         ),
//         Positioned(
//           top: 0,
//           child: Column(
//             children: [
//               Platform.isIOS ? Gap(DimensionResource.defaultIos) : Gap(DimensionResource.defaultTop),
//               Container(
//                 height: DimensionResource.appBarHeight,
//                 width: HelperFunction.screenWidth(),
//                 padding: EdgeInsets.symmetric(
//                   horizontal: DimensionResource.paddingSizeDefault,
//                 ),
//                 child: Row(
//                   children: [
//
//                     GestureDetector(
//                       onTap: () => Get.back(),
//                       child: Container(
//                         height: 35,
//                         width: 35,
//                         padding: const EdgeInsets.all(
//                           DimensionResource.marginSizeSmall,
//                         ),
//                         decoration: BoxDecoration(
//                           color: ColorResource.instance.white,
//                           borderRadius: BorderRadius.circular(25),
//                           boxShadow: DecorationResource.instance
//                               .containerBoxShadow(ColorResource.instance.grey),
//                         ),
//                         child: Image.asset(
//                           ImageResource.instance.backArrowIcon,
//                           height: 11,
//                           color: ColorResource.instance.textDarkGreenColor,
//                         ),
//                       ),
//                     ),
//
//                     // Center Title
//                     Expanded(
//                       child: Center(
//                         child: Text(
//                           "Rating".tr,
//                           style: StyleResource.instance.styleSemiBold(
//                             DimensionResource.fontSizeLarge,
//                             ColorResource.instance.white,
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     // Right spacer (balances back button)
//                     const SizedBox(width: 35),
//                   ],
//                 ),
//               ),
//               Gap(DimensionResource.marginSizeDefault * 2),
//               ClipRRect(
//                 borderRadius: BorderRadius.all(Radius.circular(10)),
//                 child: YRoundedContainer(
//                   radius: 10,
//                   height: HelperFunction.screenHeight() * .70,
//                   width: HelperFunction.screenWidth() * .90,
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Positioned(top:0,right:0,child: Image.asset(ImageResource.instance.leaf13,width: HelperFunction.screenWidth() * .60,)),
//                       Positioned(bottom:0,left:0,child: Image.asset(ImageResource.instance.leaf12,width: HelperFunction.screenWidth() * .70,)),
//                       Positioned(top: HelperFunction.screenHeight() * .02,left: 0,right:0,child: SingleChildScrollView(
//                         child: Padding(
//                           padding: const EdgeInsets.all(DimensionResource.paddingSizeDefault),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Image.asset(ImageResource.instance.appLogo2Image,height: 150,),
//                               YRoundedContainer(
//
//                                 width: double.infinity,
//                                 padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
//                                 backgroundColor: ColorResource.instance.socialButtonGreenColor,
//                                 showBorder: true,
//                                 borderColor: ColorResource.instance.btnGreenBorderColor,
//                                 boxshadow: DecorationResource.instance.containerBoxShadow(),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text("rate_us".tr,style: StyleResource.instance.styleMedium(DimensionResource.fontSizeSmall, ColorResource.instance.textDarkGreenColor),).paddingOnly(bottom: DimensionResource.marginSizeExtraSmall),
//                                     RatingBar(
//                                       size: 25,
//                                       filledColor: ColorResource.instance.btnGreenColor,
//                                       filledIcon: Icons.star,
//                                       emptyIcon: Icons.star,
//                                       onRatingChanged: (value) {
//                                         // controller.reviewCount.value=value;
//                                         // controller.reviewCount.value.logPrint(message: "rating => ");
//                                       },
//                                       initialRating: 2,
//                                       maxRating: 5,
//                                     ),
//                                   ],
//                                 ),
//                               ).paddingOnly(bottom: DimensionResource.marginSizeExtraSmall),
//
//                               LabelContainer(
//                                 label: "your_review".tr,
//                                 child: CommonTextField(
//                                   minLines: 4,
//                                   maxLines: 6,
//                                   maxLength: 500,
//                                   height: 120,
//                                   controller: controller.feedbackController,
//                                   hintText: "write_your_feedback".tr,
//                                   inputFormatters: InputFormattersResource.instance.nameInputFormatters,
//                                   keyboardType: TextInputType.name,
//                                   validator: (val)=>val?.isValidNameValidation(onError:(error)=>controller.feedbackError.value =error),
//                                   errorText: controller.feedbackError.value,
//                                 ),
//                               ).paddingOnly(bottom: DimensionResource.paddingSizeDefault),
//                               CommonButton(text: "submit".tr, loading: controller.isLoading.value, onPressed: (){},textSize: DimensionResource.fontSizeDefault,)
//
//                             ],
//                           ),
//                         ),
//                       )),
//
//
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//
//
//
//
//       ],
//     ),
//   );
//
// }
