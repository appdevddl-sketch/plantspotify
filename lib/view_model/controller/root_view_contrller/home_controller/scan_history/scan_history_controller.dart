import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plants_spotify/model/model/root_view_models/accountview_models/scan_history_list_model.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/diagnose_details_model.dart';

import 'package:plants_spotify/model/model/root_view_models/home_view_models/identify_detail_model.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/account_option_provider.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/network_calls/dio_client/get_it_instance.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view/widgets/app_common/custom_popup/loader_popup.dart';
import 'package:plants_spotify/view/widgets/button_view/animated_box.dart';
import 'package:plants_spotify/view/widgets/pagination_view/pagination_view_screen.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view/widgets/toast_view/showtoast.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';
import 'package:wakelock_plus/wakelock_plus.dart';




class ScanHistoryController extends BaseViewController {
  AccountOptionProvider accountOptionProvider = getIt();
  TextEditingController searchController  = TextEditingController();


  var searchError = "".obs;

  /// get plant collection data
  Rx<SingleResponse<ScanHistoryListModel>> scanHistoryData = SingleResponse<ScanHistoryListModel>(data: ScanHistoryListModel()).obs;
  PaginationViewController<ScanLisData> scanHistoryPaginationViewController = PaginationViewController(
      showMessage: "no_data_found".tr,
      totalPageCont: 0,
      onScrollDownDone: (bool value, int pageNumber) {},
      itemList: <ScanLisData>[].obs
  );
  Future searchPlantsApi({required int pageNumber,required bool forPaginate}) async {
    try {
      if(forPaginate){
        scanHistoryPaginationViewController.isLoading.call(true);
      }
      Map<String, dynamic> getScanHistoryListData ={
        "search": searchController.text,
        "paginate": 10,
        "page":pageNumber
      };
      await accountOptionProvider.getScanHistoryList(getScanHistoryListData,onError: (errorMessage) {
        
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        if(data != null){
          scanHistoryData.value = SingleResponse<ScanHistoryListModel>.fromJson(data??{}, (data) => ScanHistoryListModel.fromJson(data));
          scanHistoryPaginationViewController.totalPageCont = scanHistoryData.value.data.pagination?.lastPage ?? 0;
          scanHistoryPaginationViewController.onScrollDownDone = (bool value, int pageNumber) {
            if (value) {
              searchPlantsApi(pageNumber: pageNumber,forPaginate: true);
            }
          };
          if(forPaginate){
            scanHistoryPaginationViewController.itemList.addAll(scanHistoryData.value.data.data ?? []);
            scanHistoryPaginationViewController.isLoading.call(false);
          }else{
            scanHistoryPaginationViewController.itemList.value = scanHistoryData.value.data.data ?? [];
          }
        }
      });
    } catch (e) {
      (e).logPrint();
      scanHistoryPaginationViewController.isLoading.call(false);
    }
  }

  /// send identify Data
  Rx<SingleResponse<IdentifyDetailModel>> identifyPlantData = SingleResponse<IdentifyDetailModel>(data: IdentifyDetailModel()).obs;
  Rx<SingleResponse<DiagnoseDetailModel>> plantDiagnoseDetailData = SingleResponse<DiagnoseDetailModel>(data: DiagnoseDetailModel()).obs;

  Future getScanHistoryDetail({required ScanLisData scanListData}) async {
    loadingPopup(this);
    try {
      Map<String, dynamic> getScanHistoryListData ={
        "id": scanListData.id,
      };
      await accountOptionProvider.getScanHistoryDetail(getScanHistoryListData,onError: (errorMessage) {
        
        dismissLoadingPopup();
        toastShow(message: errorMessage??"", error: true);
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        dismissLoadingPopup();
        if(scanListData.scanType?.toLowerCase() == "identify" || scanListData.scanType?.toLowerCase() == "search"){
          identifyPlantData.value = SingleResponse<IdentifyDetailModel>.fromJson(data ?? {}, (data) => IdentifyDetailModel.fromJson(data));
          Get.toNamed(Routes.plantsDetailScreen,arguments: {"type":3,"data":identifyPlantData.value});
        }else{
          plantDiagnoseDetailData.value = SingleResponse<DiagnoseDetailModel>.fromJson(data ?? {}, (data) => DiagnoseDetailModel.fromJson(data));
          Get.toNamed(Routes.diagnosticsDetailScreen,arguments: {"type":1,"data":plantDiagnoseDetailData.value.data});
        }

      });
    } catch (e) {
      dismissLoadingPopup();
      ("error ${e.toString()}").logPrint();
    }
  }
  void searchScanHistory(){
    if (searchController.text.isNotEmpty) {
      EasyDebounce.cancel('search_history');
      EasyDebounce.debounce(
          'search_history',
          const Duration(milliseconds: 300),
              () {
                scanHistoryData.value = SingleResponse<ScanHistoryListModel>(data: ScanHistoryListModel(),);
                scanHistoryPaginationViewController.itemList.clear();
                searchPlantsApi(pageNumber: 1, forPaginate: false);
          }
      );
    }else {
      searchPlantsApi(pageNumber: 1, forPaginate: false);
    }
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

  @override
  void onInit() {
    // TODO: implement onInit
    searchPlantsApi(pageNumber: 1, forPaginate: false);
    super.onInit();
  }
}
