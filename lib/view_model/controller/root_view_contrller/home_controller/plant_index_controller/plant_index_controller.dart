


import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:plants_spotify/model/model/auth_model/country_model.dart';

import 'package:plants_spotify/model/model/root_view_models/home_view_models/plant_categories_model.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/search_results_model.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/auth_provider.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/home_provider.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/network_calls/dio_client/get_it_instance.dart';
import 'package:plants_spotify/model/services/auth_service.dart';

import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view/widgets/pagination_view/pagination_view_screen.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view/widgets/toast_view/showtoast.dart';


class PlantIndexController extends BaseViewController with GetSingleTickerProviderStateMixin {
  HomeProvider homeProvider = getIt();
  AuthProvider authProvider = getIt();
  TextEditingController searchController = TextEditingController();
  Map<String,dynamic> backData ={};

  var searchError = "".obs;

  /// custom tabs
  late TabController pageController;
  Rx<PlantCategoryData> selectCategory = PlantCategoryData().obs;
  List<PlantCategoryData> orderCategory = <PlantCategoryData>[].obs;

  /// index menu list


  void onChangeButtonTapped(PlantCategoryData data) {
    selectCategory.value = data;
    getPlantCategoryDataApi(pageNumber: 1, forPaginate: false);
  }

  // get plant index categories
  Rx<SingleResponse<PlantCategoriesModel>> plantIndexData = SingleResponse<PlantCategoriesModel>(data: PlantCategoriesModel()).obs;
  Future plantIndexApi() async {
    try {
      Map<String, dynamic> getCollectionPlantData ={
        "paginate": 50,
        "page":1
      };
      await homeProvider.getPlantIndexCategories(getCollectionPlantData,onError: (errorMessage) {
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        plantIndexData.value = SingleResponse<PlantCategoriesModel>.fromJson(data??{}, (data) => PlantCategoriesModel.fromJson(data));
        if(backData['type']==2){
          onChangeButtonTapped(backData['data']);
        }else{
          selectCategory.value =  plantIndexData.value.data.data?.first??PlantCategoryData();
          getPlantCategoryDataApi(pageNumber: 1, forPaginate: false);
        }
      });
    } catch (e) {
      (e).logPrint();

    }
  }

  /// category data

  Rx<SingleResponse<SearchResultModel>> searchPlantData = SingleResponse<SearchResultModel>(data: SearchResultModel()).obs;
  PaginationViewController<SearchPlantData> searchPlantPaginationViewController = PaginationViewController(
      showMessage: "no_data_found".tr,
      totalPageCont: 0,
      onScrollDownDone: (bool value, int pageNumber) {},
      itemList: <SearchPlantData>[].obs
  );
  Future getPlantCategoryDataApi({required int pageNumber,required bool forPaginate}) async {
    searchPlantData.value = SingleResponse<SearchResultModel>(data: SearchResultModel(),);
    try {
      if(forPaginate){
        searchPlantPaginationViewController.isLoading.call(true);
      }
      Map<String, dynamic> getCollectionPlantData ={
        "query": searchController.text,
        "paginate": 10,
        "country_id": selectedCountry.value.id,
        "category_id": selectCategory.value.id,
        "location": "${Get.find<AuthService>().userIp.value.city},${Get.find<AuthService>().userIp.value.regionName},${Get.find<AuthService>().userIp.value.country}",
        "page":pageNumber
      };
      await homeProvider.searchPlants(getCollectionPlantData,onError: (errorMessage) {
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        searchPlantData.value = SingleResponse<SearchResultModel>.fromJson(data??{}, (data) => SearchResultModel.fromJson(data));
        searchPlantPaginationViewController.totalPageCont = searchPlantData.value.data.pagination?.lastPage ?? 0;
        searchPlantPaginationViewController.onScrollDownDone = (bool value, int pageNumber) {
          if (value) {
            getPlantCategoryDataApi(pageNumber: pageNumber,forPaginate: true);
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
          const Duration(milliseconds: 300),
              () {
            searchPlantData.value = SingleResponse<SearchResultModel>(data: SearchResultModel(),);
            searchPlantPaginationViewController.itemList.clear();
            getPlantCategoryDataApi(pageNumber: 1, forPaginate: false);
          }
      );
    }else{
      searchPlantData.value = SingleResponse<SearchResultModel>(data: SearchResultModel(),);
      searchPlantPaginationViewController.itemList.clear();
    }
  }

  /// get countries
  Rx<CountryData> selectedCountry = CountryData().obs;
  Rx<SingleResponse<CountryModel>> countriesData = SingleResponse<CountryModel>(data: CountryModel()).obs;
  PaginationViewController<CountryData> countriesPlantPaginationViewController = PaginationViewController(
      showMessage: "no_data_found".tr,
      totalPageCont: 0,
      onScrollDownDone: (bool value, int pageNumber) {},
      itemList: <CountryData>[].obs
  );
  Future getCountryList({required int pageNumber,required bool forPaginate}) async {
    try {
      if(forPaginate){
        countriesPlantPaginationViewController.isLoading.call(true);
      }
      Map<String, dynamic> getCollectionPlantData ={
        "paginate": 200,
        "page":pageNumber
      };
      await authProvider.getCountries(getCollectionPlantData,onError: (errorMessage) {
        toastShow(message: errorMessage??"", error: true);
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        if(data != null){
          countriesData.value = SingleResponse<CountryModel>.fromJson(data??{}, (data) => CountryModel.fromJson(data));
          countriesPlantPaginationViewController.totalPageCont = countriesData.value.data.pagination?.lastPage ?? 0;
          countriesPlantPaginationViewController.onScrollDownDone = (bool value, int pageNumber) {
            if (value) {
              getCountryList(pageNumber: pageNumber,forPaginate: true);
            }
          };
          if(forPaginate){
            countriesPlantPaginationViewController.itemList.addAll(countriesData.value.data.data ?? []);
            countriesPlantPaginationViewController.isLoading.call(false);
          }else{
            countriesPlantPaginationViewController.itemList.value = countriesData.value.data.data ?? [];
          }
        }
      });
    } catch (e) {
      (e).logPrint();
      countriesPlantPaginationViewController.isLoading.call(false);
    }
  }

  @override
  void onInit() async {
    backData=Get.arguments??{};
    backData.logPrint();
    selectedCountry.value = CountryData(id: Get.find<AuthService>().user.value.countryId,name: Get.find<AuthService>().user.value.countryName,countryCode: Get.find<AuthService>().user.value.countryCode);
    await plantIndexApi();
    await getCountryList(pageNumber: 1, forPaginate: false);
    super.onInit();
  }
}


