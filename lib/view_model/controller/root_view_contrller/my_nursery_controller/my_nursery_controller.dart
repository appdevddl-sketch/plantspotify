import 'package:flutter/material.dart';
import 'package:plants_spotify/model/model/root_view_models/nursery_models/collection_model.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/nursery_provider.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/network_calls/dio_client/get_it_instance.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view/screens/root_view/my_nursery_view/my_nursery_screen.dart';
import 'package:plants_spotify/view/screens/root_view/my_nursery_view/view_holder/delete_dialog_screen.dart';
import 'package:plants_spotify/view/screens/root_view/my_nursery_view/view_holder/rename_dialog_screen.dart';
import 'package:plants_spotify/view/widgets/button_view/animated_box.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view/widgets/toast_view/showtoast.dart';

class MyNurseryController extends BaseViewController{

  NurseryProvider nurseryProvider = getIt();
  final GlobalKey<FormState> updateCollectionFormKey = GlobalKey<FormState>();
  TextEditingController searchController  = TextEditingController();
  TextEditingController collectionNameController  = TextEditingController();
  var collectionNameError = "".obs;

  var searchError = "".obs;


  OverlayEntry? _menuOverlay;

  void showCollectionMenu(BuildContext cardContext,String id,String? name) {
    hideMenu();

    final RenderBox box =
    cardContext.findRenderObject() as RenderBox;
    final Offset position = box.localToGlobal(Offset.zero);
    final Size size = box.size;

    final double top = position.dy + size.height;
    final double left = position.dx + size.width - 180;

    _menuOverlay = OverlayEntry(
      builder: (_) => CollectionMenuOverlay(
        top: top,
        left: left,
        onRename: () {
          hideMenu();
          openRenameDialog(this,id,name??"");
        },
        onDelete: () {
          hideMenu();
          openDeleteDialog(this,id);
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

  void openRenameDialog(controller,String id,String name) {
    controller.collectionNameController.text = name;
    showAnimatedDialog(
        Get.context!,
        RenamePopup(
            onConfirm:() async {
              await updateCollection(id: id);
              Get.back();
            }, onCancel: () {
          Get.back();
        },controller:  controller),
        dismissible: false,
        isFlip: true);
  }

  void openDeleteDialog(controller,String id) {
    showAnimatedDialog(
        Get.context!,
        DeletePopup(
            onConfirm:() async {
              await deleteCollection(id: id);
              Get.back();
            }, onCancel: () {
          Get.back();
        },controller:  controller),
        dismissible: false,
        isFlip: true);
  }



  ///get predefine collection
  // Future getPredefineCollection() async {
  //   collectionList.clear();
  //   try {
  //     await nurseryProvider.getPredefineCollections(
  //       onError: (errorMessage) {
  //         ("errorMessage => $errorMessage").logPrint();
  //       },
  //       onSuccess: (message, data) {
  //         final response = ListResponse<CollectionData>.fromJson(data ?? {}, (e) => CollectionData.fromJson(e),);
  //         collectionList.addAll(response.data);
  //       },
  //     );
  //   } catch (e) {
  //     ("getPredefineCollection error ${e.toString()}").logPrint();
  //     isLoading(false);
  //   }
  // }


  ///get collection
  Rx<ListResponse<CollectionData>> collectionList = ListResponse<CollectionData>(data:[]).obs;
  Future getCollection() async {
    isLoading.call(true);
    try {
      await nurseryProvider.getCollections(
        onError: (errorMessage) {
          isLoading.call(false);
          ("errorMessage => $errorMessage").logPrint();
        },
        onSuccess: (message, data) {
          isLoading.call(false);
          if(data != null){
            collectionList.value = ListResponse<CollectionData>.fromJson(data ?? {},  (e) => CollectionData.fromJson(e),);
          }
        },
      );
    } catch (e) {
      ("getCollection error ${e.toString()}").logPrint();
      isLoading(false);
    }
  }



  /// update collection
  Future updateCollection({required String id})async{
    try {
      Map<String,String>  updateCollectionData={
        "id":id,
        "name": collectionNameController.text,
      };
      await nurseryProvider.updateCollection(updateCollectionData,onError: (errorMessage) {

        toastShow(message: errorMessage??"", error: true);
        ("errorMessage=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        BaseResponse response = BaseResponse.fromJson(data??{});
        if(response.status == true){
          toastShow(message: response.message??"", error: false);
          onInit();
        }
      });
    } catch (e) {
      ("this is login try error ${e.toString()}").logPrint();
      isLoading.call(false);
    }
  }

  /// delete collection
  Future deleteCollection({required String id})async{
    try {
      Map<String,String>  deleteCollectionData={
        "id":id,
      };
      await nurseryProvider.deleteCollection(deleteCollectionData,onError: (errorMessage) {

        ("errorMessage=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        BaseResponse response = BaseResponse.fromJson(data??{});
        if(response.status == true){
          toastShow(message: response.message??"", error: false);
          onInit();
        }
      });
    } catch (e) {
      ("this is login try error ${e.toString()}").logPrint();
      isLoading.call(false);
    }
  }
  @override
  void onInit() async{
    // TODO: implement onInit
    await getCollection();
    super.onInit();
  }
}

