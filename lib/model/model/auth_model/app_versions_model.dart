// To parse this JSON data, do
//
//     final appVersions = appVersionsFromJson(jsonString);

import 'dart:convert';

AppVersions appVersionsFromJson(String str) => AppVersions.fromJson(json.decode(str));

String appVersionsToJson(AppVersions data) => json.encode(data.toJson());

class AppVersions {
  final String? currentIosVersion;
  final String? currentAndroidVersion;
  final String? forceIosVersion;
  final String? forceAndroidVersion;

  AppVersions({
    this.currentIosVersion,
    this.currentAndroidVersion,
    this.forceIosVersion,
    this.forceAndroidVersion,
  });

  factory AppVersions.fromJson(Map<String, dynamic> json) => AppVersions(
    currentIosVersion: json["current_ios_version"],
    currentAndroidVersion: json["current_android_version"],
    forceIosVersion: json["force_ios_version"],
    forceAndroidVersion: json["force_android_version"],
  );

  Map<String, dynamic> toJson() => {
    "current_ios_version": currentIosVersion,
    "current_android_version": currentAndroidVersion,
    "force_ios_version": forceIosVersion,
    "force_android_version": forceAndroidVersion,
  };
}
