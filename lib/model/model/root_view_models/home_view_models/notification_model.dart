// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

import 'package:plants_spotify/model/model/pagination_model/pagination_model.dart';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  final List<NotificationData>? notifications;
  final Pagination? pagination;

  NotificationModel({
    this.notifications,
    this.pagination,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    notifications: json["notifications"] == null ? [] : List<NotificationData>.from(json["notifications"]!.map((x) => NotificationData.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "notifications": notifications == null ? [] : List<dynamic>.from(notifications!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class NotificationData {
  final String? group;
  final List<NotificationElement>? notifications;

  NotificationData({
    this.group,
    this.notifications,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    group: json["group"],
    notifications: json["notifications"] == null ? [] : List<NotificationElement>.from(json["notifications"]!.map((x) => NotificationElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "group": group,
    "notifications": notifications == null ? [] : List<dynamic>.from(notifications!.map((x) => x.toJson())),
  };
}

class NotificationElement {
  final String? id;
  final dynamic linkType;
  final dynamic linkId;
  final String? title;
  final String? message;
  final dynamic image;
  final DateTime? readAt;
  final String? timeAgo;
  final String? createdAt;

  NotificationElement({
    this.id,
    this.linkType,
    this.linkId,
    this.title,
    this.message,
    this.image,
    this.readAt,
    this.timeAgo,
    this.createdAt,
  });

  factory NotificationElement.fromJson(Map<String, dynamic> json) => NotificationElement(
    id: json["id"],
    linkType: json["link_type"],
    linkId: json["link_id"],
    title: json["title"],
    message: json["message"],
    image: json["image"],
    readAt: json["read_at"] == null ? null : DateTime.parse(json["read_at"]),
    timeAgo: json["time_ago"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "link_type": linkType,
    "link_id": linkId,
    "title": title,
    "message": message,
    "image": image,
    "read_at": readAt?.toIso8601String(),
    "time_ago": timeAgo,
    "created_at": createdAt,
  };
}

