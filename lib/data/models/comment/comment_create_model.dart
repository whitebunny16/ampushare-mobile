// To parse this JSON data, do
//
//     final commentCreateModel = commentCreateModelFromJson(jsonString);

import 'dart:convert';

CommentCreateModel commentCreateModelFromJson(String str) =>
    CommentCreateModel.fromJson(json.decode(str));

String commentCreateModelToJson(CommentCreateModel data) =>
    json.encode(data.toJson());

class CommentCreateModel {
  String text;

  CommentCreateModel({
    required this.text,
  });

  factory CommentCreateModel.fromJson(Map<String, dynamic> json) =>
      CommentCreateModel(
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
      };
}
