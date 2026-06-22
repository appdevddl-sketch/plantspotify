

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/screens/on_board/on_board_screen.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
import 'package:plants_spotify/view/widgets/button_view/yinkwell.dart';
import 'package:plants_spotify/view/widgets/common/dropdown_button_helper.dart' show DropdownButtonHelper;
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/text_field_view/common_textfield.dart' show CommonTextField;
import 'package:plants_spotify/view/widgets/text_field_view/lable_container.dart';
import 'package:plants_spotify/view_model/controller/auth_controllers/profile_controller.dart';
import 'package:plants_spotify/view_model/controller/auth_controllers/social_signIn_controller.dart';
import 'package:plants_spotify/view_model/controller/initial_controller/splash_screen_controller.dart' show SplashScreenController;
import 'package:plants_spotify/view_model/routes/app_pages.dart';

import '../../../../model/utils/input_formatters_resource.dart';



class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(viewControl: SplashScreenController(),
        bottomSafeArea: false,
        onPageBuilder: (BuildContext context,SplashScreenController controller)=>_buildLoginView(context,controller));
  }
}

Widget _buildLoginView(BuildContext context,SplashScreenController controller){
  return YInkwell(
    onTap: ()=>Get.toNamed(Routes.onBoardScreen),
    child: SizedBox(
      height: HelperFunction.screenHeight(),
      width: HelperFunction.screenWidth(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(top:0,right:0,child: Image.asset(ImageResource.instance.leafImage,height: 200,)),
          Image.asset(ImageResource.instance.appLogo3Image,width: 270,height: 270,),
          Positioned(bottom:0,right:0,child: Image.asset(ImageResource.instance.leaf6Image,height: 100,)),
          Positioned(bottom:0,left: 0,child: Image.asset(ImageResource.instance.leaf5Image)),

        ],
      )
    ),
  );
}







