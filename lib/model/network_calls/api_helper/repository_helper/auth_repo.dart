
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




class AuthRepo {
  final DioClient dioClient;
  AuthRepo({
    required this.dioClient,
  });

  /// auth
  Future<ApiResponse> socialLogin(Map<String, dynamic> logoutBody) async {
    try {
      Response response = await dioClient.post(AppConstants.instance.auth,data: logoutBody);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// getProfile
  Future<ApiResponse> getProfile() async {
    try {
      Response response = await dioClient.get(AppConstants.instance.getProfile);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// getUserIp
  Future<ApiResponse> getUserIp() async {
    try {
      Response response = await dioClient.get(AppConstants.instance.getUserIp);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// Update Profile
  Future<ApiResponse> updateProfile(Map<String, dynamic> updateProfileBody) async {
    try {
      Response response = await dioClient.post(AppConstants.instance.updateProfile,data: updateProfileBody);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  /// Logout user
  Future<ApiResponse> logout(Map<String, dynamic> logoutBody) async {
    try {
      Response response = await dioClient.post(AppConstants.instance.logout,data: logoutBody);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  /// delete account
  Future<ApiResponse> deleteAccount(Map<String, dynamic> deleteAccountBody) async {
    try {
      Response response = await dioClient.post(AppConstants.instance.deleteAccount,data: deleteAccountBody);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  /// update location
  Future<ApiResponse> updateLocation(Map<String, dynamic> updateLocationBody) async {
    try {
      Response response = await dioClient.post(AppConstants.instance.updateLocation,data: updateLocationBody);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  /// update device ID
  Future<ApiResponse> updateDeviceId(Map<String, dynamic> updateDeviceIsBody) async {
    try {
      Response response = await dioClient.post(AppConstants.instance.updateDeviceId,data: updateDeviceIsBody);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  /// get App Versions
  Future<ApiResponse> getAppVersions() async {
    try {
      Response response = await dioClient.get(AppConstants.instance.getAppVersion);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// get Home Types
  Future<ApiResponse> getHomeTypes() async {
    try {
      Response response = await dioClient.get(AppConstants.instance.homeTypes);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// getProfile
  Future<ApiResponse> getCountry(Map<String, dynamic> getCountryBody) async {
    try {
      Response response = await dioClient.get("${AppConstants.instance.getCountry}?query=${getCountryBody['query']??""}&paginate=${getCountryBody['paginate']}&page=${getCountryBody['page']}");
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}
