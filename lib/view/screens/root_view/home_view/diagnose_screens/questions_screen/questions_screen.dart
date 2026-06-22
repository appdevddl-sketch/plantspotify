

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';

import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/widgets/button_view/yinkwell.dart';
import 'package:plants_spotify/view/widgets/containers/circular_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/shimmer_box/view_shimmers/ques_and_ans_shimmer.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/diagnose_screens_controller/questions_screen_controller/questions_screen_controller.dart';

import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/plant_index_controller/plant_index_controller.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';

class QuestionsScreen extends StatelessWidget {
  const QuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(viewControl: QuestionsScreenController(),
        appbarPerimeter: AppbarPerimeter(title: "answer_few_question".tr,titleColor: ColorResource.instance.black,centerTitle: true),
        bottomSafeArea: true,
        onPageBuilder: (BuildContext context,QuestionsScreenController controller)=>_buildMainView(context,controller));
  }
}

Widget _buildMainView(BuildContext context,QuestionsScreenController controller){
  return Obx((){
    if(controller.isLoading.value == false && (controller.diagnoseQuestionsData.value.data.questions?.isNotEmpty??false)){
      return buildView(context, controller);
    }else{
      return QuestionsShimmer();
    }
  });

}

Container buildView(BuildContext context, QuestionsScreenController controller) {
  return Container(
  padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
  child: Column(
    children: [
      YRoundedContainer(
        radius: 5,
        backgroundColor: ColorResource.instance.socialButtonGreenColor,
        padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.info_outline,size: 20,),
            Gap(DimensionResource.paddingSizeSmall),
            Flexible(child: Text("question_screen_title".tr,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmallTo, ColorResource.instance.black),))
          ],
        ),
      ).paddingOnly(bottom: DimensionResource.marginSizeExtraLarge),
      _buildCircles(context,controller).paddingOnly(bottom: DimensionResource.marginSizeExtraLarge),
      Expanded(
        child: PageView.builder(
          controller: controller.pageController,
          itemCount: controller.diagnoseQuestionsData.value.data.questions?.length,
          onPageChanged: controller.updtePageIndicator,
          itemBuilder: (context, pageIndex) {
            final question = controller.diagnoseQuestionsData.value.data.questions?[pageIndex];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question?.question??"",
                  style: StyleResource.instance.styleBold(
                    DimensionResource.fontSizeExtraLarge,
                    ColorResource.instance.black,
                  ),
                ).paddingOnly(bottom: DimensionResource.marginSizeDefault),

                Column(
                  children: List.generate(question?.options?.length ??0, (optionIndex) {
                    return Obx(() => _buildOptionTile(
                      onTap: () => controller.onTapOption(
                        questionId: question?.id??0,
                        answerId: question?.options?[optionIndex].id ??0,
                      ),
                      isSelected: controller.isOptionSelected(
                        questionId: question?.id??0,
                        answerId: question?.options?[optionIndex].id??0,
                      ),
                      optionIndex: optionIndex,
                      text: question?.options?[optionIndex].text ?? "",
                    )).paddingOnly(bottom: DimensionResource.marginSizeDefault);
                  }),
                ),
              ],
            );
          },
        ),
      ),
      YInkwell(onTap: ()=>controller.sendDiagnoseData(),child: Text("skip".tr,style: StyleResource.instance.styleMedium(DimensionResource.fontSizeDefault, ColorResource.instance.textColor_2),).paddingSymmetric(vertical: DimensionResource.paddingSizeDefault))
    ],
  ),
);
}
Widget _buildOptionTile({
  required int optionIndex,
  required String text,
  required VoidCallback onTap,
  bool isSelected = false,

}) {
  return YRoundedContainer(
    onTap: onTap,
    radius: 5,
    backgroundColor: isSelected ? ColorResource.instance.btnGreenColor : ColorResource.instance.white,
    padding: EdgeInsets.all(DimensionResource.marginSizeSmall),
    child: Row(
      children: [
        YRoundedContainer(
          height: 30,
          width: 30,
          radius: 40,
          backgroundColor: isSelected ? ColorResource.instance.white : ColorResource.instance.lightGrey.withValues(alpha: 0.2),
          child: Center(
            child: Text(
              String.fromCharCode(65 + optionIndex),
              style: StyleResource.instance.styleMedium(
                DimensionResource.fontSizeSmall,
                isSelected ?  ColorResource.instance.btnGreenColor : ColorResource.instance.textColor_2,
              ),
            ),
          ),
        ),
        Gap(DimensionResource.marginSizeSmall),
        Expanded(
          child: Text(
            text,
            style: StyleResource.instance.styleRegular(
              DimensionResource.fontSizeDefault,
              isSelected ? ColorResource.instance.white : ColorResource.instance.textColor_2,
            ),
          ),
        ),
      ],
    ),
  );
}




Widget _buildCircles(BuildContext context, QuestionsScreenController controller) {
  final questionCount = controller.diagnoseQuestionsData.value.data.questions?.length ?? 0;
  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(questionCount, (index) => _buildDot(index, context, controller, questionCount),
      ));
}
Widget _buildDot(int index, BuildContext context, QuestionsScreenController controller, int totalDots) {
  // Scale dot width based on number of questions so they fit the screen
  final availableWidth = MediaQuery.of(context).size.width - (DimensionResource.paddingSizeDefault * 2);
  final dotWidth = ((availableWidth - (totalDots * 10)) / totalDots).clamp(20.0, 70.0);
  return Obx(
        ()=> YCircularContainer(
        width: dotWidth,
        height: 4,
        margin: const EdgeInsets.only(right: 10),
        backgroundColor:controller.currentPageIndex.value == index ? ColorResource.instance.mainColor : ColorResource.instance.grey_3),
  );
}


