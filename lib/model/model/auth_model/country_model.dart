// To parse this JSON data, do
//
//     final countryModel = countryModelFromJson(jsonString);

import 'dart:convert';

CountryModel countryModelFromJson(String str) => CountryModel.fromJson(json.decode(str));

String countryModelToJson(CountryModel data) => json.encode(data.toJson());

class CountryModel {
  final List<CountryData>? data;
  final Pagination? pagination;

  CountryModel({
    this.data,
    this.pagination,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
    data: json["data"] == null ? [] : List<CountryData>.from(json["data"]!.map((x) => CountryData.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class CountryData {
  final int? id;
  final String? name;
  final String? countryCode;

  CountryData({
    this.id,
    this.name,
    this.countryCode,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) => CountryData(
    id: json["id"],
    name: json["name"],
    countryCode: json["country_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "country_code": countryCode,
  };
}

class Pagination {
  final int? total;
  final int? count;
  final int? perPage;
  final int? currentPage;
  final int? lastPage;

  Pagination({
    this.total,
    this.count,
    this.perPage,
    this.currentPage,
    this.lastPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    count: json["count"],
    perPage: json["per_page"],
    currentPage: json["current_page"],
    lastPage: json["last_page"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "count": count,
    "per_page": perPage,
    "current_page": currentPage,
    "last_page": lastPage,
  };
}
