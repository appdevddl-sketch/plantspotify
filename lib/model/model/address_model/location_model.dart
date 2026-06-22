import 'dart:convert';


GetAddressModel getAddressModelFromJson(String str) => GetAddressModel.fromJson(json.decode(str));

String getAddressModelToJson(GetAddressModel data) => json.encode(data.toJson());

class GetAddressModel {
  GetAddressModel({
    this.results,
    this.status,
  });

  final List<Result> ?results;
  final String ?status;

  factory GetAddressModel.fromJson(Map<String, dynamic> json) => GetAddressModel(
    results: json["results"] == null ? null : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "results": results == null ? null : List<dynamic>.from(results!.map((x) => x.toJson())),
    "status": status == null ? null : status,
  };
}

class Result {
  Result({
    this.addressComponents,
    this.formattedAddress,
  });

  final List<AddressComponent> ?addressComponents;
  final String ?formattedAddress;


  factory Result.fromJson(Map<String, dynamic> json) => Result(
    addressComponents: json["address_components"] == null ? null : List<AddressComponent>.from(json["address_components"].map((x) => AddressComponent.fromJson(x))),
    formattedAddress: json["formatted_address"] == null ? null : json["formatted_address"],
  );

  Map<String, dynamic> toJson() => {
    "address_components": addressComponents == null ? null : List<dynamic>.from(addressComponents!.map((x) => x.toJson())),
    "formatted_address": formattedAddress == null ? null : formattedAddress,
  };
}

class AddressComponent {
  AddressComponent({
    this.longName,
    this.shortName,
    this.types,
  });

  final String ?longName;
  final String ?shortName;
  final List<String> ?types;

  factory AddressComponent.fromJson(Map<String, dynamic> json) => AddressComponent(
    longName: json["long_name"] == null ? null : json["long_name"],
    shortName: json["short_name"] == null ? null : json["short_name"],
    types: json["types"] == null ? null : List<String>.from(json["types"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "long_name": longName == null ? null : longName,
    "short_name": shortName == null ? null : shortName,
    "types": types == null ? null : List<dynamic>.from(types!.map((x) => x)),
  };
}


