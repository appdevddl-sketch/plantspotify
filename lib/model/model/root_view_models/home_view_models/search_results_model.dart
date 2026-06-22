// To parse this JSON data, do
//
//     final searchResultModel = searchResultModelFromJson(jsonString);

import 'dart:convert';

import 'package:plants_spotify/model/model/pagination_model/pagination_model.dart';

SearchResultModel searchResultModelFromJson(String str) => SearchResultModel.fromJson(json.decode(str));

String searchResultModelToJson(SearchResultModel data) => json.encode(data.toJson());

class SearchResultModel {
  final List<SearchPlantData>? data;
  final Pagination? pagination;

  SearchResultModel({
    this.data,
    this.pagination,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) => SearchResultModel(
    data: json["data"] == null ? [] : List<SearchPlantData>.from(json["data"]!.map((x) => SearchPlantData.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class SearchPlantData {
  final int? id;
  final String? commonName;
  final String? scientificName;
  final String? description;
  final String? image;

  SearchPlantData({
    this.id,
    this.commonName,
    this.scientificName,
    this.description,
    this.image,
  });

  factory SearchPlantData.fromJson(Map<String, dynamic> json) => SearchPlantData(
    id: json["id"],
    commonName: json["common_name"],
    scientificName: json["scientific_name"],
    description: json["description"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "common_name": commonName,
    "scientific_name": scientificName,
    "description": description,
    "image": image,
  };
}
