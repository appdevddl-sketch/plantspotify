// To parse this JSON data, do
//
//     final diagnoseQuestionsModel = diagnoseQuestionsModelFromJson(jsonString);

import 'dart:convert';

DiagnoseQuestionsModel diagnoseQuestionsModelFromJson(String str) => DiagnoseQuestionsModel.fromJson(json.decode(str));

String diagnoseQuestionsModelToJson(DiagnoseQuestionsModel data) => json.encode(data.toJson());

class DiagnoseQuestionsModel {
  final List<Question>? questions;

  DiagnoseQuestionsModel({
    this.questions,
  });

  factory DiagnoseQuestionsModel.fromJson(Map<String, dynamic> json) => DiagnoseQuestionsModel(
    questions: json["questions"] == null ? [] : List<Question>.from(json["questions"]!.map((x) => Question.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "questions": questions == null ? [] : List<dynamic>.from(questions!.map((x) => x.toJson())),
  };
}

class Question {
  final int? id;
  final String? question;
  final List<Option>? options;

  Question({
    this.id,
    this.question,
    this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json["id"],
    question: json["question"],
    options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toJson())),
  };
}

class Option {
  final int? id;
  final String? text;

  Option({
    this.id,
    this.text,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    id: json["id"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
  };
}
