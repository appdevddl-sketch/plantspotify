import 'dart:math';


import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plants_spotify/model/model/network_call_model/api_response.dart';
import 'package:plants_spotify/model/network_calls/dio_client/dio_client.dart';
import 'package:plants_spotify/model/network_calls/exception/api_error_handler.dart';
import 'package:plants_spotify/model/utils/app_constants.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';




class AddressRepo {
  final DioClient dioClient;
  AddressRepo({
    required this.dioClient,
  });


  Future<ApiResponse> searchPlaces(String searchKeyword) async {
    String url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchKeyword&key=${AppConstants.instance.googleMapKey}&sessiontoken=${Random().nextInt(2)}";
    try {
      Response response = await dioClient.get(url);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("sign in error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> searchAddress(LatLng latLng) async {
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&language=En&key=${AppConstants.instance.googleMapKey}";
    try {
      Response response = await dioClient.get(url);
      ("response.data ${response.data}").logPrint();
      return ApiResponse.withSuccess(response);
    } catch (e) {
      ("sign in error => $e").logPrint();
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}
