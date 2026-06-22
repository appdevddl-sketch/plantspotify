import 'package:dio/dio.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';


class LoggingInterceptor extends InterceptorsWrapper {
  int maxCharactersPerLine = 200;

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    ("--> ${options.method} ${options.path}").logPrint();
    ("Headers: ${options.headers.toString()}").logPrint();
    ("<-- END HTTP").logPrint();
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    ("<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}").logPrint();
    String responseAsString = response.data.toString();
    if (responseAsString.length > maxCharactersPerLine) {
      int iterations = (responseAsString.length / maxCharactersPerLine).floor();
      for (int i = 0; i <= iterations; i++) {
        int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
        if (endingIndex > responseAsString.length) {endingIndex = responseAsString.length;}
        (responseAsString.substring(i * maxCharactersPerLine, endingIndex)).logPrint();
      }
    } else {
      response.data.toString().logPrint();
    }
    ("<-- END HTTP").logPrint();
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    ("ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}").logPrint();
    return super.onError(err, handler);
  }
}
