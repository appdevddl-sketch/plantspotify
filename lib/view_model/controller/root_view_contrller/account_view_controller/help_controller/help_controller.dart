import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plants_spotify/model/model/root_view_models/accountview_models/faq_model.dart';
import 'package:plants_spotify/model/model/root_view_models/nursery_models/collection_plants_model.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/account_option_provider.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/network_calls/dio_client/get_it_instance.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view/widgets/pagination_view/pagination_view_screen.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';




class HelpController extends BaseViewController {
  AccountOptionProvider accountOptionProvider = getIt();



  /// get Help questions
  Rx<SingleResponse<FaqModel>> faqData = SingleResponse<FaqModel>(data: FaqModel()).obs;
  PaginationViewController<FaqData> faqPaginationViewController = PaginationViewController(
      showMessage: "no_data_found".tr,
      totalPageCont: 0,
      onScrollDownDone: (bool value, int pageNumber) {},
      itemList: <FaqData>[].obs
  );
  Future getFaq({required int pageNumber,required bool forPaginate}) async {
    try {
      if(forPaginate){
        faqPaginationViewController.isLoading.call(true);
      }
      Map<String, dynamic> getCollectionPlantData ={
        "paginate": 10,
        "page":pageNumber
      };
      await accountOptionProvider.getFaq(getCollectionPlantData,onError: (errorMessage) {
        
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        faqData.value = SingleResponse<FaqModel>.fromJson(data??{}, (data) => FaqModel.fromJson(data));
        faqPaginationViewController.totalPageCont = faqData.value.data.pagination?.lastPage ?? 0;
        faqPaginationViewController.onScrollDownDone = (bool value, int pageNumber) {
          if (value) {
            getFaq(pageNumber: pageNumber,forPaginate: true);
          }
        };
        if(forPaginate){
          faqPaginationViewController.itemList.addAll(faqData.value.data.data ?? []);
          faqPaginationViewController.isLoading.call(false);
        }else{
          faqPaginationViewController.itemList.value = faqData.value.data.data ?? [];
        }
      });
    } catch (e) {
      (e).logPrint();
      faqPaginationViewController.isLoading.call(false);
    }
  }
@override
  void onInit() {
    // TODO: implement onInit
    getFaq(pageNumber: 1,forPaginate: false);
    super.onInit();
  }
}
