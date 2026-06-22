// To parse this JSON data, do
//
//     final plantDetailModel = plantDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:plants_spotify/model/model/root_view_models/home_view_models/diagnose_details_model.dart';

PlantDetailModel plantDetailModelFromJson(String str) => PlantDetailModel.fromJson(json.decode(str));

String plantDetailModelToJson(PlantDetailModel data) => json.encode(data.toJson());

class PlantDetailModel {
  final int? id;
  final String? commonName;
  final String? scientificName;
  final String? description;
  final String? image;
  final List<String>? geoLocation;
  final String? tags;
  final BasicInfo? basicInfo;
  final OtherDetails? otherDetails;
  final FlowerDetails? flowerDetails;
  final FruitDetails? fruitDetails;
  final CareConditions? careConditions;
  final Toxicity? toxicity;
  final List<Picture>? images;
   bool? isAdded;

  PlantDetailModel({
    this.id,
    this.commonName,
    this.scientificName,
    this.description,
    this.image,
    this.geoLocation,
    this.basicInfo,
    this.otherDetails,
    this.flowerDetails,
    this.fruitDetails,
    this.careConditions,
    this.toxicity,
    this.images,
    this.isAdded, this.tags,
  });

  factory PlantDetailModel.fromJson(Map<String, dynamic> json) => PlantDetailModel(
    id: json["id"],
    commonName: json["common_name"],
    scientificName: json["scientific_name"],
    description: json["description"],
    image: json["image"],
    geoLocation: json["geo_location"] == null ? [] : List<String>.from(json["geo_location"]!.map((x) => x)),
    tags: json["tags"],
    basicInfo: json["basic_info"] == null ? null : BasicInfo.fromJson(json["basic_info"]),
    otherDetails: json["other_details"] == null ? null : OtherDetails.fromJson(json["other_details"]),
    flowerDetails: json["flower_details"] == null ? null : FlowerDetails.fromJson(json["flower_details"]),
    fruitDetails: json["fruit_details"] == null ? null : FruitDetails.fromJson(json["fruit_details"]),
    careConditions: json["care_conditions"] == null ? null : CareConditions.fromJson(json["care_conditions"]),
    toxicity: json["toxicity"] == null ? null : Toxicity.fromJson(json["toxicity"]),
    images: json["images"] == null ? [] : List<Picture>.from(json["images"]!.map((x) => Picture.fromJson(x))),
    isAdded: json["is_added"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "common_name": commonName,
    "scientific_name": scientificName,
    "description": description,
    "image": image,
    "geo_location": geoLocation == null ? [] : List<dynamic>.from(geoLocation!.map((x) => x)),
    "tags":tags,
    "basic_info": basicInfo?.toJson(),
    "other_details": otherDetails?.toJson(),
    "flower_details": flowerDetails?.toJson(),
    "fruit_details": fruitDetails?.toJson(),
    "care_conditions": careConditions?.toJson(),
    "toxicity": toxicity?.toJson(),
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
    "is_added": isAdded,
  };
}

class BasicInfo {
  final String? plantType;
  final String? lifespan;
  final List<String>? characteristics;
  final List<Use>? uses;

  BasicInfo({
    this.plantType,
    this.lifespan,
    this.characteristics,
    this.uses,
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) => BasicInfo(
    plantType: json["plant_type"],
    lifespan: json["lifespan"],
    characteristics: json["characteristics"] == null ? [] : List<String>.from(json["characteristics"]!.map((x) => x)),
    uses: json["uses"] == null ? [] : List<Use>.from(json["uses"]!.map((x) => Use.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "plant_type": plantType,
    "lifespan": lifespan,
    "characteristics": characteristics == null ? [] : List<dynamic>.from(characteristics!.map((x) => x)),
    "uses": uses == null ? [] : List<dynamic>.from(uses!.map((x) => x.toJson())),

  };
}


class CareConditions {
  final String? sunlight;
  final String? watering;
  final String? soil;
  final String? temperatureRange;
  final String? hardinessZone;

  CareConditions({
    this.sunlight,
    this.watering,
    this.soil,
    this.temperatureRange,
    this.hardinessZone,
  });

  factory CareConditions.fromJson(Map<String, dynamic> json) => CareConditions(
    sunlight: json["sunlight"],
    watering: json["watering"],
    soil: json["soil"],
    temperatureRange: json["temperature_range"],
    hardinessZone: json["hardiness_zone"],
  );

  Map<String, dynamic> toJson() => {
    "sunlight": sunlight,
    "watering": watering,
    "soil": soil,
    "temperature_range": temperatureRange,
    "hardiness_zone": hardinessZone,
  };
}

class FlowerDetails {
  final String? bloomingTime;
  final String? flowerSize;
  final String? flowerColor;
  final String? growthConditions;

  FlowerDetails({
    this.bloomingTime,
    this.flowerSize,
    this.flowerColor,
    this.growthConditions,
  });

  factory FlowerDetails.fromJson(Map<String, dynamic> json) => FlowerDetails(
    bloomingTime: json["blooming_time"],
    flowerSize: json["flower_size"],
    flowerColor: json["flower_color"],
    growthConditions: json["growth_conditions"],
  );

  Map<String, dynamic> toJson() => {
    "blooming_time": bloomingTime,
    "flower_size": flowerSize,
    "flower_color": flowerColor,
    "growth_conditions": growthConditions,
  };
}

class FruitDetails {
  final String? fruitDetailsTime;
  final String? harvestTime;
  final String? fruitColor;

  FruitDetails({
    this.fruitDetailsTime,
    this.harvestTime,
    this.fruitColor,
  });

  factory FruitDetails.fromJson(Map<String, dynamic> json) => FruitDetails(
    fruitDetailsTime: json["fruit_details_time"],
    harvestTime: json["harvest_time"],
    fruitColor: json["fruit_color"],
  );

  Map<String, dynamic> toJson() => {
    "fruit_details_time": fruitDetailsTime,
    "harvest_time": harvestTime,
    "fruit_color": fruitColor,
  };
}

class Picture {
  final String? url;
  final bool? isPrimary;

  Picture({
    this.url,
    this.isPrimary,
  });

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
    url: json["url"],
    isPrimary: json["is_primary"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "is_primary": isPrimary,
  };
}

class OtherDetails {
  final String? matureHeight;
  final String? spread;
  final String? plantColor;
  final String? plantingTime;

  OtherDetails({
    this.matureHeight,
    this.spread,
    this.plantColor,
    this.plantingTime,
  });

  factory OtherDetails.fromJson(Map<String, dynamic> json) => OtherDetails(
    matureHeight: json["mature_height"],
    spread: json["spread"],
    plantColor: json["plant_color"],
    plantingTime: json["planting_time"],
  );

  Map<String, dynamic> toJson() => {
    "mature_height": matureHeight,
    "spread": spread,
    "plant_color": plantColor,
    "planting_time": plantingTime,
  };
}

class Toxicity {
  final bool? toxicToHumans;
  final bool? toxicToPets;

  Toxicity({
    this.toxicToHumans,
    this.toxicToPets,
  });

  factory Toxicity.fromJson(Map<String, dynamic> json) => Toxicity(
    toxicToHumans: json["toxic_to_humans"],
    toxicToPets: json["toxic_to_pets"],
  );

  Map<String, dynamic> toJson() => {
    "toxic_to_humans": toxicToHumans,
    "toxic_to_pets": toxicToPets,
  };
}
