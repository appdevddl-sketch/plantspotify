import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' as get_pack;
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../services/auth_service.dart';
import 'logging_interceptor.dart';



class DioClient {
 final String baseUrl;
 final LoggingInterceptor? loggingInterceptor;

  late Dio dio;
  late String token;

  DioClient(this.baseUrl, Dio? dioC, {this.loggingInterceptor,}) {
    token = "";
    token = get_pack.Get.find<AuthService>().getUserToken();
    ("Token : $token").logPrint();
    dio = dioC ?? Dio();
    _initializeDio();

  }
 Future<void> _initializeDio() async {
   // dio = await getDioWithSSLPinning();

   dio
     ..options.baseUrl = baseUrl
     ..options.connectTimeout = const Duration(milliseconds: 600000)
     ..options.receiveTimeout = const Duration(milliseconds: 600000)
     ..httpClientAdapter
     ..options.responseType = ResponseType.json
     ..options.headers = {
       'Content-Type': 'application/json;charset=UTF-8',
       'Accept':'application/json',
       'Authorization': 'Bearer $token'
     };
   dio.interceptors.add(loggingInterceptor!);
   // dio.interceptors.add(PrettyDioLogger());
   dio.interceptors.add(PrettyDioLogger(
       requestHeader: true,
       requestBody: true,
       responseBody: true,
       responseHeader: false,
       error: true,
       compact: true,
       maxWidth: 90,
       enabled: kDebugMode,
       filter: (options, args){
         // don't print requests with uris containing '/posts'
         if(options.path.contains('/posts')){
           return false;
         }
         // don't print responses with unit8 list data
         return !args.isResponse || !args.hasUint8ListData;
       }
   )
   );
 }
  Future<Response> get(String uri, {Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onReceiveProgress,}) async {
    try {
      var response = await dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const  FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String uri, {data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress,}) async {
    try {
      var response = await dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      ("catch $e").logPrint();
      rethrow;
    }
  }

  Future<Response> put(String uri, {data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress,}) async {
    try {
      var response = await dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      ("catch $e").logPrint();
      rethrow;
    }
  }

 Future<Response> patch(String uri, {data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress,}) async {
   try {
     var response = await dio.patch(
       uri,
       data: data,
       queryParameters: queryParameters,
       options: options,
       cancelToken: cancelToken,
       onSendProgress: onSendProgress,
       onReceiveProgress: onReceiveProgress,
     );
     return response;
   } on FormatException catch (_) {
     throw const FormatException("Unable to process the data");
   } catch (e) {
     ("catch $e").logPrint();
     rethrow;
   }
 }

  Future<Response> delete(String uri, {data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken,}) async {
    try {
      var response = await dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on FormatException catch (_) {
      throw const  FormatException("Unable to process the data");
    } catch (e) {
      ("catch $e").logPrint();
      rethrow;
    }
  }
}
