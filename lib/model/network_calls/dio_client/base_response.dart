
import 'package:json_annotation/json_annotation.dart';

class BaseResponse {
  String? message;
  bool ?status;
  String ?token;
  BaseResponse({ this.message = "Something Went Wrong Here.",this.status,this.token});
  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
        status: json["status"],
        token: json["token"],
        message: json["message"]);
  }
}

@JsonSerializable(genericArgumentFactories: true)
class ListResponse<T> extends BaseResponse {
  List<T> data;
  ListResponse({
    String ?message,
    bool ?status,
    String ?token,
    required this.data,
  }) : super(message: message??"", status: status, token: token);

  factory ListResponse.fromJson(Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    var data = <T>[];
    if(json.containsKey("data") && json["data"].isNotEmpty){
      json['data'].forEach((v) {
        data.add(create(v));
      });
    }
    return ListResponse<T>(
        status: json["status"],
        message: json["message"],
        token: json["token"],
        data: data);
  }
}
@JsonSerializable(genericArgumentFactories: true)
class SingleResponse<T> extends BaseResponse {
  T data;

  SingleResponse({
    String ?message,
    bool ?status,
    String ?token,
    required this.data,
  }) : super(message: message??"", status: status,token: token);

  factory SingleResponse.fromJson(Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    return SingleResponse<T>(
        status: json["status"],
        message: json["message"],
        token: json["token"],
        data: create(json["data"]));
  }
}