

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/model/auth_model/country_model.dart';
import 'package:plants_spotify/model/model/auth_model/login_user_model.dart';
import 'package:plants_spotify/model/services/auth_service.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
import 'package:plants_spotify/view/widgets/cached_network_image_widget/cachednetworkimagewidget.dart';
import 'package:plants_spotify/view/widgets/common/dropdown_button_helper.dart' show DropdownButtonHelper, DropdownButtonHelperWithSearch;
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/common/profile_image_widget.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/loader_helper/loader_helper_ui.dart';
import 'package:plants_spotify/view/widgets/text_field_view/common_textfield.dart' show CommonTextField;
import 'package:plants_spotify/view/widgets/text_field_view/lable_container.dart';
import 'package:plants_spotify/view_model/controller/auth_controllers/complete_profile_controller.dart';
import 'package:plants_spotify/view_model/controller/auth_controllers/edit_profile_controller.dart';
import 'package:plants_spotify/view_model/controller/auth_controllers/profile_controller.dart';
import 'package:plants_spotify/view_model/controller/auth_controllers/social_signIn_controller.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';

import '../../../../../model/utils/input_formatters_resource.dart';
import '../../../../widgets/text_field_view/regex/regex.dart';
import '../../../base_view/base_view_screen.dart';


class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<EditProfileController>(
      viewControl: EditProfileController(),
      customAppbar: (context, controller) => _buildAppBar(context, controller, "edit_profile".tr),
      resizeToAvoidBottomInset: false,
      onPageBuilder: (context, controller) => _buildMainView(context, controller),
    );
  }
}


