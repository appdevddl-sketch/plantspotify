


import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:plants_spotify/model/model/root_view_models/nursery_models/collection_model.dart';
import 'package:plants_spotify/model/model/root_view_models/nursery_models/collection_plants_model.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/nursery_provider.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/network_calls/dio_client/get_it_instance.dart';
import 'package:plants_spotify/model/utils/file_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view/screens/root_view/my_nursery_view/collectionviewSceen/add_note_bottomsheet/add_note_bottomsheet.dart';
import 'package:plants_spotify/view/screens/root_view/my_nursery_view/collectionviewSceen/collectionviewSceen.dart';
import 'package:plants_spotify/view/screens/root_view/my_nursery_view/view_holder/delete_dialog_screen.dart';
import 'package:plants_spotify/view/screens/root_view/my_nursery_view/view_holder/rename_dialog_screen.dart';
import 'package:plants_spotify/view/widgets/button_view/animated_box.dart';
import 'package:plants_spotify/view/widgets/button_view/image_picker.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/pagination_view/pagination_view_screen.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view/widgets/toast_view/showtoast.dart';
import 'package:dio/dio.dart' as form;
import 'package:plants_spotify/view_model/routes/app_pages.dart';


class CollectionViewController extends BaseViewController {
  NurseryProvider nurseryProvider = getIt();
  Rx<CollectionData> backScreenData = CollectionData().obs;

  final GlobalKey<FormState> collectionFormKey = GlobalKey<FormState>();

  OverlayEntry? _menuOverlay;

