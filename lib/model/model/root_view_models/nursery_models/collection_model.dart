// To parse this JSON data, do
//
//     final collectionData = collectionDataFromJson(jsonString);

import 'dart:convert';

List<CollectionData> collectionDataFromJson(String str) => List<CollectionData>.from(json.decode(str).map((x) => CollectionData.fromJson(x)));

String collectionDataToJson(List<CollectionData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CollectionData {
  final int? id;
  final String? name;
  final String? image;
  final bool? isTemplate;
  final bool? isUsed;
  final bool? isAdded;
  final int? plantsCount;

  CollectionData({
    this.id,
    this.name,
    this.image,
    this.isTemplate,
    this.isUsed,
    this.isAdded,
    this.plantsCount,
  });

  factory CollectionData.fromJson(Map<String, dynamic> json) => CollectionData(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    isTemplate: json["is_template"],
    isUsed: json["is_used"],
    isAdded: json["is_added"],
    plantsCount: json["plants_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "is_template": isTemplate,
    "is_used": isUsed,
    "is_added": isAdded,
    "plants_count": plantsCount,
  };
}
