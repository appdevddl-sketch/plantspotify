

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/font_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/input_formatters_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
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
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/create_collection_screen/create_collection_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/home_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/plant_index_controller/plant_index_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/tending_screen/trending_screen_controller.dart';




class CreateCollectionScreen extends StatelessWidget {
  const CreateCollectionScreen
      ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(viewControl: CreateCollectionController(),
        backgroundColor: ColorResource.instance.white,
        appbarPerimeter: AppbarPerimeter(title: "create_collection".tr,titleColor: ColorResource.instance.black,centerTitle: true),
        onPageBuilder: (BuildContext context,CreateCollectionController controller)=>_buildMainView(context,controller));
  }
}

Widget _buildMainView(BuildContext context,CreateCollectionController controller){
  return Padding(
    padding: EdgeInsets.all(DimensionResource.marginSizeDefault),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(ImageResource.instance.plant1Image,width: HelperFunction.screenWidth(),).paddingOnly(bottom: DimensionResource.paddingSizeDefault),
          Form(
            key: controller.createCollectionFormKey,
            child: LabelContainer(
              label: 'collection_name'.tr,
              child: CommonTextField(
                controller: controller.collectionNameController,
                hintText: "enter_collection_name".tr,
                inputFormatters: InputFormattersResource.instance.numberAndIntegerFormatters,
                keyboardType: TextInputType.name,
                validator: (val)=>val?.isValidNameValidation(onError:(error)=>controller.collectionNameError.value =error,name: "collection_name".tr),
                errorText: controller.collectionNameError.value,
              ).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
            ).paddingOnly(bottom: DimensionResource.paddingSizeDefault),
          ),

          CommonButton(text: "save".tr, loading: controller.isLoading.value, onPressed: ()=>controller.createCollection())

        ],
      ),
    ),
  );

}






