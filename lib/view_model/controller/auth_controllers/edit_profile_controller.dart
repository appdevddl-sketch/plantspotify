
import 'package:flutter/material.dart';
import 'package:plants_spotify/model/model/auth_model/country_model.dart';
import 'package:plants_spotify/model/model/auth_model/login_user_model.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/services/auth_service.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/widgets/pagination_view/pagination_view_screen.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view/widgets/toast_view/showtoast.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';


import '../../../model/network_calls/api_helper/provider_helper/auth_provider.dart';
import '../../../model/network_calls/dio_client/get_it_instance.dart';

import 'package:get/get.dart';

class EditProfileController extends BaseViewController{
  AuthProvider authProvider = getIt();


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController  = TextEditingController(text: Get.find<AuthService>().user.value.name);
  TextEditingController ageController  = TextEditingController(text: Get.find<AuthService>().user.value.age == null ?"" : Get.find<AuthService>().user.value.age.toString());


  var nameError = "".obs;
  var ageError = "".obs;
  var homeTypeError = "".obs;
  var countryError = "".obs;
  var profileImageError = "".obs;


  Rx<HomeType> selectedHomeTypeValue = HomeType().obs;

  RxList<HomeType> typeList = <HomeType>[].obs;
  @override
  void onInit() async{
    await getHomeTypes();
    selectedHomeTypeValue.value = Get.find<AuthService>().user.value.homeType ?? HomeType();
    selectedCountry.value = CountryData(id: Get.find<AuthService>().user.value.countryId,name: Get.find<AuthService>().user.value.countryName,countryCode: Get.find<AuthService>().user.value.countryCode);
    getCountryList(pageNumber: 1, forPaginate: false);
    super.onInit();
  }

  void updateProfile()async{
    if((formKey.currentState?.validate()??false) && selectedHomeTypeValue.value.id != null && selectedCountry.value.id != null){

    isLoading.call(true);
    try {
      Map<String, dynamic> updateProfileData ={
        "name": nameController.text,
        "age": ageController.text,
        "home_type_id":  selectedHomeTypeValue.value.id ,
        "location_address": "${Get.find<AuthService>().userIp.value.city}, ${Get.find<AuthService>().userIp.value.regionName}, ${Get.find<AuthService>().userIp.value.country}",
        "country_code": selectedCountry.value.countryCode,
        "country_id": selectedCountry.value.id,
        "country_name": selectedCountry.value.name,
        "latitude": Get.find<AuthService>().userIp.value.lat,
        "longitude": Get.find<AuthService>().userIp.value.lon,
      };
      await authProvider.updateProfile(updateProfileData, onError: (errorMessage) {
        
        ("errorMessage=> $errorMessage").logPrint();
        isLoading.call(false);
      }, onSuccess: (message, data) async {
        SingleResponse<User> loginModel = SingleResponse<User>.fromJson(data??{},(data)=>User.fromJson(data));
        if (loginModel.status == true) {
          toastShow(message: loginModel.message??"", error: false);
          await Get.find<AuthService>().saveUser(loginModel.data.toJson()??{});
          isLoading.call(false);
          Get.offAllNamed(Routes.rootView);
        } else {
          isLoading.call(false);
        }
      });
    } catch (e) {
      ("this is error ${e.toString()}").logPrint();
      isLoading.call(false);
    }

  }else if(selectedHomeTypeValue.value.id == null){
      homeTypeError.value = "please_select_home_type".tr;
    }else if(selectedCountry.value.id == null){
      countryError.value = "please_select_country".tr;
    }
  }
  // Rx<SingleResponse<HomeType>> articleDetailData = SingleResponse<HomeType>(data: HomeType()).obs;
  RxBool isHomeTypeLoading = false.obs;
  Future getHomeTypes()async {
    isHomeTypeLoading.call(true);
    try {
      await authProvider.getHomeType(onError: (errorMessage) {
        
        isHomeTypeLoading.call(false);
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        isHomeTypeLoading.call(false);
        ListResponse<HomeType> homeTypes = ListResponse<HomeType>.fromJson(data ?? {}, (e) => HomeType.fromJson(e),);
        typeList.value = homeTypes.data;
      });
    } catch (e) {
      isHomeTypeLoading.call(false);
      ("error ${e.toString()}").logPrint();
    }
  }

  /// get countries
  RxBool isCountriesLoading = false.obs;
  Rx<CountryData> selectedCountry = CountryData().obs;
  Rx<SingleResponse<CountryModel>> countriesData = SingleResponse<CountryModel>(data: CountryModel()).obs;
  PaginationViewController<CountryData> countriesPlantPaginationViewController = PaginationViewController(
      showMessage: "no_data_found".tr,
      totalPageCont: 0,
      onScrollDownDone: (bool value, int pageNumber) {},
      itemList: <CountryData>[].obs
  );
  Future getCountryList({required int pageNumber,required bool forPaginate}) async {
    isCountriesLoading.call(true);
    try {
      if(forPaginate){
        countriesPlantPaginationViewController.isLoading.call(true);
      }
      Map<String, dynamic> getCollectionPlantData ={
        "paginate": 200,
        "page":pageNumber
      };
      await authProvider.getCountries(getCollectionPlantData,onError: (errorMessage) {
        
        isCountriesLoading.call(false);
        toastShow(message: errorMessage??"", error: true);
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        isCountriesLoading.call(false);
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
      isCountriesLoading.call(false);
      (e).logPrint();
      countriesPlantPaginationViewController.isLoading.call(false);
    }
  }



}


