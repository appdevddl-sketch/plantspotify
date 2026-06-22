

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/font_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
import 'package:plants_spotify/view/widgets/common/dropdown_button_helper.dart' show DropdownButtonHelper;
import 'package:plants_spotify/view/widgets/common/helper.dart';
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


class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(viewControl: CompleteProfileController(),
        onPageBuilder: (BuildContext context,CompleteProfileController controller)=>_buildLoginView(context,controller));
  }
}

Widget _buildLoginView(BuildContext context,CompleteProfileController controller){
  return Container(
    height: HelperFunction.screenHeight(),
    width: HelperFunction.screenWidth(),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Positioned(top:0,child: Image.asset(ImageResource.instance.leaf4Image,height: 300,)),

        Positioned(right:0,bottom:0,child: Image.asset(ImageResource.instance.flowerLeaf,height: 200,)),
        YRoundedContainer(
          radius: 20,

          padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
          gradient: LinearGradient(
            colors: [ Color(0xff103303),  Color(0xff103303).withValues(alpha: 0.8)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),

          width: HelperFunction.screenWidth() * .90,
          height: HelperFunction.screenHeight() * .79,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("profile".tr,style: StyleResource.instance.styleBold(DimensionResource.fontSizeLarge,ColorResource.instance.white).copyWith(fontFamily: FontResource.instance.secondaryFont),).paddingOnly(bottom: DimensionResource.marginSizeSmall),
                Text("profile_title".tr,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeDefault,ColorResource.instance.white),).paddingOnly(bottom: DimensionResource.marginSizeSmall),
                LabelContainer(
                  label: 'name'.tr,
                  isRequired: true,
                  labelColor: ColorResource.instance.white,
                  child: CommonTextField(
            
                    controller: controller.nameController,
                    hintText: "enter_full_name".tr,
                    inputFormatters: InputFormattersResource.instance.nameInputFormatters,
                    keyboardType: TextInputType.name,
                    validator: (val)=>val?.isValidNameValidation(onError:(error)=>controller.nameError.value =error),
                    errorText: controller.nameError.value,
                  ),
                  
                ).paddingOnly(bottom: DimensionResource.marginSizeSmall),
                LabelContainer(
                  label: 'age'.tr,
                  isRequired: true,
                  labelColor: ColorResource.instance.white,
                  child: CommonTextField(
                    controller: controller.nameController,
                    hintText: "enter_age".tr,
                    inputFormatters: InputFormattersResource.instance.nameInputFormatters,
                    keyboardType: TextInputType.name,
                    validator: (val)=>val?.isValidNameValidation(onError:(error)=>controller.nameError.value =error),
                    errorText: controller.nameError.value,
                  ),
                ).paddingOnly(bottom: DimensionResource.marginSizeSmall),
                // LabelContainer(
                //   label: 'type_of_home_living'.tr,
                //   isRequired: true,
                //   labelColor: ColorResource.instance.white,
                //   child:  Obx(()=>DropdownButtonHelper<String>(
                //     borderColor: ColorResource.instance.borderColor,
                //     hintText: controller.selectTypeValue.value==''?"select_home_type".tr:controller.selectTypeValue.value.tr??"",
                //     valueSelectedOrNot: controller.selectTypeValue.value!='',
                //     itemList:controller.typeList.obs,
                //     itemView: (String value)=>controller.selectTypeValue.value == value ? "✓ ${value.tr}" : value.tr??"",
                //     onValueChanged:(String value){ controller.selectTypeValue.value = value;},
                //   )),
                // ).paddingOnly(bottom: DimensionResource.marginSizeSmall),
                LabelContainer(
                  label: 'location'.tr,
                  isRequired: true,
                  labelColor: ColorResource.instance.white,
                  child: CommonTextField(
                    controller: controller.nameController,
                    hintText: "enter_your_location".tr,
                    inputFormatters: InputFormattersResource.instance.nameInputFormatters,
                    keyboardType: TextInputType.name,
                    validator: (val)=>val?.isValidNameValidation(onError:(error)=>controller.nameError.value =error),
                    errorText: controller.nameError.value,
                  ),
            
                ).paddingOnly(bottom: DimensionResource.marginSizeLarge),
                CommonButton(text: "submit".tr, loading: controller.isLoading.value, onPressed: ()=>Get.toNamed(Routes.rootView))
              ],
            
            ),
          ),
        )
      ],
    ),
  );
}







