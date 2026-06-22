// To parse this JSON data, do
//
//     final settingsModel = settingsModelFromJson(jsonString);

import 'dart:convert';

SettingsModel settingsModelFromJson(String str) => SettingsModel.fromJson(json.decode(str));

String settingsModelToJson(SettingsModel data) => json.encode(data.toJson());

class SettingsModel {
  final String? privacyPolicy;
  final String? aboutUs;

  SettingsModel({
    this.privacyPolicy,
    this.aboutUs,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
    privacyPolicy: json["privacy_policy"],
    aboutUs: json["about_us"],
  );

  Map<String, dynamic> toJson() => {
    "privacy_policy": privacyPolicy,
    "about_us": aboutUs,
  };
}
