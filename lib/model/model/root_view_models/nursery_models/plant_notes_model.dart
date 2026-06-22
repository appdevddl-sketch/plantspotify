// To parse this JSON data, do
//
//     final plantNotesModel = plantNotesModelFromJson(jsonString);

import 'dart:convert';

import 'package:plants_spotify/model/model/pagination_model/pagination_model.dart';

PlantNotesModel plantNotesModelFromJson(String str) => PlantNotesModel.fromJson(json.decode(str));

String plantNotesModelToJson(PlantNotesModel data) => json.encode(data.toJson());

class PlantNotesModel {
  final List<PlantNotesData>? data;
  final Pagination? pagination;

  PlantNotesModel({
    this.data,
    this.pagination,
  });

  factory PlantNotesModel.fromJson(Map<String, dynamic> json) => PlantNotesModel(
    data: json["data"] == null ? [] : List<PlantNotesData>.from(json["data"]!.map((x) => PlantNotesData.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class PlantNotesData {
  final int? id;
  final String? note;
  final List<Img>? images;
  final String? createdAt;

  PlantNotesData({
    this.id,
    this.note,
    this.images,
    this.createdAt,
  });

  factory PlantNotesData.fromJson(Map<String, dynamic> json) => PlantNotesData(
    id: json["id"],
    note: json["note"],
    images: json["images"] == null ? [] : List<Img>.from(json["images"]!.map((x) => Img.fromJson(x))),
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "note": note,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
    "created_at": createdAt,
  };
}

class Img {
  final int? id;
  final String? image;

  Img({
    this.id,
    this.image,
  });

  factory Img.fromJson(Map<String, dynamic> json) => Img(
    id: json["id"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
  };
}