Widget _buildMainView(BuildContext context,EditProfileController controller){
  return Obx((){
    if(controller.isHomeTypeLoading.value == false && controller.isCountriesLoading.value == false){
      return SizedBox(
        height: HelperFunction.screenHeight(),
        width: HelperFunction.screenWidth(),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(bottom: 0,left: 0,child: Image.asset(ImageResource.instance.leaf11Image,width: HelperFunction.screenWidth() * .50,)),
            Form(
              key: controller.formKey,
              child: ListView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeDefault),
                children: [
                  const SizedBox(height: DimensionResource.marginSizeExtraLarge),
                  _buildProfilePicBox(controller).paddingOnly(bottom: DimensionResource.paddingSizeDefault),
                  LabelContainer(
                    isRequired: true,
                    label: 'name'.tr,
                    child: CommonTextField(
                      controller: controller.nameController,
                      hintText: "enter_name".tr,
                      inputFormatters: InputFormattersResource.instance.nameInputFormatters,
                      keyboardType: TextInputType.name,
                      validator: (val)=>val?.isValidUserNameValidation(onError:(error)=>controller.nameError.value =error),
                      errorText: controller.nameError.value,
                    ),
                  ).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
                  LabelContainer(
                    isRequired: true,

                    label: 'age'.tr,
                    child: CommonTextField(
                      controller: controller.ageController,
                      hintText: "enter_age".tr,
                      inputFormatters: InputFormattersResource.instance.numberInputFormatters,
                      keyboardType: TextInputType.number,
                      validator: (val)=>val?.isValidNameValidation(onError:(error)=>controller.ageError.value =error,name: "age"),
                      errorText: controller.ageError.value,
                    ),
                  ).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
                  ErrorContainer(
                    errorText: controller.homeTypeError.value,
                    child: LabelContainer(
                      label: 'type_of_home_living'.tr,
                      isRequired: true,
                      child:  Obx(()=>DropdownButtonHelper<HomeType>(
                        borderColor: ColorResource.instance.borderColor,
                        hintText: controller.selectedHomeTypeValue.value.id == null ? "select_home_type".tr:controller.selectedHomeTypeValue.value.name??"",
                        valueSelectedOrNot: controller.selectedHomeTypeValue.value.id != null,
                        itemList:controller.typeList,
                        itemView: (HomeType value)=>controller.selectedHomeTypeValue.value.id == value.id ? "✓ ${value.name}" : value.name ??"",
                        onValueChanged:(HomeType value){  controller.homeTypeError.value = ""; controller.selectedHomeTypeValue.value = value;},
                      )),
                    ),
                  ).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
                  ErrorContainer(
                    errorText: controller.countryError.value,
                    child: LabelContainer(
                      label: 'country'.tr,
                      isRequired: true,
                      child:  Obx(()=>DropdownButtonHelperWithSearch<CountryData>(
                        borderColor: ColorResource.instance.borderColor,
                        hintText: controller.selectedCountry.value.name?.isEmpty??true?"select_country".tr:controller.selectedCountry.value.name??"",
                        valueSelectedOrNot: controller.selectedCountry.value.name != null,

                        itemList:(controller.countriesData.value.data.data??<CountryData>[]).obs,
                        itemView: (CountryData value)=>controller.selectedCountry.value.id == value.id ? "✓ ${value.name}" : value.name ??"",
                        onValueChanged:(CountryData value){ controller.countryError.value = ""; controller.selectedCountry.value = value;},
                      )),
                    ),
                  ).paddingOnly(bottom: DimensionResource.paddingSizeSmall),

                  const Gap(DimensionResource.marginSizeExtraLarge,),
                  Obx(()=> CommonButton(margin: const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeDefault),text: "save".tr,color:ColorResource.instance.btnGreenColor,onPressed:()=>controller.updateProfile(),loading: controller.isLoading.value,),),
                ],
              ),
            )
          ],

        ),
      );
    }else{
      return loaderHelperUi();
    }
  });


}
AppBar _buildAppBar(
    BuildContext context,
    EditProfileController controller,
    String title,
    ) {
  return AppBar(
    centerTitle: true,
    elevation: 0,
    toolbarHeight: DimensionResource.appBarHeight,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,

    flexibleSpace: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            ImageResource.instance.leafTransparentImage,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: ColorResource.instance.transparent,
        ),
        padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => Get.back(),
              child: Container(
                height: 35,
                width: 35,
                padding: const EdgeInsets.all(
                  DimensionResource.marginSizeSmall,
                ),
                decoration: BoxDecoration(
                  color: ColorResource.instance.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: DecorationResource.instance
                      .containerBoxShadow(ColorResource.instance.grey),
                ),
                child: Image.asset(
                  ImageResource.instance.backArrowIcon,
                  height: 11,
                  color: ColorResource.instance.black,
                ),
              ),
            ),

            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: StyleResource.instance.styleSemiBold(
                    DimensionResource.fontSizeDefault,
                    ColorResource.instance.textDarkGreenColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            const SizedBox(height: 35, width: 35),
          ],
        ),
      ),
    ),
  );
}


Widget _buildProfilePicBox(EditProfileController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(
        height: 80,
        width: 80,
        child: Stack(
          children: [
            Hero(
              tag: "image",
              child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                  ),
                  child:  ClipOval(
                      child:CachedNetworkImageWidget(imageUrl:"",fit: BoxFit.fill,errorWidget: CircleAvatar(
                          radius: 25,
                          backgroundColor:ColorResource.instance.orangeGradientColor1,
                          child: Text(
                            HelperFunction.getName(),
                            style: StyleResource.instance.styleSemiBold(
                              25,
                              Colors.white,
                            ),
                          )
                      ))),
                )

            ),
            // Positioned(
            //   bottom: 5,
            //   right: 0,
            //   child: InkWell(
            //     onTap: () {},
            //     child: YRoundedContainer(
            //       height: 30,
            //       width: 30,
            //       backgroundColor: ColorResource.instance.btnGreenColor,
            //       padding: EdgeInsets.all(DimensionResource.marginSizeSmall),
            //       radius: 30,
            //       child: Image.asset(ImageResource.instance.editPenIcon,),
            //     )
            //   ),
            // )
          ],
        ),
      ),
      Visibility(
          visible: controller.profileImageError.value != "",
          child: Padding(
            padding: const EdgeInsets.only(top: DimensionResource.marginSizeSmall),
            child: Text(
              controller.profileImageError.value,
              style: StyleResource.instance.styleRegular(
                  DimensionResource.fontSizeDefault,
                  ColorResource.instance.darkRedColor),
            ),
          )),
    ],
  );
}
