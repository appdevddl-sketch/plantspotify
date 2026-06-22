
import 'package:plants_spotify/model/model/root_view_models/home_view_models/diagnose_details_model.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/feedback_questions-model.dart';
import 'package:plants_spotify/model/model/root_view_models/nursery_models/collection_model.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/home_provider.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/nursery_provider.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/network_calls/dio_client/get_it_instance.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/diagnose_screens/diagnose_detail_screen/view_holder/give_feedback_dialog.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/save_plants_bottomsheet.dart';
import 'package:plants_spotify/view/widgets/button_view/animated_box.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:dio/dio.dart' as form ;
import 'package:plants_spotify/view/widgets/toast_view/showtoast.dart';
import 'package:flutter/material.dart';


class DiagnoseDetailController extends BaseViewController with GetSingleTickerProviderStateMixin {
  HomeProvider homeProvider = getIt();
  NurseryProvider nurseryProvider = getIt();
  RxString commonName = "".obs;

  Rx<DiagnoseDetailModel>  diagnoseData = DiagnoseDetailModel().obs;
  RxList<String>  diagnoseBanner = <String>[].obs;
  RxBool isFeedback = false.obs;
  RxBool isDataEmpty = false.obs;

  /// Tab management
  late TabController pageController;
  RxString selectCategory = "basic_information".obs;
  RxInt selectCategoryIndex = 0.obs;
  late List<Map<String, dynamic>> orderCategory;

  /// one key per tab – used to auto-scroll the tab bar to the active tab
  late List<GlobalKey> tabKeys;

