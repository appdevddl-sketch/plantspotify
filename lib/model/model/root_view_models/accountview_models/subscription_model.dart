// To parse this JSON data, do
//
//     final subscriptionData = subscriptionDataFromJson(jsonString);

import 'dart:convert';

SubscriptionData subscriptionDataFromJson(String str) => SubscriptionData.fromJson(json.decode(str));

String subscriptionDataToJson(SubscriptionData data) => json.encode(data.toJson());

class SubscriptionData {
  final int? id;
  final String? name;
  final String? type;
  final String? price;
  final int? durationDays;
  final dynamic scanLimit;
  final String? googleProductId;
  final String? appleProductId;
  final String? description;

  SubscriptionData({
    this.id,
    this.name,
    this.type,
    this.price,
    this.durationDays,
    this.scanLimit,
    this.googleProductId,
    this.appleProductId,
    this.description,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) => SubscriptionData(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    price: json["price"],
    durationDays: json["duration_days"],
    scanLimit: json["scan_limit"],
    googleProductId: json["google_product_id"],
    appleProductId: json["apple_product_id"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "price": price,
    "duration_days": durationDays,
    "scan_limit": scanLimit,
    "google_product_id": googleProductId,
    "apple_product_id": appleProductId,
    "description": description,
  };
}
