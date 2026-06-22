


import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/search_results_model.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/home_provider.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/network_calls/dio_client/get_it_instance.dart';
import 'package:plants_spotify/model/services/auth_service.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view/widgets/pagination_view/pagination_view_screen.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:wakelock_plus/wakelock_plus.dart';


class SearchScreenController extends BaseViewController {
  HomeProvider homeProvider = getIt();
  TextEditingController searchController  = TextEditingController();
  var searchError = "".obs;

  /// get plant collection data
  Rx<SingleResponse<SearchResultModel>> searchPlantData = SingleResponse<SearchResultModel>(data: SearchResultModel()).obs;
  PaginationViewController<SearchPlantData> searchPlantPaginationViewController = PaginationViewController(
      showMessage: "no_data_found".tr,
      totalPageCont: 0,
      onScrollDownDone: (bool value, int pageNumber) {},
      itemList: <SearchPlantData>[].obs
  );
  Future searchPlantsApi({required int pageNumber,required bool forPaginate}) async {
    WakelockPlus.enable();
    try {
      if(forPaginate){
        searchPlantPaginationViewController.isLoading.call(true);
      }
      Map<String, dynamic> getCollectionPlantData ={
        "query": searchController.text,
        "paginate": 10,
        "location": "${Get.find<AuthService>().userIp.value.city},${Get.find<AuthService>().userIp.value.regionName},${Get.find<AuthService>().userIp.value.country}",
        "page":pageNumber
      };
      await homeProvider.searchPlants(getCollectionPlantData,onError: (errorMessage) {
        WakelockPlus.disable();
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        WakelockPlus.disable();
        searchPlantData.value = SingleResponse<SearchResultModel>.fromJson(data??{}, (data) => SearchResultModel.fromJson(data));
        searchPlantPaginationViewController.totalPageCont = searchPlantData.value.data.pagination?.lastPage ?? 0;
        searchPlantPaginationViewController.onScrollDownDone = (bool value, int pageNumber) {
          if (value) {
            searchPlantsApi(pageNumber: pageNumber,forPaginate: true);
          }
        };
        if(forPaginate){
          searchPlantPaginationViewController.itemList.addAll(searchPlantData.value.data.data ?? []);
          searchPlantPaginationViewController.isLoading.call(false);
        }else{
          searchPlantPaginationViewController.itemList.value = searchPlantData.value.data.data ?? [];
        }
      });
    } catch (e) {
      WakelockPlus.disable();
      (e).logPrint();
      searchPlantPaginationViewController.isLoading.call(false);
      searchPlantPaginationViewController.isLoading.call(false);
    }
  }
  void searchPlants(){
    if (searchController.text.isNotEmpty) {
      EasyDebounce.cancel('search_Plant');
      EasyDebounce.debounce(
          'search_Plant',
          const Duration(milliseconds: 700),
              () {
                searchPlantData.value = SingleResponse<SearchResultModel>(data: SearchResultModel(),);
                searchPlantPaginationViewController.itemList.clear();
                searchPlantsApi(pageNumber: 1, forPaginate: false);
          }
      );
    }else{
      searchPlantData.value = SingleResponse<SearchResultModel>(data: SearchResultModel(),);
      searchPlantPaginationViewController.itemList.clear();
    }
  }
}
