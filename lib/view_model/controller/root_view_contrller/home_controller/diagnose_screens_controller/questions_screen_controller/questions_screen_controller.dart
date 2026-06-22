import 'dart:io';

import 'package:flutter/material.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/diagnose_details_model.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/diagnose_questions_model.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/plant_detail_model.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/home_provider.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/network_calls/dio_client/get_it_instance.dart';
import 'package:plants_spotify/model/services/auth_service.dart';
import 'package:plants_spotify/model/utils/object_extension.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/diagnose_screens/image_too_blurry/image_too_blurry_screen.dart';
import 'package:plants_spotify/view/widgets/app_common/custom_popup/loader_popup.dart';
import 'package:plants_spotify/view/widgets/button_view/animated_box.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view/widgets/toast_view/showtoast.dart';
import 'package:dio/dio.dart' as form ;
import 'package:plants_spotify/view_model/routes/app_pages.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class QuestionsScreenController extends BaseViewController {

  HomeProvider homeProvider = getIt();
  RxList<SelectedMcq> selectedMcq = <SelectedMcq>[].obs;
  RxMap<String,dynamic> backScreenData =<String,dynamic>{}.obs;
  Rx<File> selectedImage = File("").obs;

  @override
  void onInit() async{
    super.onInit();
    backScreenData.value = Get.arguments??{};
    selectedImage.value = backScreenData["image"];
    await getDiagnosisQuestions();
  }
  final pageController = PageController();
  Rx<int> currentPageIndex =0.obs;

  void updtePageIndicator(index) => currentPageIndex.value = index;



  void dotNavigationClick(index){
    currentPageIndex.value=index;
    pageController.jumpTo(index);
  }
  void nextPage(){
    if(currentPageIndex.value ==  diagnoseQuestionsData.value.data.questions!.length - 1){
      ("selected questions : ${selectedMcq.map((item)=>"question :${item.questionId}  answer :${item.answerId}")}").logPrint();
      sendDiagnoseData();
    }else{
      int page = currentPageIndex.value + 1 ;
      pageController.animateToPage(currentPageIndex.value+1,  curve: Curves.linear, duration: const Duration(milliseconds: 500));
    }

  }
//update current index and  jump to the last page
  void skipPage(){
    // Get.find<AuthService>().box!.write(StringResource.instance.isFirst, true);
    // Get.toNamed(Routes.initialScreen);

  }


  /// get questions
  Rx<SingleResponse<DiagnoseQuestionsModel>> diagnoseQuestionsData = SingleResponse<DiagnoseQuestionsModel>(data: DiagnoseQuestionsModel()).obs;
  Future getDiagnosisQuestions()async {
    isLoading.value = true;
    try {
      await homeProvider.getDiagnosisQuestions(onError: (errorMessage) {
        
        isLoading.value = false;
        toastShow(message: errorMessage??"", error: true);
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        diagnoseQuestionsData.value = SingleResponse<DiagnoseQuestionsModel>.fromJson(data ?? {}, (data) => DiagnoseQuestionsModel.fromJson(data));
        isLoading.value = false;
      });
    } catch (e) {
      isLoading.value = false;
      ("error ${e.toString()}").logPrint();
    }
  }

  void onTapOption({required int questionId, required int answerId,}) {
    selectedMcq.removeWhere((item) => item.questionId == questionId,);
    selectedMcq.add(SelectedMcq(questionId: questionId, answerId: answerId,),);
    nextPage();
  }
  bool isOptionSelected({required int questionId, required int answerId,}) {
    return selectedMcq.any((item) => item.questionId == questionId && item.answerId == answerId,);
  }



  /// send diagnose Data
   void loadingPopup(controller) {
     WakelockPlus.enable();
      showAnimatedDialog(
          Get.context!,
          LoaderPopup(controller:  controller),
          dismissible: true,
          isFlip: true);
    }
    void dismissLoadingPopup() {
      WakelockPlus.disable();
        Get.back();
    }
  Rx<SingleResponse<DiagnoseDetailModel>> plantDiagnoseDetailData = SingleResponse<DiagnoseDetailModel>(data: DiagnoseDetailModel()).obs;
  Future sendDiagnoseData() async {
    loadingPopup(this);
    try {
      form.FormData addDiagnosisData = form.FormData.fromMap({
        "image": await form.MultipartFile.fromFile(selectedImage.value.path, filename: selectedImage.value.path.split('/').last,),
        "location": "${Get.find<AuthService>().userIp.value.city},${Get.find<AuthService>().userIp.value.regionName},${Get.find<AuthService>().userIp.value.country}",
      });
      for (int i = 0; i < selectedMcq.length; i++) {
        final mcq = selectedMcq[i];
        addDiagnosisData.fields.add(MapEntry("answers[$i][question_id]", mcq.questionId.toString()),);
        addDiagnosisData.fields.add(MapEntry("answers[$i][option_id]", mcq.answerId.toString()),);
      }
      await homeProvider.submitDiagnosisData(formData: addDiagnosisData,onError: (errorMessage) {
        
        dismissLoadingPopup();
        toastShow(message: errorMessage??"", error: true);
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        dismissLoadingPopup();

        if(data?['status']==true && data?['data']['error_type'] == "blurry"){
          Get.toNamed(Routes.imageTooBlurryScreen);
        }else if(data?['status']==true && data?['data']['error_type'] == "not_a_plant"){
          Get.toNamed(Routes.plantNotFoundScreen);
        }else if(data?['status']==true && data?['data']['error_type'] == "low_quality"){
          Get.toNamed(Routes.imageTooBlurryScreen);
        }else if(data?['status']==true && data?['data']['error_type'] == "unknown"){
          Get.toNamed(Routes.plantNotFoundScreen);
        }else{
          plantDiagnoseDetailData.value = SingleResponse<DiagnoseDetailModel>.fromJson(data ?? {}, (data) => DiagnoseDetailModel.fromJson(data));
          Get.offNamed(Routes.diagnosticsDetailScreen,arguments: {"type":1,"data":plantDiagnoseDetailData.value.data});
        }
      });
    } catch (e) {
      dismissLoadingPopup();
      ("error ${e.toString()}").logPrint();
    }
  }

}
class SelectedMcq {
  final int questionId;
  final int answerId;

  SelectedMcq({
    required this.questionId,
    required this.answerId,
  });



}
