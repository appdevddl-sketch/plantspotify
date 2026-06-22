// To parse this JSON data, do
//
//     final userIp = userIpFromJson(jsonString);

import 'dart:convert';

UserIp userIpFromJson(String str) => UserIp.fromJson(json.decode(str));

String userIpToJson(UserIp data) => json.encode(data.toJson());

class UserIp {
  final String? status;
  final String? country;
  final String? countryCode;
  final String? region;
  final String? regionName;
  final String? city;
  final String? zip;
  final double? lat;
  final double? lon;
  final String? timezone;
  final String? isp;
  final String? org;
  final String? userIpAs;
  final String? query;

  UserIp({
    this.status,
    this.country,
    this.countryCode,
    this.region,
    this.regionName,
    this.city,
    this.zip,
    this.lat,
    this.lon,
    this.timezone,
    this.isp,
    this.org,
    this.userIpAs,
    this.query,
  });

  factory UserIp.fromJson(Map<String, dynamic> json) => UserIp(
    status: json["status"],
    country: json["country"],
    countryCode: json["countryCode"],
    region: json["region"],
    regionName: json["regionName"],
    city: json["city"],
    zip: json["zip"],
    lat: json["lat"]?.toDouble(),
    lon: json["lon"]?.toDouble(),
    timezone: json["timezone"],
    isp: json["isp"],
    org: json["org"],
    userIpAs: json["as"],
    query: json["query"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "country": country,
    "countryCode": countryCode,
    "region": region,
    "regionName": regionName,
    "city": city,
    "zip": zip,
    "lat": lat,
    "lon": lon,
    "timezone": timezone,
    "isp": isp,
    "org": org,
    "as": userIpAs,
    "query": query,
  };
}
