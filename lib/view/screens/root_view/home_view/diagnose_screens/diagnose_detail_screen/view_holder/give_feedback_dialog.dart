import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/feedback_questions-model.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/input_formatters_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/button_holders.dart';
import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
import 'package:plants_spotify/view/widgets/button_view/payment_details_dialog.dart';
import 'package:plants_spotify/view/widgets/common/custome_redio_button.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/text_field_view/common_textfield.dart';
import 'package:plants_spotify/view/widgets/text_field_view/lable_container.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';



class feedbackPopup extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final Rx<ListResponse<FeedbackQuestionstModel>> feedbackQuestions;
  final bool Function({required int questionId, required int answerId}) isOptionSelected;
  final void Function({required int questionId, required int answerId}) onTapOption;


  const feedbackPopup({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    required this.feedbackQuestions,
    required this.isOptionSelected,
    required this.onTapOption,
  });

  @override
  Widget build(BuildContext context) {
    return PopupDialog(
        child: YRoundedContainer(
          padding: EdgeInsets.all(DimensionResource.marginSizeDefault),
          height: 425,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Expanded(child: Center(child: Text("feedback".tr,style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeDefault, ColorResource.instance.black),))),
                    InkWell(onTap: Get.back,child: Image.asset(ImageResource.instance.closeOutlinedIcon,height: 18,))
                  ],
                ),
                Image.asset(ImageResource.instance.feedbackDialogImage,height: 150,),
                Container(
                  padding: EdgeInsets.all(DimensionResource.marginSizeDefault),
                  child: Column(
                    children: [
                      ...List.generate(feedbackQuestions.value.data.length, (questionIndex){
                        return Obx(
                          ()=> feedbackQuestionsWidget(
                           question: feedbackQuestions.value.data[questionIndex].question??"",
                            isSelectedFalse: isOptionSelected(questionId: feedbackQuestions.value.data[questionIndex].id ?? 0, answerId: 0),
                            isSelectedTrue: isOptionSelected(questionId: feedbackQuestions.value.data[questionIndex].id ?? 0, answerId: 1),
                            onTapYes: ()=> onTapOption(questionId: feedbackQuestions.value.data[questionIndex].id ?? 0, answerId: 1),
                            onTapNo:  ()=> onTapOption(questionId: feedbackQuestions.value.data[questionIndex].id ?? 0, answerId: 0),
                          ),
                        );

                      }),
                      CommonButton(text: "submit".tr, loading: false, onPressed: onConfirm,height: 40,color: ColorResource.instance.btnGreenColor,textSize: DimensionResource.fontSizeSmall,).paddingOnly(bottom: DimensionResource.marginSizeSmall),
                    ],
                  ),
                ),

              ],

            ),
          ),

        )
    );
  }
}

class feedbackQuestionsWidget extends StatelessWidget {
  const feedbackQuestionsWidget({
    super.key, this.isSelectedTrue = false, required this.question,this.isSelectedFalse  = false, required this.onTapYes, required this.onTapNo,
  });
  final bool isSelectedTrue;
  final bool isSelectedFalse;
  final String question;
  final VoidCallback onTapYes;
  final VoidCallback onTapNo;



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(question,style: StyleResource.instance.styleMedium(DimensionResource.fontSizeSmall, ColorResource.instance.grey_5),),
        Row(
          children: [
            Expanded(child: buildRadioTileUi(value: isSelectedTrue, onTap: onTapYes, title: 'yes'.tr)),
            Expanded(child: buildRadioTileUi(value: isSelectedFalse, onTap: onTapNo, title: 'no'.tr)),
          ],
        )
      ],
    );
  }
}

Widget buildRadioTileUi({required bool value,required VoidCallback onTap ,required String title}){
  return MaterialButton(
    padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 2),
    splashColor: ColorResource.instance.transparent,
    onPressed: onTap,
    child: Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomRadioButton(value: value, onTap: onTap,height: 15,width: 15,),
        const Gap(DimensionResource.marginSizeSmall,),
        Text(title.tr,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.grey_5),)
      ],
    ),
  );
}
