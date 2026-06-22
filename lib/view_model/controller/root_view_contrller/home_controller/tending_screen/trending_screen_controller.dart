


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


class TrendingScreenController extends BaseViewController {
  HomeProvider homeProvider = getIt();


  /// get trending plant data
  Rx<SingleResponse<SearchResultModel>> trendingPlantData = SingleResponse<SearchResultModel>(data: SearchResultModel()).obs;
  PaginationViewController<SearchPlantData> trendingPlantPaginationViewController = PaginationViewController(
      showMessage: "no_data_found".tr,
      totalPageCont: 0,
      onScrollDownDone: (bool value, int pageNumber) {},
      itemList: <SearchPlantData>[].obs
  );
  Future trendingPlantsApi({required int pageNumber,required bool forPaginate}) async {
    try {
      if(forPaginate){
        trendingPlantPaginationViewController.isLoading.call(true);
      }
      Map<String, dynamic> getCollectionPlantData ={
        "is_trending":1,
        "country_id":Get.find<AuthService>().user.value.countryId,
        "paginate": 20,
        "page":pageNumber
      };
      await homeProvider.searchPlants(getCollectionPlantData,onError: (errorMessage) {
        
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        trendingPlantData.value = SingleResponse<SearchResultModel>.fromJson(data??{}, (data) => SearchResultModel.fromJson(data));
        trendingPlantPaginationViewController.totalPageCont = 1;
        trendingPlantPaginationViewController.onScrollDownDone = (bool value, int pageNumber) {
          if (value) {
            trendingPlantsApi(pageNumber: pageNumber,forPaginate: false);
          }
        };
        if(forPaginate){
          trendingPlantPaginationViewController.itemList.addAll(trendingPlantData.value.data.data ?? []);
          trendingPlantPaginationViewController.isLoading.call(false);
        }else{
          trendingPlantPaginationViewController.itemList.value = trendingPlantData.value.data.data ?? [];
        }
      });
    } catch (e) {
      (e).logPrint();
      trendingPlantPaginationViewController.isLoading.call(false);
      trendingPlantPaginationViewController.isLoading.call(false);
    }
  }
  @override
  void onInit() {
    // TODO: implement onInit
    trendingPlantsApi(pageNumber: 1, forPaginate: false);
    super.onInit();
  }
}
