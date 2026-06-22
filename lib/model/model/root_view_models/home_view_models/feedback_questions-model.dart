// To parse this JSON data, do
//
//     final feedbackQuestionstModel = feedbackQuestionstModelFromJson(jsonString);

import 'dart:convert';

List<FeedbackQuestionstModel> feedbackQuestionstModelFromJson(String str) => List<FeedbackQuestionstModel>.from(json.decode(str).map((x) => FeedbackQuestionstModel.fromJson(x)));

String feedbackQuestionstModelToJson(List<FeedbackQuestionstModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FeedbackQuestionstModel {
  final int? id;
  final String? question;


  FeedbackQuestionstModel({
    this.id,
    this.question,
  });

  factory FeedbackQuestionstModel.fromJson(Map<String, dynamic> json) => FeedbackQuestionstModel(
    id: json["id"],
    question: json["question"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
  };
}
