// To parse this JSON data, do
//
//     final plantCategories = plantCategoriesFromJson(jsonString);

import 'dart:convert';

import '../../pagination_model/pagination_model.dart';

PlantCategoriesModel plantCategoriesFromJson(String str) => PlantCategoriesModel.fromJson(json.decode(str));

String plantCategoriesToJson(PlantCategoriesModel data) => json.encode(data.toJson());

class PlantCategoriesModel {
  final List<PlantCategoryData>? data;
  final Pagination? pagination;

  PlantCategoriesModel({
    this.data,
    this.pagination,
  });

  factory PlantCategoriesModel.fromJson(Map<String, dynamic> json) => PlantCategoriesModel(
    data: json["data"] == null ? [] : List<PlantCategoryData>.from(json["data"]!.map((x) => PlantCategoryData.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class PlantCategoryData {
  final int? id;
  final String? name;
  final String? slug;
  final String? image;

  PlantCategoryData({
    this.id,
    this.name,
    this.slug,
    this.image,
  });

  factory PlantCategoryData.fromJson(Map<String, dynamic> json) => PlantCategoryData(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "image": image,
  };
}


