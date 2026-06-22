import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';
import 'package:plants_spotify/model/utils/app_setting/app_globals.dart';


Future<SecurityContext> get globalContext async {
  String environment = Globals.appEnvironment;
  ByteData sslCert;

  try {
    if (environment == "DEV") {
      print('DEVELOPMENT SERVER RUN');
      sslCert = await rootBundle.load('assets/ssl_pinning/certificate_dev.pem');
    } else if (environment == "PROD") {
      print('PRODUCTION SERVER RUN');
      sslCert = await rootBundle.load('assets/ssl_pinning/certificate_prod.pem');
    } else if (environment == "STAGING") {
      print('STAGING SERVER RUN');
      sslCert = await rootBundle.load('assets/ssl_pinning/certificate_staging.pem');
    } else {
      print('DEVELOPMENT SERVER RUN');
      sslCert = await rootBundle.load('assets/ssl_pinning/certificate_dev.pem');
    }

    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());

    return securityContext;
  } catch (e) {
    print('Error loading SSL certificate: $e');
    rethrow;
  }
}


Future<Dio> getDioWithSSLPinning() async {
  final SecurityContext securityContext = await globalContext;

  HttpClient httpClient = HttpClient(context: securityContext);
  httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => false;

  Dio dio = Dio();

  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (_) => httpClient;

  return dio;
}