import 'dart:convert';
import 'dart:io';


import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/TipsModel.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/articel_list_model.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/diagnose_details_model.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/identify_detail_model.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/plant_categories_model.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/plant_detail_model.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/search_results_model.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/utils/file_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/home_view_screen.dart';
import 'package:plants_spotify/view/screens/root_view/root_view.dart';
import 'package:plants_spotify/view/widgets/app_common/custom_popup/loader_popup.dart';
import 'package:plants_spotify/view/widgets/app_common/custom_popup/permission_popup.dart';
import 'package:plants_spotify/view/widgets/app_common/custom_popup/warningPopup.dart';
import 'package:plants_spotify/view/widgets/button_view/animated_box.dart';
import 'package:plants_spotify/view/widgets/button_view/image_picker.dart';
import 'package:plants_spotify/view/widgets/pagination_view/pagination_view_screen.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/root_view_controller.dart';
import 'package:plants_spotify/view_model/notification/my_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';
import 'package:wakelock_plus/wakelock_plus.dart';


import '../../../../model/network_calls/api_helper/provider_helper/auth_provider.dart';
import '../../../../model/network_calls/api_helper/provider_helper/home_provider.dart';
import '../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../model/services/auth_service.dart';
import '../../../../view/widgets/toast_view/showtoast.dart';
import '../../../notification/notifiction_redirection.dart';
import 'package:dio/dio.dart' as form ;
class HomeController extends BaseViewController with GetSingleTickerProviderStateMixin{
  HomeProvider homeProvider = getIt();
  /// notification count
  RxInt notificationCount =0.obs;


  /// get tips
  RxBool isTipsLoading = false.obs;
  Rx<ListResponse<TipsModel>> tipsList = ListResponse<TipsModel>(data:[]).obs;
  Future getTips()async {
    isTipsLoading.call(true);
    try {
      await homeProvider.getTips(onError: (errorMessage) {
        
        isTipsLoading.call(false);
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        isTipsLoading.call(false);
        tipsList.value = ListResponse<TipsModel>.fromJson(data??{}, (data) => TipsModel.fromJson(data));
      });
    } catch (e) {
      isTipsLoading.call(false);
      ("error ${e.toString()}").logPrint();
    }
  }


  /// get articles
  RxBool isArticlesLoading = false.obs;
  Rx<SingleResponse<ArticelListModel>> articleListData = SingleResponse<ArticelListModel>(data: ArticelListModel()).obs;
  Future getArticleList() async {
     isArticlesLoading.call(true);
    try {
      Map<String, dynamic> getArticlesData ={
        "paginate": 4,
        "page":1
      };
      await homeProvider.getArticles(getArticlesData,onError: (errorMessage) {
        
        isArticlesLoading.call(false);
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        isArticlesLoading.call(false);
        articleListData.value = SingleResponse<ArticelListModel>.fromJson(data??{}, (data) => ArticelListModel.fromJson(data));
      });
    } catch (e) {
      isArticlesLoading.call(false);
      (e).logPrint();
    }
  }

  /// diagnose process
  RxInt scanType = 0.obs;

  ///permission
  Future<List<Permission>> requiredPermissions() async {
    if (Platform.isAndroid) {
      final sdk = (await DeviceInfoPlugin().androidInfo).version.sdkInt;
      ("device info sdk :: => $sdk").logPrint();
      return [
        Permission.camera,
        if (sdk < 33) Permission.storage,
      ];
    }
    return [Permission.camera, Permission.photos];
  }
  Future checkPermission() async {
    final permissions = await requiredPermissions();

    final statusMap = {
      for (final p in permissions) p: await p.status,
    };

    bool cameraGranted =
        statusMap[Permission.camera]?.isGranted ?? false;

    // On Android 13+ the system Photo Picker needs no permission — gallery is
    // always accessible without READ_MEDIA_IMAGES / READ_EXTERNAL_STORAGE.
    bool galleryGranted =
        (!statusMap.containsKey(Permission.photos) && !statusMap.containsKey(Permission.storage)) ||
        statusMap[Permission.photos]?.isGranted == true ||
        statusMap[Permission.photos]?.isLimited == true ||
        statusMap[Permission.storage]?.isGranted == true;

    if (cameraGranted && galleryGranted) {
      showImagePicker(
        Get.context!,
        onCamaraTap: imgFromCamera,
        onGalleryTap: imgFromGallery,
      );
    } else {
      final cameraOnly = !permissions.contains(Permission.storage) && !permissions.contains(Permission.photos);
      permissionPopup(
        Get.context,
        this,
        title: cameraOnly ? "enable_camera_only_title".tr : "enable_camera_title".tr,
        subTitle: cameraOnly ? "enable_camera_only_subtitle".tr : "enable_camera_subtitle".tr,
      );
    }
  }


