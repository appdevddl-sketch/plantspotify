import 'package:in_app_purchase/in_app_purchase.dart';

class IapProductModel {
  final String id;
  final String title;
  final String description;
  final String price;
  final double rawPrice;
  final String currencyCode;

  IapProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rawPrice,
    required this.currencyCode,
  });

  /// Convert ProductDetails → IapProductModel
  factory IapProductModel.fromProductDetails(ProductDetails p) {
    return IapProductModel(
      id: p.id,
      title: p.title,
      description: p.description,
      price: p.price,
      rawPrice: p.rawPrice ?? 0.0,
      currencyCode: p.currencyCode,
    );
  }

  /// Convert JSON → Model
  factory IapProductModel.fromJson(Map<String, dynamic> json) {
    return IapProductModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      rawPrice: (json['rawPrice'] ?? 0).toDouble(),
      currencyCode: json['currencyCode'] ?? '',
    );
  }

  /// Convert Model → JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "price": price,
      "rawPrice": rawPrice,
      "currencyCode": currencyCode,
    };
  }
}