  void showCollectionMenu(BuildContext cardContext) {
    hideMenu();

    final RenderBox box =
    cardContext.findRenderObject() as RenderBox;
    final Offset position = box.localToGlobal(Offset.zero);
    final Size size = box.size;

    final double top = position.dy + size.height;
    final double left = position.dx + size.width - 180;

    _menuOverlay = OverlayEntry(
      builder: (_) => MenuOverlay(
        top: top,
        left: left,
        onDelete: () {
          hideMenu();
          openDeleteDialog(this);
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



  void openDeleteDialog(controller) {
    showAnimatedDialog(
        Get.context!,
        DeletePopup(
            onConfirm:() async {
              await removePlantFromCollection();
              Get.back();
            }, onCancel: () {
          Get.back();
        },controller:  controller,title: "delete_plant_title".tr,),
        dismissible: false,
        isFlip: true);
  }


  /// open bottom sheets
  VoidCallback get addBottomSheet =>()async{
    await addNotesBottomSheet(Get.context!,this);
    clearData();
  };

  TextEditingController notesController  = TextEditingController();
  RxList<File> selectDocumentFiles = <File>[].obs;

  var notesError = "".obs;

  VoidCallback get imgFromGallery => (){
    FileResource.instance.imagePickerFromGallery().then((pickedFile){
      if(pickedFile.path!=""){
        Get.back();
        imageError.value = "";
        selectDocumentFiles.add(File(pickedFile.path));
      }
    } );
  };
  VoidCallback get imgFromCamera => (){
    FileResource.instance.imagePickerFromCamara().then((pickedFile){
      if(pickedFile.path!=""){
        Get.back();
        imageError.value = "";
        selectDocumentFiles.add(File(pickedFile.path));
      }
    } );
  };
  VoidCallback get pickFilesFromDevice =>()async{
    if(!await HelperFunction.checkPermission()) return;
    showImagePicker(
      Get.context!,
      onCamaraTap: imgFromCamera,
      onGalleryTap: imgFromGallery,
    );
  };

  /// get plant collection data
  Rx<SingleResponse<CollectionPlantModel>> collectionPlantData = SingleResponse<CollectionPlantModel>(data: CollectionPlantModel()).obs;
  PaginationViewController<CollectionPlantData> collectionPlantPaginationViewController = PaginationViewController(
      showMessage: "no_data_found".tr,
      totalPageCont: 0,
      onScrollDownDone: (bool value, int pageNumber) {},
      itemList: <CollectionPlantData>[].obs
  );
  Future getCollectionPlantList({required int pageNumber,required bool forPaginate}) async {
    try {
      if(forPaginate){
        collectionPlantPaginationViewController.isLoading.call(true);
      }
      Map<String, dynamic> getCollectionPlantData ={
        "id": backScreenData.value.id,
        "paginate": 10,
        "page":pageNumber
      };
      await nurseryProvider.getCollectionPlants(getCollectionPlantData,onError: (errorMessage) {
        
        toastShow(message: errorMessage??"", error: true);
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        if(data != null){
          collectionPlantData.value = SingleResponse<CollectionPlantModel>.fromJson(data??{}, (data) => CollectionPlantModel.fromJson(data));
          collectionPlantPaginationViewController.totalPageCont = collectionPlantData.value.data.pagination?.lastPage ?? 0;
          collectionPlantPaginationViewController.onScrollDownDone = (bool value, int pageNumber) {
            if (value) {
              getCollectionPlantList(pageNumber: pageNumber,forPaginate: true);
            }
          };
          if(forPaginate){
            collectionPlantPaginationViewController.itemList.addAll(collectionPlantData.value.data.data ?? []);
            collectionPlantPaginationViewController.isLoading.call(false);
          }else{
            collectionPlantPaginationViewController.itemList.value = collectionPlantData.value.data.data ?? [];
          }
        }
      });
    } catch (e) {
      (e).logPrint();
      collectionPlantPaginationViewController.isLoading.call(false);
    }
  }

  /// add plant Note
  var imageError = "".obs;
  CollectionPlantData selectedPlantData = CollectionPlantData();
  void addPlantNote()async{
    if((collectionFormKey.currentState?.validate()??false) && selectDocumentFiles.isNotEmpty){
      imageError.value = "";
      isLoading.call(true);
      try {
        bool isScanCheck = true;
        if (selectedPlantData.validTill != null && selectedPlantData.validTill!.isNotEmpty) {
          try {
            DateTime? validTillDate;
            try {
              validTillDate = DateTime.parse(selectedPlantData.validTill!);
            } catch (_) {
              // API returns "Jul 05, 2026" format — parse manually
              const months = {'Jan':1,'Feb':2,'Mar':3,'Apr':4,'May':5,'Jun':6,'Jul':7,'Aug':8,'Sep':9,'Oct':10,'Nov':11,'Dec':12};
              final parts = selectedPlantData.validTill!.replaceAll(',', '').split(' ');
              if (parts.length == 3) {
                final month = months[parts[0]];
                final day = int.tryParse(parts[1]);
                final year = int.tryParse(parts[2]);
                if (month != null && day != null && year != null) {
                  validTillDate = DateTime(year, month, day);
                }
              }
            }
            if (validTillDate != null) {
              final today = DateTime.now();
              final currentDay = DateTime(today.year, today.month, today.day);
              final validDay = DateTime(validTillDate.year, validTillDate.month, validTillDate.day);
              if (!currentDay.isAfter(validDay)) isScanCheck = false;
            }
          } catch (_) {}
        }
        form.FormData addNoteData =form.FormData.fromMap({"note": notesController.text, "isScanCheck": isScanCheck,});
        for (var element in selectDocumentFiles){
          addNoteData.files.add(
            MapEntry("images[]", await form.MultipartFile.fromFile(element.path, filename: element.path.split('/').last,)),
          );
          (element.path).logPrint();
        }
        (notesController.text).logPrint();
        await nurseryProvider.addPlantNote(data: addNoteData,id: selectedPlantData.id, onError: (errorMessage) {
          
          ("errorMessage=> $errorMessage").logPrint();
          toastShow(message: errorMessage??"", error: true);

          isLoading.call(false);
        }, onSuccess: (message, data) async {
          BaseResponse response = BaseResponse.fromJson(data??{});
          if(response.status == true){
            toastShow(message: response.message??"", error: false);
            Get.toNamed(Routes.plantsDetailScreen,arguments: {"id":selectedPlantData.plantId,"type":2,"notes_id":selectedPlantData.id});
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
      // toastShow(message: "please_add_images".tr, error: true);
    }else if(selectDocumentFiles.isNotEmpty){
      imageError.value = "";
    }
  }

  /// remove plant from collection
  Future removePlantFromCollection() async {
    try {
      Map<String, dynamic> removePlantData ={
        "id": selectedPlantData.id,
      };
      await nurseryProvider.removePlantFromCollection(removePlantData,onError: (errorMessage) {
        
        if(errorMessage?.isNotEmpty??false){
          toastShow(message: errorMessage??"", error: true);
        }
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
       BaseResponse response = BaseResponse.fromJson(data??{});
       if(response.status ==true && (message?.isNotEmpty??false)){
         await getCollectionPlantList(pageNumber: 1,forPaginate: false);
         toastShow(message: message??"", error: false);
       }
      });
    } catch (e) {
      (e).logPrint();
    }
  }



  void clearData(){
    notesController.clear();
    selectedPlantData = CollectionPlantData();
    selectDocumentFiles.clear();
  }
@override
  void onInit() async{
    // TODO: implement onInit
  backScreenData.value =  Get.arguments??CollectionData();
  await getCollectionPlantList(pageNumber: 1,forPaginate: false);
    super.onInit();
  }
}