  void _scrollTabToVisible(int index) {
    if (index < tabKeys.length) {
      final ctx = tabKeys[index].currentContext;
      if (ctx != null) {
        final RenderObject? renderObject = ctx.findRenderObject();
        if (renderObject == null) return;
        final ScrollableState? scrollable = Scrollable.maybeOf(ctx);
        if (scrollable != null) {
          scrollable.position.ensureVisible(
            renderObject,
            alignment: 0.5,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      }
    }
  }


  @override
  void onInit() {
    super.onInit();
    diagnoseData.value = Get.arguments["data"];

    if (diagnoseData.value.plantDetails == null) {
      isDataEmpty.value = true;
      orderCategory = [];
      tabKeys = [];
      pageController = TabController(length: 0, vsync: this);
      return;
    }

    commonName.value = diagnoseData.value.plantDetails?.commonName ?? "diagnostics_result".tr;
    diagnoseBanner.add(diagnoseData.value.image ?? "");
    diagnoseBanner.addAll(diagnoseData.value.plantDetails?.images?.map((e) => e.url).whereType<String>().toList() ?? []);
    isFeedback.value = diagnoseData.value.isFeedback ?? false;

    final bool isHealthy = (diagnoseData.value.overallHealthScore ?? 0) >= 9;

    if (isHealthy) {
      orderCategory = [
        {"image": ImageResource.instance.plantDetailIcon,    "title": "basic_information".tr},
        {"image": ImageResource.instance.moreDetailIcon,     "title": "other_details".tr},
        {"image": ImageResource.instance.galleryIcon,          "title": "Gallery"},
        {"image": ImageResource.instance.settingDetailIcon,  "title": "flower_details".tr},
        {"image": ImageResource.instance.flowerDetailIcon,   "title": "fruit_details".tr},
        {"image": ImageResource.instance.toxicityDetailIcon, "title": "toxicity_information".tr},
        {"image": ImageResource.instance.careDetailIcon,     "title": "care_conditions".tr},
        {"image": ImageResource.instance.usesDetailIcon,     "title": "uses".tr},
        {"image": ImageResource.instance.plantDetailIcon,    "title": "geo_location".tr},

      ];
    } else {
      orderCategory = [
        {"image": ImageResource.instance.plantDetailIcon,    "title": "basic_information".tr},
        {"image": ImageResource.instance.symptomsIcon,       "title": "symptoms".tr},
        {"image": ImageResource.instance.plantDiagnosisIcon, "title": "plant_diagnostics".tr},
        {"image": ImageResource.instance.solutionsIcon,      "title": "solutions".tr},
        {"image": ImageResource.instance.preventionIcon,     "title": "prevention".tr},
        {"image": ImageResource.instance.moreDetailIcon,     "title": "other_details".tr},
        {"image": ImageResource.instance.galleryIcon,          "title": "Gallery"},
        {"image": ImageResource.instance.settingDetailIcon,  "title": "flower_details".tr},
        {"image": ImageResource.instance.flowerDetailIcon,   "title": "fruit_details".tr},
        {"image": ImageResource.instance.toxicityDetailIcon, "title": "toxicity_information".tr},
        {"image": ImageResource.instance.careDetailIcon,     "title": "care_conditions".tr},
        {"image": ImageResource.instance.usesDetailIcon,     "title": "uses".tr},
        {"image": ImageResource.instance.plantDetailIcon,    "title": "geo_location".tr},
      ];
    }

    selectCategory.value = orderCategory[0]["title"];
    tabKeys = List.generate(orderCategory.length, (_) => GlobalKey());
    pageController = TabController(initialIndex: 0, vsync: this, length: orderCategory.length);

    /// Sync tab highlight on swipe
    pageController.animation?.addListener(() {
      double val = pageController.animation!.value;
      int newIndex = val.round();

      if (!pageController.indexIsChanging) {
        if (newIndex != selectCategoryIndex.value) {
          selectCategoryIndex.value = newIndex;
          if (newIndex < orderCategory.length) {
            selectCategory.value = orderCategory[newIndex]["title"];
          }
          _scrollTabToVisible(newIndex);
        }
      }
    });

    /// Handle immediate highlight update on tap
    pageController.addListener(() {
      if (pageController.indexIsChanging) {
        if (selectCategoryIndex.value != pageController.index) {
          selectCategoryIndex.value = pageController.index;
          if (pageController.index < orderCategory.length) {
            selectCategory.value = orderCategory[pageController.index]["title"];
          }
          _scrollTabToVisible(pageController.index);
        }
      }
    });

    getFeedBackQuestions();
  }


  void onChangeButtonTapped(int index) {
    selectCategory.value = orderCategory[index]["title"];
    selectCategoryIndex.value = index;
    pageController.index = index;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollTabToVisible(index));
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void showFeedbackPopup() {
    showAnimatedDialog(
        Get.context!,
        feedbackPopup(
            onConfirm:() async {
              if(selectedFeedback.length == feedbackQuestions.value.data.length){
                await submitFeedBackQuestions();
                Get.back();
              }else{
                toastShow(message: "please_select_all_answers".tr, error: true);
              }
            }, onCancel: () {
          Get.back();
        },
        feedbackQuestions: feedbackQuestions,
        isOptionSelected: isOptionSelected,
        onTapOption: onTapOption,
        ),
        dismissible: false,
        isFlip: true);
  }

  /// get feedback questions
  Rx<ListResponse<FeedbackQuestionstModel>> feedbackQuestions = ListResponse<FeedbackQuestionstModel>(data:[]).obs;
  Future getFeedBackQuestions()async {
    try {
      await homeProvider.getFeedbackQuestions(onError: (errorMessage) {
        
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        if(data != null){
          feedbackQuestions.value = ListResponse<FeedbackQuestionstModel>.fromJson(data??{}, (data) => FeedbackQuestionstModel.fromJson(data));

        }
      });
    } catch (e) {
      ("error ${e.toString()}").logPrint();
    }
  }

  RxList<SelectedFeedbackOption> selectedFeedback = <SelectedFeedbackOption>[].obs;

  void onTapOption({required int questionId, required int answerId,}) {
    selectedFeedback.removeWhere((item) => item.questionId == questionId,);
    selectedFeedback.add(SelectedFeedbackOption(questionId: questionId, answerId: answerId,),);
  }
  bool isOptionSelected({required int questionId, required int answerId,}) {
    return selectedFeedback.any((item) => item.questionId == questionId && item.answerId == answerId,);
  }

  /// submit  feedback questions
  Future submitFeedBackQuestions()async {
    try {
      form.FormData submitFeedbackData =form.FormData.fromMap({"scan_history_id": diagnoseData.value.id, "type": "diagnose",});
      for (int i = 0; i < selectedFeedback.length; i++) {
        final mcq = selectedFeedback[i];
        submitFeedbackData.fields.add(MapEntry("feedbacks[$i][question_id]", mcq.questionId.toString()),);
        submitFeedbackData.fields.add(MapEntry("feedbacks[$i][answer]", mcq.answerId.toString()),);
      }
      await homeProvider.submitFeedbackData(formData: submitFeedbackData,onError: (errorMessage) {
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
      BaseResponse response = BaseResponse.fromJson(data??{});
      if(response.status == true && (message?.isNotEmpty??false)) {
        toastShow(message: response.message??"", error: false);
        selectedFeedback.value = <SelectedFeedbackOption>[].obs;
        isFeedback.value = true;
      }
      });
    } catch (e) {
      ("error ${e.toString()}").logPrint();
    }
  }

  /// save plant to collection
  VoidCallback get plantsBottomSheet =>()async{
    savePlantsBottomSheet(Get.context!,this);
  };

  ///get collection
  Rx<CollectionData> untitleData = CollectionData().obs;
  Rx<ListResponse<CollectionData>> collectionList = ListResponse<CollectionData>(data:[]).obs;

  Future getCollection() async {
    try {

      await nurseryProvider.getCollections(plantId: diagnoseData.value.plantDetails?.id.toString() ,
        onError: (errorMessage) {
          ("errorMessage => $errorMessage").logPrint();
          // toastShow(message: errorMessage??"", error: true);
        },
        onSuccess: (message, data) {
          BaseResponse response =BaseResponse.fromJson(data??{});
          if(response.status == true){
            collectionList.value = ListResponse<CollectionData>.fromJson(data ?? {},  (e) => CollectionData.fromJson(e),);
            untitleData.value = collectionList.value.data.firstWhere((item) => item.name == "Untitle");
            if(diagnoseData.value.id  != null) {
                diagnoseData.value.plantDetails?.isAdded = true;
                diagnoseData.refresh();
            }
          }
        },
      );
    } catch (e) {
      ("getCollection error ${e.toString()}").logPrint();
      isLoading(false);
    }
  }

  /// Add plant to collection
  Future addPlantToCollection({required CollectionData data}) async {
    try {
      Map<String, dynamic> addPlantToCollectionData ={
        "plant_id": diagnoseData.value.plantDetails?.id,
      };


      if(data.isTemplate == true && data.isUsed == false){
        addPlantToCollectionData.addAll({"template_id": data.id });
      }else if(data.isTemplate == true && data.isUsed == true){
        addPlantToCollectionData.addAll({"collection_id": data.id});
      }else if(data.isTemplate == false && data.isUsed == true){
        addPlantToCollectionData.addAll({"collection_id": data.id});
      }


      await nurseryProvider.addPlantToCollection(addPlantToCollectionData,
        onError: (errorMessage) {
          ("errorMessage => $errorMessage").logPrint();
          toastShow(message: errorMessage??"", error: true);
        },
        onSuccess: (message, data) {
          BaseResponse response =BaseResponse.fromJson(data??{});
          if(response.status == true){
            toastShow(message: response.message??"", error: false);
            getCollection();
          }
        },
      );
    } catch (e) {
      ("getCollection error ${e.toString()}").logPrint();
      isLoading(false);
    }
  }
}



class SelectedFeedbackOption {
  final int questionId;
  final int answerId;

  SelectedFeedbackOption({
    required this.questionId,
    required this.answerId,
  });
}
