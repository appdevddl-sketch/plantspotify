

import 'package:dio/dio.dart';
import 'package:plants_spotify/model/model/network_call_model/api_response.dart';
import 'package:plants_spotify/model/network_calls/api_helper/repository_helper/auth_repo.dart';
import 'package:plants_spotify/model/network_calls/dio_client/check_api_response.dart';

class AuthProvider {
  final AuthRepo authRepo;
  AuthProvider({required this.authRepo});

  /// Auth
  Future socialLogin(Map<String, dynamic> socialLoginBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await authRepo.socialLogin(socialLoginBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// Get Profile
  Future getProfile({required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await authRepo.getProfile();
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// Get User Ip
  Future getUserIp({required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await authRepo.getUserIp();
    return onSuccess("", apiResponse.response?.data ?? {});
  }

  /// update Profile
  Future updateProfile(Map<String, dynamic> updateProfileBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await authRepo.updateProfile(updateProfileBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// logout
  Future logout(Map<String, dynamic> logoutBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await authRepo.logout(logoutBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// delete Account
  Future deleteAccount(Map<String, dynamic> deleteAccountBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await authRepo.deleteAccount(deleteAccountBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// Update location
  Future updateLocation(Map<String, dynamic> updateLocationBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await authRepo.updateLocation(updateLocationBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// update DeviceId
  Future updateDeviceID(Map<String, dynamic> updateDeviceIdBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await authRepo.updateDeviceId(updateDeviceIdBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// Get App Versions
  Future getAppVersions({required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await authRepo.getAppVersions();
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  /// Get Home Type
  Future getHomeType({required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await authRepo.getHomeTypes();
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }
  /// Get Home Type
  Future getCountries(Map<String, dynamic> getCountriesBody,{required Function(String? message) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await authRepo.getCountry(getCountriesBody);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }




}
