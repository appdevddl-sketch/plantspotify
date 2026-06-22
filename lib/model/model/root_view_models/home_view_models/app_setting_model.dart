// To parse this JSON data, do
//
//     final appSettingModel = appSettingModelFromJson(jsonString);

import 'dart:convert';

AppSettingModel appSettingModelFromJson(String str) => AppSettingModel.fromJson(json.decode(str));

String appSettingModelToJson(AppSettingModel data) => json.encode(data.toJson());

class AppSettingModel {
  final String? forceIosVersion;
  final String? forceAndroidVersion;
  final int? plantDetailsRetentionDays;

  AppSettingModel({
    this.forceIosVersion,
    this.forceAndroidVersion,
    this.plantDetailsRetentionDays,
  });

  factory AppSettingModel.fromJson(Map<String, dynamic> json) => AppSettingModel(
    forceIosVersion: json["force_ios_version"],
    forceAndroidVersion: json["force_android_version"],
    plantDetailsRetentionDays: json["plant_details_retention_days"],
  );

  Map<String, dynamic> toJson() => {

    "force_ios_version": forceIosVersion,
    "force_android_version": forceAndroidVersion,
    "plant_details_retention_days": plantDetailsRetentionDays,
  };
}
