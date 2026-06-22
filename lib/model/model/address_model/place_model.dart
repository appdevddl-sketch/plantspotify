import 'dart:convert';

GetPlacesModel getPlacesModelFromJson(String str) => GetPlacesModel.fromJson(json.decode(str));

String getPlacesModelToJson(GetPlacesModel data) => json.encode(data.toJson());

class GetPlacesModel {
  GetPlacesModel({
    this.predictions,
    this.status,
  });

  final List<Prediction> ?predictions;
  final String ?status;

  factory GetPlacesModel.fromJson(Map<String, dynamic> json) => GetPlacesModel(
    predictions: json["predictions"] == null ? null : List<Prediction>.from(json["predictions"].map((x) => Prediction.fromJson(x))),
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "predictions": predictions == null ? null : List<dynamic>.from(predictions!.map((x) => x.toJson())),
    "status": status == null ? null : status,
  };
}

class Prediction {
  Prediction({
    this.description,
    this.matchedSubstrings,
    this.placeId,
    this.reference,
    this.structuredFormatting,

  });

  final String ?description;
  final List<MatchedSubstring> ?matchedSubstrings;
  final String ?placeId;
  final StructuredFormatting? structuredFormatting;

  final String ?reference;

  factory Prediction.fromJson(Map<String, dynamic> json) => Prediction(
    description: json["description"] == null ? null : json["description"],
    structuredFormatting: json["structured_formatting"] == null ? null : StructuredFormatting.fromJson(json["structured_formatting"]),

    matchedSubstrings: json["matched_substrings"] == null ? null : List<MatchedSubstring>.from(json["matched_substrings"].map((x) => MatchedSubstring.fromJson(x))),
    placeId: json["place_id"] == null ? null : json["place_id"],
    reference: json["reference"] == null ? null : json["reference"],
  );

  Map<String, dynamic> toJson() => {
    "description": description == null ? null : description,
    "matched_substrings": matchedSubstrings == null ? null : List<dynamic>.from(matchedSubstrings!.map((x) => x.toJson())),
    "place_id": placeId == null ? null : placeId,
    "reference": reference == null ? null : reference,
    "structured_formatting": structuredFormatting?.toJson(),

  };
}

class StructuredFormatting {
  final String? mainText;
  final List<MatchedSubstring>? mainTextMatchedSubstrings;
  final String? secondaryText;

  StructuredFormatting({
    this.mainText,
    this.mainTextMatchedSubstrings,
    this.secondaryText,
  });

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) => StructuredFormatting(
    mainText: json["main_text"],
    mainTextMatchedSubstrings: json["main_text_matched_substrings"] == null ? [] : List<MatchedSubstring>.from(json["main_text_matched_substrings"]!.map((x) => MatchedSubstring.fromJson(x))),
    secondaryText: json["secondary_text"],
  );

  Map<String, dynamic> toJson() => {
    "main_text": mainText,
    "main_text_matched_substrings": mainTextMatchedSubstrings == null ? [] : List<dynamic>.from(mainTextMatchedSubstrings!.map((x) => x.toJson())),
    "secondary_text": secondaryText,
  };
}
class MatchedSubstring {
  MatchedSubstring({
    this.length,
    this.offset,
  });

  final int ?length;
  final int ?offset;

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) => MatchedSubstring(
    length: json["length"] == null ? null : json["length"],
    offset: json["offset"] == null ? null : json["offset"],
  );

  Map<String, dynamic> toJson() => {
    "length": length == null ? null : length,
    "offset": offset == null ? null : offset,
  };
}

