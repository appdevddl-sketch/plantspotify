import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view/widgets/app_common/custom_popup/subscription_limit_popup.dart';
import 'package:plants_spotify/view/widgets/button_view/animated_box.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view/widgets/toast_view/showtoast.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';

import '../../model/network_call_model/error_response.dart';
import '../../services/auth_service.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription = "";
    if (error is Exception) {
      try {
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;
            case DioExceptionType.connectionTimeout:
              errorDescription = "Connection timeout with API server";
              break;
            case DioExceptionType.connectionError:
              errorDescription =
                  "Connection to API server failed due to internet connection";
              break;
            case DioExceptionType.receiveTimeout:
              errorDescription =
                  "Receive timeout in connection with API server";
              break;
            case DioExceptionType.badResponse:
              switch (error.response?.statusCode) {
                case 401:
                  {
                    Get.find<AuthService>().logOut();
                    toastShow(message: error.response?.data, error: true);
                    ("this is error response ${error.response?.data}").toString().logPrint();
                  }
                  break;
                case 422:
                  error.response?.data['message'].toString().logPrint();
                  ErrorResponse errorResponse = ErrorResponse.fromJson(error.response?.data ?? {});
                  if (errorResponse.errors != null && (errorResponse.errors?.isNotEmpty ?? false)) {
                    errorDescription = errorResponse;
                  } else {
                    errorDescription = error.response?.data['message'] ?? "Failed to load data - status code: ${error.response?.statusCode}";
                  }
                  break;
                case 429:
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (Get.context != null) {
                      showAnimatedDialog(
                        Get.context!,
                        SubscriptionLimitPopup(
                          message: error.response?.data is Map ? error.response?.data['message'] : null,
                        ),
                        dismissible: true,
                        isFlip: true,
                      );
                    }
                  });
                  errorDescription = (error.response?.data is Map ? error.response?.data['message'] : null) ?? "Usage limit reached. Please upgrade your plan.";
                  break;
                case 503:
                  errorDescription = error.response?.statusMessage ?? 503;
                  break;
                default:
                  ("this is error response ${error.response?.data}").toString().logPrint();
                  ErrorResponse errorResponse = ErrorResponse.fromJson(error.response?.data ?? {});
                  if (errorResponse.errors != null && (errorResponse.errors?.isNotEmpty ?? false)) {
                    errorDescription = errorResponse;
                  } else {
                    errorDescription = error.response?.data['message'] ?? "Failed to load data - status code: ${error.response?.statusCode}";
                  }
              }
              break;
            case DioExceptionType.sendTimeout:
              errorDescription = "Send timeout with server";
              break;
            default:
             // Covers: badCertificate, unknown, badResponse (fallback)
              errorDescription = "Unexpected error occurred";
              break;
          }
        } else {
          errorDescription = "Unexpected error occured";
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = "is not a subtype of exception";
    }
    return errorDescription;
  }
}
