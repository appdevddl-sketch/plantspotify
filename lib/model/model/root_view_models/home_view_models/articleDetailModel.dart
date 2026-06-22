// To parse this JSON data, do
//
//     final articelDetailsModel = articelDetailsModelFromJson(jsonString);

import 'dart:convert';

ArticelDetailsModel articelDetailsModelFromJson(String str) => ArticelDetailsModel.fromJson(json.decode(str));

String articelDetailsModelToJson(ArticelDetailsModel data) => json.encode(data.toJson());

class ArticelDetailsModel {
  final int? id;
  final String? title;
  final DateTime? createdAt;
  final String? content;
  final List<String>? images;

  ArticelDetailsModel({
    this.id,
    this.title,
    this.createdAt,
    this.content,
    this.images,
  });

  factory ArticelDetailsModel.fromJson(Map<String, dynamic> json) => ArticelDetailsModel(
    id: json["id"],
    title: json["title"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    content: json["content"],
    images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "created_at": createdAt?.toIso8601String(),
    "content": content,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
  };
}
