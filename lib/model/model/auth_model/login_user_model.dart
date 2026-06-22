// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final int? id;
  final String? name;
  final String? email;
  final int? age;
  final HomeType? homeType;
  final String? countryCode;
  final int? countryId;
  final String? countryName;
  final int? notificationCount;
  final bool? isPremium;
  final Subscribe? subscribe;
  final int? scanCount;
  final CurrentActiveSubscription? currentActiveSubscription;

  User({
    this.id,
    this.name,
    this.email,
    this.age,
    this.homeType,
    this.countryCode,
    this.countryId,
    this.countryName,
    this.notificationCount,
    this.isPremium,
    this.subscribe,
    this.scanCount,
    this.currentActiveSubscription,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    age: json["age"],
    homeType: json["home_type"] == null ? null : HomeType.fromJson(json["home_type"]),
    countryCode: json["country_code"],
    countryId: json["country_id"],
    countryName: json["country_name"],
    notificationCount: json["notification_count"],
    isPremium: json["is_premium"],
    subscribe: json["subscribe"] == null ? null : Subscribe.fromJson(json["subscribe"]),
    scanCount:  json["scan_count"] is String ? int.tryParse(json["scan_count"]) ?? 0 : json["scan_count"],
    currentActiveSubscription: json["current_active_subscription"] == null ? null : CurrentActiveSubscription.fromJson(json["current_active_subscription"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "age": age,
    "home_type": homeType?.toJson(),
    "country_code": countryCode,
    "country_id": countryId,
    "country_name": countryName,
    "notification_count": notificationCount,
    "is_premium": isPremium,
    "subscribe": subscribe?.toJson(),
    "scan_count": scanCount,
    "current_active_subscription": currentActiveSubscription?.toJson(),
  };
}

class CurrentActiveSubscription {
  final int? id;
  final String? platform;
  final String? status;
  final bool? isAutoRenewing;
  final DateTime? activationDate;
  final dynamic lastRenewDate;
  final DateTime? expiryDate;
  final Plan? plan;

  CurrentActiveSubscription({
    this.id,
    this.platform,
    this.status,
    this.isAutoRenewing,
    this.activationDate,
    this.lastRenewDate,
    this.expiryDate,
    this.plan,
  });

  factory CurrentActiveSubscription.fromJson(Map<String, dynamic> json) => CurrentActiveSubscription(
    id: json["id"],
    platform: json["platform"],
    status: json["status"],
    isAutoRenewing: json["is_auto_renewing"],
    activationDate: json["activation_date"] == null ? null : DateTime.parse(json["activation_date"]),
    lastRenewDate: json["last_renew_date"],
    expiryDate: json["expiry_date"] == null ? null : DateTime.parse(json["expiry_date"]),
    plan: json["plan"] == null ? null : Plan.fromJson(json["plan"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "platform": platform,
    "status": status,
    "is_auto_renewing": isAutoRenewing,
    "activation_date": activationDate?.toIso8601String(),
    "last_renew_date": lastRenewDate,
    "expiry_date": expiryDate?.toIso8601String(),
    "plan": plan?.toJson(),
  };
}

class Plan {
  final int? id;
  final String? name;
  final String? type;

  Plan({
    this.id,
    this.name,
    this.type,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    id: json["id"],
    name: json["name"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
  };
}

class HomeType {
  final int? id;
  final String? name;

  HomeType({
    this.id,
    this.name,
  });

  factory HomeType.fromJson(Map<String, dynamic> json) => HomeType(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class Subscribe {
  final String? text;
  final String? textColor;
  final String? bgColor;
  final String? icon;

  Subscribe({
    this.text,
    this.textColor,
    this.bgColor,
    this.icon,
  });

  factory Subscribe.fromJson(Map<String, dynamic> json) => Subscribe(
    text: json["text"],
    textColor: json["text_color"],
    bgColor: json["bg_color"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "text_color": textColor,
    "bg_color": bgColor,
    "icon": icon,
  };
}
