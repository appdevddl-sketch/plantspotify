import 'dart:io';

import 'package:plants_spotify/model/model/root_view_models/home_view_models/feedback_questions-model.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/identify_detail_model.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/plant_detail_model.dart';
import 'package:plants_spotify/model/model/root_view_models/nursery_models/collection_model.dart';
import 'package:plants_spotify/model/model/root_view_models/nursery_models/plant_notes_model.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/home_provider.dart';

import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/nursery_provider.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/network_calls/dio_client/get_it_instance.dart';
import 'package:plants_spotify/model/utils/file_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/diagnose_screens/diagnose_detail_screen/view_holder/give_feedback_dialog.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/edit_note_bottomsheet/edit_note_bottomsheet.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/plant_detail_view.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/view_holder/save_plants_bottomsheet.dart';
import 'package:plants_spotify/view/screens/root_view/my_nursery_view/collectionviewSceen/add_note_bottomsheet/add_note_bottomsheet.dart';
import 'package:plants_spotify/view/screens/root_view/my_nursery_view/view_holder/delete_dialog_screen.dart';
import 'package:plants_spotify/view/widgets/button_view/animated_box.dart';
import 'package:plants_spotify/view/widgets/button_view/image_picker.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/pagination_view/pagination_view_screen.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view/widgets/toast_view/showtoast.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/diagnose_screens_controller/diagnose_detail_controller/diagnose_detail_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as form ;



class PlantDetailController extends BaseViewController with GetSingleTickerProviderStateMixin {

  TextEditingController notesController  = TextEditingController();
  RxList<File> selectDocumentFiles = <File>[].obs;
  RxList<int> removeEditNoteIds = <int>[].obs;
  RxString commonName = "".obs;
  final GlobalKey<FormState> editNoteFormKey = GlobalKey<FormState>();

  var notesError = "".obs;
  RxBool isDataEmpty = false.obs;

  HomeProvider homeProvider = getIt();
  NurseryProvider nurseryProvider = getIt();
  RxMap<String,dynamic> backScreenData =<String,dynamic>{}.obs;
  RxBool isFeedback = false.obs;
  VoidCallback get plantsBottomSheet =>()async{
    savePlantsBottomSheet(Get.context!,this);
  };


  /// one key per tab – used to auto-scroll the tab bar to the active tab
  final List<GlobalKey> tabKeys = List.generate(9, (_) => GlobalKey());

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








  /// custom tabs
  late TabController pageController;
  RxString selectCategory = "basic_information".tr.obs;
  RxInt selectCategoryIndex = 0.obs;

  List<Map<String,dynamic>> orderCategory =[
    {
      "image":ImageResource.instance.plantDetailIcon,
      "title": "basic_information".tr,
    },
    {
      "image":ImageResource.instance.moreDetailIcon,
      "title": "other_details".tr,
    },
    {
      "image":ImageResource.instance.galleryIcon,
      "title": "gallery".tr,
    },
    {
      "image":ImageResource.instance.settingDetailIcon,
      "title": "flower_details".tr,

    },
    {
      "image":ImageResource.instance.flowerDetailIcon,
      "title": "fruit_details".tr,

    },
    {
      "image":ImageResource.instance.toxicityDetailIcon,
      "title": "toxicity_information".tr,

    },
    {
      "image":ImageResource.instance.careDetailIcon,
      "title": "care_conditions".tr,

    },
    {
      "image":ImageResource.instance.usesDetailIcon,
      "title": "uses".tr,

    },
    {
      "image":ImageResource.instance.plantDetailIcon,
      "title": "geo_location".tr,

    },

  ];

