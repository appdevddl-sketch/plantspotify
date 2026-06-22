// To parse this JSON data, do
//
//     final scanHistoryListModel = scanHistoryListModelFromJson(jsonString);

import 'dart:convert';

import 'package:plants_spotify/model/model/pagination_model/pagination_model.dart';

ScanHistoryListModel scanHistoryListModelFromJson(String str) => ScanHistoryListModel.fromJson(json.decode(str));

String scanHistoryListModelToJson(ScanHistoryListModel data) => json.encode(data.toJson());

class ScanHistoryListModel {
  final List<ScanLisData>? data;
  final Pagination? pagination;

  ScanHistoryListModel({
    this.data,
    this.pagination,
  });

  factory ScanHistoryListModel.fromJson(Map<String, dynamic> json) => ScanHistoryListModel(
    data: json["data"] == null ? [] : List<ScanLisData>.from(json["data"]!.map((x) => ScanLisData.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class ScanLisData {
  final int? id;
  final PlantDetails? plantDetails;
  final String? image;
  final String? scanType;
  final String? createdAt;
  final bool? isSaved;
  final int? collectionId;
  final String? collectionName;

  ScanLisData({
    this.id,
    this.plantDetails,
    this.image,
    this.scanType,
    this.createdAt,
    this.isSaved,
    this.collectionId,
    this.collectionName,
  });

  factory ScanLisData.fromJson(Map<String, dynamic> json) => ScanLisData(
    id: json["id"],
    plantDetails: json["plant_details"] == null ? null : PlantDetails.fromJson(json["plant_details"]),
    image: json["image"],
    scanType: json["scan_type"],
    createdAt: json["created_at"],
    isSaved: json["is_saved"],
    collectionId: json["collection_id"],
    collectionName: json["collection_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "plant_details": plantDetails?.toJson(),
    "image": image,
    "scan_type": scanType,
    "created_at": createdAt,
    "is_saved": isSaved,
    "collection_id": collectionId,
    "collection_name": collectionName,
  };
}

class PlantDetails {
  final int? id;
  final String? commonName;
  final String? scientificName;

  PlantDetails({
    this.id,
    this.commonName,
    this.scientificName,
  });

  factory PlantDetails.fromJson(Map<String, dynamic> json) => PlantDetails(
    id: json["id"],
    commonName: json["common_name"],
    scientificName: json["scientific_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "common_name": commonName,
    "scientific_name": scientificName,
  };
}