  void permissionPopup(context, controller, {String? title, String? subTitle}) {
    showAnimatedDialog(
      Get.context!,
      PermissionPopup(
        title: title,
        subTitle: subTitle,
        showCancelOption: false,
        onConfirm: () async {
          final permissions = await requiredPermissions();
          final statuses = await permissions.request();

          bool cameraGranted = statuses[Permission.camera]?.isGranted ?? false;

          bool galleryGranted =
              (!statuses.containsKey(Permission.photos) && !statuses.containsKey(Permission.storage)) ||
              statuses[Permission.photos]?.isGranted == true ||
              statuses[Permission.photos]?.isLimited == true ||
              statuses[Permission.storage]?.isGranted == true;

          Get.back();

          if (cameraGranted && galleryGranted) {
            showImagePicker(
              Get.context!,
              onCamaraTap: imgFromCamera,
              onGalleryTap: imgFromGallery,
            );
          } else {
            toastShow(
              message: "Permission required to continue",
              error: true,
            );
          }
        },
        onCancel: () {
          Get.back();
        },
        controller: controller,
      ),
      dismissible: false,
      isFlip: true,
    );
  }
  void completeProfile() {
    showAnimatedDialog(
      Get.context!,
      PermissionPopup(
        onConfirm: ()  => Get.toNamed(Routes.editProfileScreen),
        onCancel: () {
          Get.back();
        },
        controller: this,
        title: "complete_profile".tr,
        subTitle: "complete_profile_error".tr,
        confirmTitle: "proceed".tr,
        image: ImageResource.instance.completeProfilePlantIcon,
        height: 370,
      ),
      dismissible: false,
      isFlip: true,
    );
  }

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


  /// selected image
  Rx<File> selectedImage = File("").obs;
  var selectedImageError = "".obs;

  VoidCallback get imgFromGallery => (){
    FileResource.instance.imagePickerFromGallery().then((pickedFile){
      if(pickedFile.path!=""){
        selectedImage.value = File(pickedFile.path);
        Get.back();
        warningPopup(Get.context!,this);
      }
    } );
  };
  VoidCallback get imgFromCamera => (){
    FileResource.instance.imagePickerFromCamara().then((pickedFile){
      if(pickedFile.path!=""){
        selectedImage.value = File(pickedFile.path);
        Get.back();
        warningPopup(Get.context!,this);
      }
    } );
  };
  void warningPopup(context,controller) {
    showAnimatedDialog(
        Get.context!,
        WarningPopup(
            onConfirm:() async {
              Get.back();
              scanType.value == 2 ? sendIdentifyData() : Get.toNamed(Routes.questionsScreen,arguments: {"image":selectedImage.value});
            }, onCancel: () {
          Get.back();
        },controller:  controller),
        dismissible: false,
        isFlip: true);
  }
  /// send identify Data
  Rx<SingleResponse<IdentifyDetailModel>> identifyPlantData = SingleResponse<IdentifyDetailModel>(data: IdentifyDetailModel()).obs;
  Future sendIdentifyData() async {
    loadingPopup(this);
    try {
      form.FormData identifyData = form.FormData.fromMap({
        "image": await form.MultipartFile.fromFile(selectedImage.value.path, filename: selectedImage.value.path.split('/').last,),
        "location": "${Get.find<AuthService>().userIp.value.city},${Get.find<AuthService>().userIp.value.regionName},${Get.find<AuthService>().userIp.value.country}",
      });
      await homeProvider.submitIdentifyData(formData: identifyData,onError: (errorMessage) {
        
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
          identifyPlantData.value = SingleResponse<IdentifyDetailModel>.fromJson(data ?? {}, (data) => IdentifyDetailModel.fromJson(data));
          Get.toNamed(Routes.plantsDetailScreen,arguments: {"type":3,"data":identifyPlantData.value})?.then((value){
            Get.find<RootViewController>().onInit();
            onInit();
          });
        }

      });
    } catch (e) {
      dismissLoadingPopup();
      ("error ${e.toString()}").logPrint();
    }
  }

  void diagnoseTap()async{
    await checkPermission.call();
  }

  /// get trending plant data

  RxBool isTrendingLoading = false.obs;
  Rx<SingleResponse<SearchResultModel>> trendingPlantData = SingleResponse<SearchResultModel>(data: SearchResultModel()).obs;
  Future trendingPlantsApi() async {
    isTrendingLoading.call(true);
    try {
      Map<String, dynamic> getCollectionPlantData ={
        "is_trending":1,
        "paginate": 10,
        "page":1
      };
      await homeProvider.searchPlants(getCollectionPlantData,onError: (errorMessage) {
        
        isTrendingLoading.call(false);
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        isTrendingLoading.call(false);
        trendingPlantData.value = SingleResponse<SearchResultModel>.fromJson(data??{}, (data) => SearchResultModel.fromJson(data));
      });
    } catch (e) {
      isTrendingLoading.call(false);
      (e).logPrint();
    }
  }


  /// get plant index categories
  RxBool isPlantIndexLoading = false.obs;
  Rx<SingleResponse<PlantCategoriesModel>> plantIndexData = SingleResponse<PlantCategoriesModel>(data: PlantCategoriesModel()).obs;
  Future plantIndexApi() async {
    isPlantIndexLoading.call(true);
    try {
      Map<String, dynamic> getCollectionPlantData ={
        "paginate": 50,
        "page":1
      };
      await homeProvider.getPlantIndexCategories(getCollectionPlantData,onError: (errorMessage) {
        
        isPlantIndexLoading.call(false);
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        isPlantIndexLoading.call(false);
        plantIndexData.value = SingleResponse<PlantCategoriesModel>.fromJson(data??{}, (data) => PlantCategoriesModel.fromJson(data));
      });
    } catch (e) {
      isPlantIndexLoading.call(false);
      (e).logPrint();
    }
  }
  @override
  void onInit() async{
    await trendingPlantsApi();
    await plantIndexApi();
    await getArticleList();
    await getTips();
    super.onInit();
  }


  void onRefresh() async {
    Get.find<RootViewController>().onRefresh();
    await trendingPlantsApi();
    await plantIndexApi();
    await getArticleList();
    await getTips();
    super.onInit();
  }

}
