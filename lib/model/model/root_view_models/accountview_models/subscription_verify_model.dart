// To parse this JSON data, do
//
//     final subscriptionVerifyModal = subscriptionVerifyModalFromJson(jsonString);

import 'dart:convert';

SubscriptionVerifyModal subscriptionVerifyModalFromJson(String str) => SubscriptionVerifyModal.fromJson(json.decode(str));

String subscriptionVerifyModalToJson(SubscriptionVerifyModal data) => json.encode(data.toJson());

class SubscriptionVerifyModal {
  final bool? isPremium;
  final String? status;
  final String? currentStatus;
  final String? planName;
  final String? planType;
  final DateTime? expiryDate;
  final bool? isAutoRenewing;
  final int? scansRemaining;

  SubscriptionVerifyModal({
    this.isPremium,
    this.status,
    this.currentStatus,
    this.planName,
    this.planType,
    this.expiryDate,
    this.isAutoRenewing,
    this.scansRemaining,
  });

  factory SubscriptionVerifyModal.fromJson(Map<String, dynamic> json) => SubscriptionVerifyModal(
    isPremium: json["is_premium"],
    status: json["status"],
    currentStatus: json["current_status"],
    planName: json["plan_name"],
    planType: json["plan_type"],
    expiryDate: json["expiry_date"] == null ? null : DateTime.parse(json["expiry_date"]),
    isAutoRenewing: json["is_auto_renewing"],
    scansRemaining: json["scans_remaining"],
  );

  Map<String, dynamic> toJson() => {
    "is_premium": isPremium,
    "status": status,
    "current_status": currentStatus,
    "plan_name": planName,
    "plan_type": planType,
    "expiry_date": expiryDate?.toIso8601String(),
    "is_auto_renewing": isAutoRenewing,
    "scans_remaining": scansRemaining,
  };
}
