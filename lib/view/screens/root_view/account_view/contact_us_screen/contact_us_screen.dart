

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/font_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/home_view_screen.dart';
import 'package:plants_spotify/view/widgets/app_common/app_heading/app_heading.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
import 'package:plants_spotify/view/widgets/common/dropdown_button_helper.dart' show DropdownButtonHelper;
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_image.dart';
import 'package:plants_spotify/view/widgets/layout/grid_layout.dart';
import 'package:plants_spotify/view/widgets/layout/list_view_layout.dart';
import 'package:plants_spotify/view/widgets/sliders/horizontal_slider.dart';
import 'package:plants_spotify/view/widgets/text_field_view/common_textfield.dart' show CommonTextField;
import 'package:plants_spotify/view/widgets/text_field_view/lable_container.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view_model/controller/auth_controllers/profile_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/account_view_controller/contact_us_controller/contact_us_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/articles_controller/articles_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/home_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/plant_index_controller/plant_index_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/scan_history/scan_history_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/tending_screen/trending_screen_controller.dart';

import '../../../../../model/utils/input_formatters_resource.dart';



class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen
      ({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(viewControl: ContactUsController(),
        resizeToAvoidBottomInset: false,
        appbarPerimeter: AppbarPerimeter(title: "contact_us".tr,centerTitle: true,appBarBackGroundColor: ColorResource.instance.grey_1),
        onPageBuilder: (BuildContext context,ContactUsController controller)=>_buildMainView(context,controller));
  }
}

Widget _buildMainView(BuildContext context,ContactUsController controller){
  return Stack(
    alignment: Alignment.center,
    children: [
      Positioned(bottom: 0,left: 0,child: Image.asset(ImageResource.instance.leaf11Image,width: HelperFunction.screenWidth() * .50,)),
      Obx(
      ()=> Form(
          key: controller.contactUsFormKey,
          child: ListView(
            padding: const EdgeInsets.only(top: DimensionResource.marginSizeDefault,left: DimensionResource.marginSizeDefault,right: DimensionResource.marginSizeDefault),
            children:[
              Text("If you are experiencing any issues, please. let us know. We will try to solve them as soon as possible.",style: StyleResource.instance.styleMedium(DimensionResource.fontSizeSmall, ColorResource.instance.textDarkGreenColor2),).paddingOnly(bottom: DimensionResource.marginSizeDefault),
              LabelContainer(
                isRequired: true,
                label: 'name'.tr,
                child: CommonTextField(
                  controller: controller.nameController,
                  hintText: "enter_name".tr,
                  inputFormatters: InputFormattersResource.instance.nameInputFormatters,
                  keyboardType: TextInputType.name,
                  validator: (val)=>val?.isValidNameValidation(onError:(error)=>controller.nameError.value =error,name: "name"),
                  errorText: controller.nameError.value,
                ),
              ).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
              LabelContainer(
                label: 'email'.tr,
                isRequired: true,
                child: CommonTextField(
                  controller: controller.emailController,
                  hintText: "mail_id".tr,
                  inputFormatters: InputFormattersResource.instance.emailInputFormatters,
                  keyboardType: TextInputType.name,
                  validator: (val)=>val?.isValidEmailValidation(onError:(error)=>controller.emailError.value =error,),
                  errorText: controller.emailError.value,
                ),
              ).paddingOnly(bottom: DimensionResource.paddingSizeSmall),

              LabelContainer(
                isRequired: true,
                label: "explain_the_problem".tr,
                child: CommonTextField(
                  minLines: 4,
                  maxLines: 6,
                  maxLength: 500,
                  height: 120,
                  controller: controller.explainController,
                  hintText: "type_your_problem_here".tr,
                  inputFormatters: InputFormattersResource.instance.nameInputFormatters,
                  keyboardType: TextInputType.name,
                  validator: (val)=>val?.isValidNoteValidation(onError:(error)=>controller.explainError.value =error,name: "context".tr),
                  errorText: controller.explainError.value,
                ),
              ).paddingOnly(bottom: DimensionResource.paddingSizeDefault),
              CommonButton(text: "submit".tr, loading: controller.isLoading.value, onPressed: ()=>controller.submitForm(),textSize: DimensionResource.fontSizeDefault,)


            ]


          ),
        ),
      ),
    ],
  );

}





