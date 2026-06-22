// To parse this JSON data, do
//
//     final collectionPlantModel = collectionPlantModelFromJson(jsonString);

import 'dart:convert';

import 'package:plants_spotify/model/model/pagination_model/pagination_model.dart';

CollectionPlantModel collectionPlantModelFromJson(String str) => CollectionPlantModel.fromJson(json.decode(str));

String collectionPlantModelToJson(CollectionPlantModel data) => json.encode(data.toJson());

class CollectionPlantModel {
  final List<CollectionPlantData>? data;
  final Pagination? pagination;

  CollectionPlantModel({
    this.data,
    this.pagination,
  });

  factory CollectionPlantModel.fromJson(Map<String, dynamic> json) => CollectionPlantModel(
    data: json["data"] == null ? [] : List<CollectionPlantData>.from(json["data"]!.map((x) => CollectionPlantData.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class CollectionPlantData {
  final int? id;
  final int? plantId;
  final String? commonName;
  final String? scientificName;
  final String? image;
  final LastNote? lastNote;
  final String? createdAt;
  final String? searchDate;
  final String? validTill;

  CollectionPlantData({
    this.id,
    this.plantId,
    this.commonName,
    this.scientificName,
    this.image,
    this.lastNote,
    this.createdAt, this.searchDate, this.validTill,
  });

  factory CollectionPlantData.fromJson(Map<String, dynamic> json) => CollectionPlantData(
    id: json["id"],
    plantId: json["plant_id"],
    commonName: json["common_name"],
    scientificName: json["scientific_name"],
    image: json["image"],
    lastNote: json["last_note"] == null ? null : LastNote.fromJson(json["last_note"]),
    createdAt: json["created_at"],
    searchDate: json["search_date"],
    validTill: json["valid_till"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "plant_id": plantId,
    "common_name": commonName,
    "scientific_name": scientificName,
    "image": image,
    "last_note": lastNote?.toJson(),
    "search_date": searchDate,
    "valid_till": validTill,
    "created_at": createdAt,

  };
}

class LastNote {
  final String? note;
  final String? createdAt;

  LastNote({
    this.note,
    this.createdAt,
  });

  factory LastNote.fromJson(Map<String, dynamic> json) => LastNote(
    note: json["note"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "note": note,
    "created_at": createdAt,
  };
}

