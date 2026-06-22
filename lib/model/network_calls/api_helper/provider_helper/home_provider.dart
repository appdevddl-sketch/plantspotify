
import 'package:plants_spotify/model/model/network_call_model/api_response.dart';
import 'package:plants_spotify/model/network_calls/api_helper/repository_helper/home_repo.dart';

import 'package:plants_spotify/model/network_calls/dio_client/check_api_response.dart';
import 'package:dio/dio.dart';
class HomeProvider {
  final HomeRepo homeRepo;
  HomeProvider({required this.homeRepo});


  /// get Tips
  Future getTips({required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await homeRepo.getTips();
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// Search
  Future searchPlants(Map<String, dynamic> searchPlantsBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await homeRepo.searchPlants(searchPlantsBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// Get Plants Body
  Future getPlantDetails(Map<String, dynamic> getPlantDetailsBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await homeRepo.getPlantDetails(getPlantDetailsBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// Get Articles
  Future getArticles(Map<String, dynamic> getArticlesBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await homeRepo.getArticles(getArticlesBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// Get Articles Detail
  Future getArticleDetail(Map<String, dynamic> getArticleDetailBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await homeRepo.getArticleDetail(getArticleDetailBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// Get Notifications
  Future getNotifications(Map<String, dynamic> getNotificationsBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await homeRepo.getNotifications(getNotificationsBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// Get Notifications
  Future getDiagnosisQuestions({required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await homeRepo.getDiagnosisQuestions();
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// Submit Diagnosis Data
  Future submitDiagnosisData({required FormData formData ,onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await homeRepo.submitDiagnosisData(formData);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }
  /// get feedback Questions
  Future getFeedbackQuestions({required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await homeRepo.getFeedbackQuestions();
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }
  /// Submit Feedback Data
  Future submitFeedbackData({required FormData formData ,onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await homeRepo.submitFeedbackData(formData);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }
  /// submit Identify Data
  Future submitIdentifyData({required FormData formData ,onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await homeRepo.submitIdentifyData(formData);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// Get Plant Index Categories Body
  Future getPlantIndexCategories(Map<String, dynamic> plantCategoriesBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await homeRepo.getPlantIndexCategories(plantCategoriesBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }




}
