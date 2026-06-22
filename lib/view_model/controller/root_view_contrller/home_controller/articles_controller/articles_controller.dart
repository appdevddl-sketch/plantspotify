import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/articel_list_model.dart';
import 'package:plants_spotify/model/model/root_view_models/nursery_models/collection_plants_model.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/home_provider.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/network_calls/dio_client/get_it_instance.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view/widgets/pagination_view/pagination_view_screen.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';




class ArticlesController extends BaseViewController {
  HomeProvider homeProvider = getIt();
  TextEditingController searchController  = TextEditingController();

  var searchError = "".obs;


  /// get plant collection data
  Rx<SingleResponse<ArticelListModel>> articleListData = SingleResponse<ArticelListModel>(data: ArticelListModel()).obs;
  PaginationViewController<ArticleListData> articleListPaginationViewController = PaginationViewController(
      showMessage: "no_data_found".tr,
      totalPageCont: 0,
      onScrollDownDone: (bool value, int pageNumber) {},
      itemList: <ArticleListData>[].obs
  );
  Future getArticleList({required int pageNumber,required bool forPaginate}) async {
    try {
      if(forPaginate){
        articleListPaginationViewController.isLoading.call(true);
      }
      Map<String, dynamic> getCollectionPlantData ={
        "id": 3,
        "search": searchController.text,
        "paginate": 10,
        "page":pageNumber
      };
      await homeProvider.getArticles(getCollectionPlantData,onError: (errorMessage) {
        
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        if (data != null) {
          articleListData.value = SingleResponse<ArticelListModel>.fromJson(
              data ?? {}, (data) => ArticelListModel.fromJson(data));
          articleListPaginationViewController.totalPageCont =
              articleListData.value.data.pagination?.lastPage ?? 0;
          articleListPaginationViewController.onScrollDownDone =
              (bool value, int pageNumber) {
            if (value) {
              getArticleList(pageNumber: pageNumber, forPaginate: true);
            }
          };
          if (forPaginate) {
            articleListPaginationViewController.itemList.addAll(
                articleListData.value.data.data ?? []);
            articleListPaginationViewController.isLoading.call(false);
          } else {
            articleListPaginationViewController.itemList.value =
                articleListData.value.data.data ?? [];
          }
        }
      });
    } catch (e) {
      (e).logPrint();
      articleListPaginationViewController.isLoading.call(false);
    }
  }
  void searchArticles(){
    if (searchController.text.isNotEmpty) {
      EasyDebounce.cancel('search_articles');
      EasyDebounce.debounce(
          'search_articles',
          const Duration(milliseconds: 300),
              () {
            articleListData.value = SingleResponse<ArticelListModel>(data: ArticelListModel(),);
            articleListPaginationViewController.itemList.clear();
            getArticleList(pageNumber: 1,forPaginate: false);
          }
      );
    }else{
      getArticleList(pageNumber: 1,forPaginate: false);
    }
  }
  @override
  void onInit() {
    // TODO: implement onInit
    getArticleList(pageNumber: 1,forPaginate: false);
    super.onInit();
  }

}
