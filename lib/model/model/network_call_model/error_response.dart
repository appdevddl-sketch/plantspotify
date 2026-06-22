
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
class ErrorResponse {
  List<Errors>? _errors;
  List<Errors>? get errors => _errors;
  ErrorResponse({List<Errors>? errors}) {
    _errors = errors;
  }

  ErrorResponse.fromJson(dynamic json) {
    ("error json=>$json").toString().logPrint();
    try {
      if (json["errors"] != null) {
        Map<String, dynamic> errorMap = json['errors'];
        _errors = [];
        errorMap.forEach((key, value) {
          if(value is String){
            _errors!.add(Errors(code: key, message: value));

          }else{
            _errors!.add(Errors(code: key, message: value[0]));

          }
        });
      }
    } catch (e) {
      _errors = [];
      _errors!.add(Errors(code: "404", message: "Something went wrong"));
    }
  }
}

class Errors {
  final String code;
  final String message;
  Errors({required this.code, required this.message});
}


