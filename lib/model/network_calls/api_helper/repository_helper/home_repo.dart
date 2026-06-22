




import 'package:dio/dio.dart';
import 'package:plants_spotify/model/model/network_call_model/api_response.dart';
import 'package:plants_spotify/model/network_calls/dio_client/dio_client.dart';
import 'package:plants_spotify/model/network_calls/exception/api_error_handler.dart';
import 'package:plants_spotify/model/utils/app_constants.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';

class HomeRepo {

  final DioClient dioClient;
  HomeRepo({
    required this.dioClient,
  });


  /// getTips
  Future<ApiResponse> getTips() async {
    try {
      Response response = await dioClient.get(AppConstants.instance.getTips);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// search
  Future<ApiResponse> searchPlants(Map<String, dynamic> searchPlantsBody) async {
    try {
      Response response = await dioClient.get("${AppConstants.instance.searchPlants}?query=${searchPlantsBody["query"]??""}&paginate=${searchPlantsBody["paginate"]}&page=${searchPlantsBody["page"]}&location=${searchPlantsBody["location"]??""}&category_id=${searchPlantsBody["category_id"]??""}&country_id=${searchPlantsBody["country_id"]??""}&is_trending=${searchPlantsBody["is_trending"]??""}");
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// get Plant Details
  Future<ApiResponse> getPlantDetails(Map<String, dynamic> getPlantDetailsBody) async {
    try {
      Response response = await dioClient.get("${AppConstants.instance.plants}/${getPlantDetailsBody["id"]}");
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// get Articles
  Future<ApiResponse> getArticles(Map<String, dynamic> getArticlesBody) async {
    try {
      Response response = await dioClient.get("${AppConstants.instance.articles}?search=${getArticlesBody['search']??""}&paginate=${getArticlesBody['paginate']}&page=${getArticlesBody['page']}");
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// get Articles Details
  Future<ApiResponse> getArticleDetail(Map<String, dynamic> getArticleDetailBody) async {
    try {
      Response response = await dioClient.get("${AppConstants.instance.articles}/${getArticleDetailBody['id']}");
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// get Notifications
  Future<ApiResponse> getNotifications(Map<String, dynamic> getNotificationsBody) async {
    try {
      Response response = await dioClient.get("${AppConstants.instance.getNotifications}?paginate=${getNotificationsBody['paginate']}&page=${getNotificationsBody['page']}");
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  /// get diagnosis questions
  Future<ApiResponse> getDiagnosisQuestions() async {
    try {
      Response response = await dioClient.get(AppConstants.instance.getDiagnosisQuestions);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// send diagnose data
  Future<ApiResponse> submitDiagnosisData(FormData data) async {
    try {
      Response response = await dioClient.post(AppConstants.instance.diagnose,data: data);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// get feedback questions
  Future<ApiResponse> getFeedbackQuestions() async {
    try {
      Response response = await dioClient.get(AppConstants.instance.getFeedbackQuestions);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// submit  feedback questions
  Future<ApiResponse> submitFeedbackData(FormData data) async {
    try {
      Response response = await dioClient.post(AppConstants.instance.submitFeedbackData,data: data);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// submit identify data
  Future<ApiResponse> submitIdentifyData(FormData data) async {
    try {
      Response response = await dioClient.post(AppConstants.instance.identify,data: data);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  /// search
  Future<ApiResponse> getPlantIndexCategories(Map<String, dynamic> plantCategoriesBody) async {
    try {
      Response response = await dioClient.get("${AppConstants.instance.getPlantIndexCategories}?paginate=${plantCategoriesBody["paginate"]}&page=${plantCategoriesBody["page"]}");
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }




}
