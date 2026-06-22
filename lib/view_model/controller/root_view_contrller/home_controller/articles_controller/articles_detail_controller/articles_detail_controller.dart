import 'package:flutter/material.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/articel_list_model.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/articleDetailModel.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/home_provider.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/network_calls/dio_client/get_it_instance.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';




class ArticlesDetailController extends BaseViewController {
HomeProvider homeProvider = getIt();
  TextEditingController searchController  = TextEditingController();

  var searchError = "".obs;


  ArticleListData backScreenData = ArticleListData();

  @override
  void onInit() async{

    backScreenData = Get.arguments??{};
    await getArticleDetail();
    super.onInit();
  }


Rx<SingleResponse<ArticelDetailsModel>> articleDetailData = SingleResponse<ArticelDetailsModel>(data: ArticelDetailsModel()).obs;

  Future getArticleDetail()async {
    isLoading.call(true);
    try {
      Map<String, dynamic> getArticleDetailData ={
        "id": backScreenData.id,
      };
      await homeProvider.getArticleDetail(getArticleDetailData,onError: (errorMessage) {
        
        isLoading.call(false);
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        isLoading.call(false);
        articleDetailData.value = SingleResponse<ArticelDetailsModel>.fromJson(data ?? {}, (data) => ArticelDetailsModel.fromJson(data));

      });
    } catch (e) {
      isLoading.call(false);
      ("error ${e.toString()}").logPrint();
    }
  }




}
