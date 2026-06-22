// To parse this JSON data, do
//
//     final faqModel = faqModelFromJson(jsonString);

import 'dart:convert';

import 'package:plants_spotify/model/model/pagination_model/pagination_model.dart';

FaqModel faqModelFromJson(String str) => FaqModel.fromJson(json.decode(str));

String faqModelToJson(FaqModel data) => json.encode(data.toJson());

class FaqModel {
  final List<FaqData>? data;
  final Pagination? pagination;

  FaqModel({
    this.data,
    this.pagination,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
    data: json["data"] == null ? [] : List<FaqData>.from(json["data"]!.map((x) => FaqData.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class FaqData {
  final int? id;
  final String? question;
  final String? answer;
  final String? createdAt;

  FaqData({
    this.id,
    this.question,
    this.answer,
    this.createdAt,
  });

  factory FaqData.fromJson(Map<String, dynamic> json) => FaqData(
    id: json["id"],
    question: json["question"],
    answer: json["answer"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer": answer,
    "created_at": createdAt,
  };
}