  void onChangeButtonTapped(int index) {
    selectCategory.value = orderCategory[index]["title"];
    selectCategoryIndex.value = index;
    pageController.index = index;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollTabToVisible(index));
  }
  @override
  void onInit() {
    super.onInit();
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

    _initializeData();
  }

  /// Called from pull-to-refresh on the NoDataFoundScreen.
  /// Re-fetches data from the API and resets the empty state.
  Future<void> refreshData() async {
    isDataEmpty.value = false;
    if (backScreenData["type"] == 3) {
      if (identifyPlantData.value.data.plantDetails == null) {
        isDataEmpty.value = true;
      }
    } else {
      await getPlantDetail();
    }
  }

  Future<void> _initializeData() async {
    backScreenData.value = Get.arguments ?? {};
    isDataEmpty.value = false;
    if (backScreenData["type"] == 3) {
      identifyPlantData.value = backScreenData["data"];
      if (identifyPlantData.value.data.plantDetails == null) {
        isDataEmpty.value = true;
        return;
      }
      commonName.value = identifyPlantData.value.data.plantDetails?.commonName ?? "details".tr;
      isFeedback.value = identifyPlantData.value.data.isFeedback ?? false;
      getFeedBackQuestions();
    } else {
      await getPlantDetail();
    }
  }


  ///get plant detail
  Rx<SingleResponse<PlantDetailModel>> plantDetailData = SingleResponse<PlantDetailModel>(data: PlantDetailModel()).obs;
  Future getPlantDetail()async {
    isLoading.call(true);
    try {
      Map<String, dynamic> getPlantDetailsData ={
        "id": backScreenData["id"],
      };
      await homeProvider.getPlantDetails(getPlantDetailsData,onError: (errorMessage) {
        isLoading.call(false);
        isDataEmpty.value = true;
        
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        if(backScreenData["type"] == 2) {
          await getPlantsNoteList(pageNumber: 1,forPaginate: false);
        }
        isLoading.call(false);
        plantDetailData.value = SingleResponse<PlantDetailModel>.fromJson(data ?? {}, (data) => PlantDetailModel.fromJson(data));
        if (plantDetailData.value.status == false || plantDetailData.value.data.commonName == null) {
          isDataEmpty.value = true;
          return;
        }
        commonName.value = plantDetailData.value.data.commonName ?? "details".tr;
      });
    } catch (e) {
      isLoading.call(false);
      isDataEmpty.value = true;
      ("error ${e.toString()}").logPrint();
    }
  }

  /// identify plant data
  Rx<SingleResponse<IdentifyDetailModel>> identifyPlantData = SingleResponse<IdentifyDetailModel>(data: IdentifyDetailModel()).obs;

  /// feedback
  Rx<ListResponse<FeedbackQuestionstModel>> feedbackQuestions = ListResponse<FeedbackQuestionstModel>(data:[]).obs;
  RxList<SelectedFeedbackOption> selectedFeedback = <SelectedFeedbackOption>[].obs;

  Future getFeedBackQuestions() async {
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

  void onTapOption({required int questionId, required int answerId}) {
    selectedFeedback.removeWhere((item) => item.questionId == questionId);
    selectedFeedback.add(SelectedFeedbackOption(questionId: questionId, answerId: answerId));
  }

  bool isOptionSelected({required int questionId, required int answerId}) {
    return selectedFeedback.any((item) => item.questionId == questionId && item.answerId == answerId);
  }

  Future submitFeedBackQuestions() async {
    try {
      form.FormData submitFeedbackData = form.FormData.fromMap({
        "scan_history_id": identifyPlantData.value.data.id,
        "type": "identify",
      });
      for (int i = 0; i < selectedFeedback.length; i++) {
        final mcq = selectedFeedback[i];
        submitFeedbackData.fields.add(MapEntry("feedbacks[$i][question_id]", mcq.questionId.toString()));
        submitFeedbackData.fields.add(MapEntry("feedbacks[$i][answer]", mcq.answerId.toString()));
      }
      await homeProvider.submitFeedbackData(formData: submitFeedbackData, onError: (errorMessage) {
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

  void showFeedbackPopup() {
    showAnimatedDialog(
        Get.context!,
        feedbackPopup(
            onConfirm: () async {
              if(selectedFeedback.length == feedbackQuestions.value.data.length){
                await submitFeedBackQuestions();
                Get.back();
              } else {
                toastShow(message: "please_select_all_answers".tr, error: true);
              }
            },
            onCancel: () {
              Get.back();
            },
            feedbackQuestions: feedbackQuestions,
            isOptionSelected: isOptionSelected,
            onTapOption: onTapOption,
        ),
        dismissible: false,
        isFlip: true);
  }

  ///get collection
  Rx<CollectionData> untitleData = CollectionData().obs;
  Rx<ListResponse<CollectionData>> collectionList = ListResponse<CollectionData>(data:[]).obs;

    Future getCollection() async {
    try {

      await nurseryProvider.getCollections(plantId: (backScreenData["type"] == 3 ?  identifyPlantData.value.data.plantDetails?.id : plantDetailData.value.data.id).toString() ,
        onError: (errorMessage) {
          ("errorMessage => $errorMessage").logPrint();
          // toastShow(message: errorMessage??"", error: true);
        },
        onSuccess: (message, data) {
          BaseResponse response =BaseResponse.fromJson(data??{});
          if(response.status == true){
            collectionList.value = ListResponse<CollectionData>.fromJson(data ?? {},  (e) => CollectionData.fromJson(e),);
            untitleData.value = collectionList.value.data.firstWhere((item) => item.name == "Untitle");
            if((backScreenData["type"] == 3 ?  identifyPlantData.value.data.plantDetails?.id : plantDetailData.value.data.id) != null) {
              if(backScreenData["type"] == 3) {
                identifyPlantData.value.data.plantDetails?.isAdded = true;
                identifyPlantData.refresh();
              } else{
                plantDetailData.value.data.isAdded = true;
                plantDetailData.refresh();
              }
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
        "plant_id": backScreenData["type"] == 3 ?  identifyPlantData.value.data.plantDetails?.id : plantDetailData.value.data.id,
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

  /// remove plant from collection
  Future removePlantFromCollection() async {
    try {
      Map<String, dynamic> addPlantToCollectionData ={
        "id": "", /// get plant id from detail page
      };
      await nurseryProvider.addPlantToCollection(addPlantToCollectionData,
        onError: (errorMessage) {
          ("errorMessage => $errorMessage").logPrint();
        },
        onSuccess: (message, data) {
          final response = ListResponse<CollectionData>.fromJson(data ?? {},  (e) => CollectionData.fromJson(e),);
        },
      );
    } catch (e) {
      ("getCollection error ${e.toString()}").logPrint();
      isLoading(false);
    }
  }

  /// get plant notes list
  Rx<SingleResponse<PlantNotesModel>> plantNotesData = SingleResponse<PlantNotesModel>(data: PlantNotesModel()).obs;
  PaginationViewController<PlantNotesData> plantNotesPaginationViewController = PaginationViewController(
      showMessage: "no_data_found".tr,
      totalPageCont: 0,
      onScrollDownDone: (bool value, int pageNumber) {},
      itemList: <PlantNotesData>[].obs
  );
  Future getPlantsNoteList({required int pageNumber,required bool forPaginate}) async {
    try {
      if(forPaginate){
        plantNotesPaginationViewController.isLoading.call(true);
      }
      Map<String, dynamic> getCollectionPlantData ={
        "id": backScreenData["notes_id"],
        "paginate": 10,
        "page":pageNumber
      };
      await nurseryProvider.getPlantNote(getCollectionPlantData,onError: (errorMessage) {
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        plantNotesData.value = SingleResponse<PlantNotesModel>.fromJson(data??{}, (data) => PlantNotesModel.fromJson(data));
        plantNotesPaginationViewController.totalPageCont = plantNotesData.value.data.pagination?.lastPage ?? 0;
        plantNotesPaginationViewController.onScrollDownDone = (bool value, int pageNumber) {
          if (value) {
            getPlantsNoteList(pageNumber: pageNumber,forPaginate: true);
          }
        };
        if(forPaginate){
          plantNotesPaginationViewController.itemList.addAll(plantNotesData.value.data.data ?? []);
          plantNotesPaginationViewController.isLoading.call(false);
        }else{
          plantNotesPaginationViewController.itemList.value = plantNotesData.value.data.data ?? [];
        }
      });
    } catch (e) {
      (e).logPrint();
      plantNotesPaginationViewController.isLoading.call(false);
    }
  }





  /// Notes overlay
   OverlayEntry? _menuOverlay;
  void showNotesMenu(BuildContext cardContext) {
    hideMenu();

    final RenderBox box =
    cardContext.findRenderObject() as RenderBox;
    final Offset position = box.localToGlobal(Offset.zero);
    final Size size = box.size;

    final double top = position.dy + size.height -130;
    final double left = position.dx + size.width - 180;

    _menuOverlay = OverlayEntry(
      builder: (_) => DetailMenuOverlay(
        top: top,
        left: left,
        onRename: () {
          hideMenu();
          selectDocumentFiles.clear();
          bottomSheetType.value = 2;
          editBottomSheet();
          notesError.value = "";
          imageError.value = "";
        },
        onDelete: () {
          hideMenu();
          openDeleteDialog();
        },
        onClose: hideMenu,
      ),
    );

    Navigator.of(Get.context!, rootNavigator: true)
        .overlay
        ?.insert(_menuOverlay!);
  }

  void hideMenu() {
    _menuOverlay?.remove();
    _menuOverlay = null;
  }
  void openDeleteDialog() {
    showAnimatedDialog(
        Get.context!,
        DeletePopup(
          title: "delete_title_notes".tr,
            onConfirm:() async {
              await deletePlantNote();
              Get.back();
            }, onCancel: () {
          Get.back();
        },controller:  this),
        dismissible: false,
        isFlip: true);
  }
  /// open bottom sheets
  var imageError = "".obs;
  VoidCallback get imgFromCamera => (){
    FileResource.instance.imagePickerFromCamara().then((pickedFile){
      if(pickedFile.path!=""){
        Get.back();
        imageError.value = "";
        selectDocumentFiles.add(File(pickedFile.path));
      }
    } );
  };

  VoidCallback get imgFromGallery => (){
    FileResource.instance.imagePickerFromGallery().then((pickedFile){
      if(pickedFile.path!=""){
        Get.back();
        imageError.value = "";
        selectDocumentFiles.add(File(pickedFile.path));
      }
    } );
  };

  VoidCallback get pickFilesFromDevice =>() async {
    if(!await HelperFunction.checkPermission()) return;
    showImagePicker(
    Get.context!,
    onCamaraTap: imgFromCamera,
    onGalleryTap: imgFromGallery,
    );
  };
  /// edit plant Note
  Rx<PlantNotesData> selectedPlantNote = PlantNotesData().obs;

  Rx<int> bottomSheetType = 0.obs;
  void editPlantNote()async{
    if((editNoteFormKey.currentState?.validate()??false) && (selectDocumentFiles.isNotEmpty || (selectedPlantNote.value.images?.isNotEmpty??false))){
      isLoading.call(true);
      try {
        form.FormData editNoteData =form.FormData.fromMap({"note": notesController.text,});
        for (var element in selectDocumentFiles){
          editNoteData.files.add(
            MapEntry("images[]", await form.MultipartFile.fromFile(element.path, filename: element.path.split('/').last,)),
          );
          (element.path).logPrint();
        }
        for (var element in removeEditNoteIds){
          editNoteData.fields.add(
            MapEntry("remove_image_ids[]", element.toString()),
          );
          (element).logPrint();
        }
        (notesController.text).logPrint();
        await nurseryProvider.editPlantNote(data: editNoteData,userPlantId: backScreenData["notes_id"],noteId: selectedPlantNote.value.id??0, onError: (errorMessage) {
          ("errorMessage=> $errorMessage").logPrint();
          toastShow(message: errorMessage??"", error: true);

          isLoading.call(false);
        }, onSuccess: (message, data) async {
          BaseResponse response = BaseResponse.fromJson(data??{});
          if(response.status == true){
            toastShow(message: response.message??"", error: false);
            getPlantsNoteList(pageNumber: 1, forPaginate: false);
            Get.back();
            clearData();
          }
          isLoading.call(false);
        });
      } catch (e) {
        ("this is error ${e.toString()}").logPrint();
        isLoading.call(false);
      }

    } else if(selectDocumentFiles.isEmpty){
      if((selectedPlantNote.value.images?.isNotEmpty??false)){
        imageError.value = "";
        return ;
      }
      imageError.value = "please_add_images".tr;

    }else if(selectDocumentFiles.isNotEmpty){
      imageError.value = "";
    }
  }
  Future deletePlantNote()async{
    try{
        await nurseryProvider.deletePlantNote(userPlantId: backScreenData["notes_id"],noteId: selectedPlantNote.value.id??0, onError: (errorMessage) {
          ("errorMessage=> $errorMessage").logPrint();
          toastShow(message: errorMessage??"", error: true);

          isLoading.call(false);
        }, onSuccess: (message, data) async {
          BaseResponse response = BaseResponse.fromJson(data??{});
          if(response.status == true){
            toastShow(message: response.message??"", error: false);
            getPlantsNoteList(pageNumber: 1, forPaginate: false);

            clearData();
          }
          isLoading.call(false);
        });
      } catch (e) {
        ("this is error ${e.toString()}").logPrint();
        isLoading.call(false);
      }


  }
  void addPlantNote()async{
    if((editNoteFormKey.currentState?.validate()??false) && selectDocumentFiles.isNotEmpty){
      isLoading.call(true);
      try {
        form.FormData addNoteData =form.FormData.fromMap({"note": notesController.text, "isScanCheck": true,});
        for (var element in selectDocumentFiles){
          addNoteData.files.add(
            MapEntry("images[]", await form.MultipartFile.fromFile(element.path, filename: element.path.split('/').last,)),
          );
          (element.path).logPrint();
        }
        (notesController.text).logPrint();
        await nurseryProvider.addPlantNote(data: addNoteData,id:  backScreenData["notes_id"], onError: (errorMessage) {
          ("errorMessage=> $errorMessage").logPrint();
          toastShow(message: errorMessage??"", error: true);

          isLoading.call(false);
        }, onSuccess: (message, data) async {
          BaseResponse response = BaseResponse.fromJson(data??{});
          if(response.status == true){
            toastShow(message: response.message??"", error: false);
            getPlantsNoteList(pageNumber: 1, forPaginate: false);
            Get.back();
            clearData();
          }
          isLoading.call(false);
        });
      } catch (e) {
        ("this is error ${e.toString()}").logPrint();
        isLoading.call(false);
      }

    } else if(selectDocumentFiles.isEmpty){
      imageError.value = "please_add_images".tr;
    }else if(selectDocumentFiles.isNotEmpty){
      imageError.value = "";
    }
  }
  /// open bottom sheets
  VoidCallback get editBottomSheet =>()async{
    notesController.text= selectedPlantNote.value.note??"";
    editNotesBottomSheet(Get.context!,this);
  };

  void removeImage(int id) {
    final image = selectedPlantNote.value.images?.firstWhereOrNull((item) => item.id == id);
    if (image?.id != null && !removeEditNoteIds.contains(image!.id)) {
      removeEditNoteIds.add(image.id!);
    }
    selectedPlantNote.value.images?.removeWhere((item) => item.id == id);
    selectedPlantNote.refresh();
  }


  void clearData(){
    notesController.clear();
    selectedPlantNote.value = PlantNotesData();
    selectDocumentFiles.clear();
    removeEditNoteIds.clear();
  }

  /// Gallery images from the existing slider data
  List<String> get galleryImages {
    if (backScreenData["type"] == 3) {
      return identifyPlantData.value.data.plantDetails?.images
              ?.map((e) => e.url)
              .whereType<String>()
              .toList() ?? [];
    } else {
      return plantDetailData.value.data.images
              ?.map((e) => e.url)
              .whereType<String>()
              .toList() ?? [];
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
