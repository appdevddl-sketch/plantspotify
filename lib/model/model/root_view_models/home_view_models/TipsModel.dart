// To parse this JSON data, do
//
//     final tipsModel = tipsModelFromJson(jsonString);

import 'dart:convert';

TipsModel tipsModelFromJson(String str) => TipsModel.fromJson(json.decode(str));

String tipsModelToJson(TipsModel data) => json.encode(data.toJson());

class TipsModel {
  final int? id;
  final String? title;

  TipsModel({
    this.id,
    this.title,
  });

  factory TipsModel.fromJson(Map<String, dynamic> json) => TipsModel(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}
