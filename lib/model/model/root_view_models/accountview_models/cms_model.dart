// To parse this JSON data, do
//
//     final cmsModel = cmsModelFromJson(jsonString);

import 'dart:convert';

CmsModel cmsModelFromJson(String str) => CmsModel.fromJson(json.decode(str));

String cmsModelToJson(CmsModel data) => json.encode(data.toJson());

class CmsModel {
  final String? aboutUs;
  final String? termsOfUse;
  final String? privacyPolicy;


  CmsModel({
    this.aboutUs,
    this.termsOfUse,
    this.privacyPolicy,
  });

  factory CmsModel.fromJson(Map<String, dynamic> json) => CmsModel(
    aboutUs: json["about_us"],
    termsOfUse: json["terms_of_use"],
    privacyPolicy: json["privacy_policy"],
  );

  Map<String, dynamic> toJson() => {
    "about_us": aboutUs,
    "terms_of_use": termsOfUse,
    "privacy_policy": privacyPolicy,
  };
}
