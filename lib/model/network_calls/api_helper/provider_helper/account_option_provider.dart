

import 'package:dio/dio.dart';
import 'package:plants_spotify/model/model/network_call_model/api_response.dart';
import 'package:plants_spotify/model/network_calls/api_helper/repository_helper/account_option_repo.dart';
import 'package:plants_spotify/model/network_calls/api_helper/repository_helper/auth_repo.dart';
import 'package:plants_spotify/model/network_calls/dio_client/check_api_response.dart';

class AccountOptionProvider {
  final AccountOptionRepo accountOptionRepo;
  AccountOptionProvider({required this.accountOptionRepo});

  /// get faq
  Future getFaq(Map<String, dynamic> getFaqBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await accountOptionRepo.getFaq(getFaqBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// contact Us
  Future contactUs(Map<String, dynamic> contactUsBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await accountOptionRepo.contactUs(contactUsBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// get subscription plans
  Future getSubscriptionPlans({required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await accountOptionRepo.getSubscriptionPlans();
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// subscription purchase
  Future subscriptionPurchase(Map<String, dynamic> subscriptionPurchaseBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await accountOptionRepo.subscriptionPurchase(subscriptionPurchaseBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// subscription cancel
  Future subscriptionCancel(Map<String, dynamic> subscriptionCancelBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await accountOptionRepo.subscriptionCancel(subscriptionCancelBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// subscription verify
  Future subscriptionVerify({required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await accountOptionRepo.subscriptionVerify();
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// get about us and terms of use
  Future getCms({required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await accountOptionRepo.getCms();
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// get Scan History List
  Future getScanHistoryList(Map<String, dynamic> getScanHistoryListBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await accountOptionRepo.getScanHistoryList(getScanHistoryListBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// get Scan History Detail
  Future getScanHistoryDetail(Map<String, dynamic> getScanHistoryDetailBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await accountOptionRepo.getScanHistoryDetail(getScanHistoryDetailBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

}
