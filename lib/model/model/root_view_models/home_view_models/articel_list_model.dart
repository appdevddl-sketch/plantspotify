// To parse this JSON data, do
//
//     final articelListModel = articelListModelFromJson(jsonString);

import 'dart:convert';

import 'package:plants_spotify/model/model/pagination_model/pagination_model.dart';

ArticelListModel articelListModelFromJson(String str) => ArticelListModel.fromJson(json.decode(str));

String articelListModelToJson(ArticelListModel data) => json.encode(data.toJson());

class ArticelListModel {
  final List<ArticleListData>? data;
  final Pagination? pagination;

  ArticelListModel({
    this.data,
    this.pagination,
  });

  factory ArticelListModel.fromJson(Map<String, dynamic> json) => ArticelListModel(
    data: json["data"] == null ? [] : List<ArticleListData>.from(json["data"]!.map((x) => ArticleListData.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class ArticleListData {
  final int? id;
  final String? title;
  final DateTime? createdAt;
  final String? image;

  ArticleListData({
    this.id,
    this.title,
    this.createdAt,
    this.image,
  });

  factory ArticleListData.fromJson(Map<String, dynamic> json) => ArticleListData(
    id: json["id"],
    title: json["title"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "created_at": createdAt?.toIso8601String(),
    "image": image,
  };
}

