
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plants_spotify/model/utils/string_resource.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';

import '../../../model/network_call_model/api_response.dart';
import '../../../services/auth_service.dart';
import '../../../utils/app_constants.dart';
import '../../dio_client/dio_client.dart';
import '../../exception/api_error_handler.dart';




class AccountOptionRepo {
  final DioClient dioClient;
  AccountOptionRepo({
    required this.dioClient,
  });

  /// get faq
  Future<ApiResponse> getFaq(Map<String, dynamic> getFaqBody) async {
    try {
      Response response = await dioClient.get("${AppConstants.instance.faq}?paginate=${getFaqBody['paginate']}&page=${getFaqBody['page']}");
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// contact us
  Future<ApiResponse> contactUs(Map<String, dynamic> contactUsBody) async {
    try {
      Response response = await dioClient.post(AppConstants.instance.contactUs,data: contactUsBody);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// get subscription plans
  Future<ApiResponse> getSubscriptionPlans() async {
    try {
      Response response = await dioClient.get(AppConstants.instance.subscriptionPlans);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  ///  subscription purchase
  Future<ApiResponse> subscriptionPurchase(Map<String, dynamic> subscriptionPurchaseBody) async {
    try {
      Response response = await dioClient.post(AppConstants.instance.subscriptionPurchase,data: subscriptionPurchaseBody);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  ///  subscription cancel
  Future<ApiResponse> subscriptionCancel(Map<String, dynamic> subscriptionPurchaseBody) async {
    try {
      Response response = await dioClient.post(AppConstants.instance.subscriptionCancel,data: subscriptionPurchaseBody);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  ///  subscription verify
  Future<ApiResponse> subscriptionVerify() async {
    try {
      Response response = await dioClient.get(AppConstants.instance.subscriptionVerify);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// get about us and terms of use
  Future<ApiResponse> getCms() async {
    try {
      Response response = await dioClient.get(AppConstants.instance.cms);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// get scan  history list
  Future<ApiResponse> getScanHistoryList(Map<String, dynamic> getScanHistoryListBody) async {
    try {
      Response response = await dioClient.get("${AppConstants.instance.scanHistory  }?search=${getScanHistoryListBody['search']}&paginate=${getScanHistoryListBody['paginate']}&page=${getScanHistoryListBody['page']}");
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// get scan  history detail
  Future<ApiResponse> getScanHistoryDetail(Map<String, dynamic> getScanHistoryDetailBody) async {
    try {
      Response response = await dioClient.get("${AppConstants.instance.scanHistory}/${getScanHistoryDetailBody['id']}");
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}
