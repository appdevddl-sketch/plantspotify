
import 'dart:convert';

import 'package:plants_spotify/model/model/network_call_model/error_response.dart';

import '../../model/network_call_model/api_response.dart';
class CheckApiResponse {
  static CheckApiResponse? _instance;
  static CheckApiResponse get instance => _instance ??= CheckApiResponse._init();
  CheckApiResponse._init();

  Future<bool> initResponse(ApiResponse apiResponse, {required Function(String message, Map<String, dynamic> map) onSuccess, required Function(String message) onError}) async {
    try {
      if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
        Map<String, dynamic> map = apiResponse.response?.data ?? {};
        String message = map["message"] ?? "";
        if ((map["status"].runtimeType == bool ? map["status"] : map["status"]=="OK")??false) {
          onSuccess(message, map);
          return true;
        } else if (apiResponse.response?.data?["errors"] != null) {
          ErrorResponse errorResponse = ErrorResponse.fromJson(apiResponse.response?.data);
          if (errorResponse.errors != null && errorResponse.errors!.isNotEmpty) {
            onError(errorResponse.errors?.first.message ?? "");
          } else {
            onError("There was something wrong here.");
          }
          return false;
        } else {
          onError(apiResponse.response?.data["message"] ?? "There was something wrong here.");
          return false;
        }
      } else {
        String errorMessage;
        if (apiResponse.error is String) {
          errorMessage = apiResponse.error.toString();
        } else {
          ErrorResponse errorResponse = apiResponse.error;
          errorMessage = errorResponse.errors?.isNotEmpty == true ? (errorResponse.errors?.first.message ?? "There was something wrong here.") : "There was something wrong here.";
        }
        onError(errorMessage);
        return false;
      }
    } catch (e) {
      onError(e.toString());
      return false;
    }
  }
}
