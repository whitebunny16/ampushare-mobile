// To parse this JSON data, do
//
//     final commentResponseModel = commentResponseModelFromJson(jsonString);

import 'dart:convert';

CommentResponseModel commentResponseModelFromJson(String str) =>
    CommentResponseModel.fromJson(json.decode(str));

String commentResponseModelToJson(CommentResponseModel data) =>
    json.encode(data.toJson());

class CommentResponseModel {
  int id;
  String text;
  DateTime createdAt;
  int user;
  int post;

  CommentResponseModel({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.user,
    required this.post,
  });

  factory CommentResponseModel.fromJson(Map<String, dynamic> json) =>
      CommentResponseModel(
        id: json["id"],
        text: json["text"],
        createdAt: DateTime.parse(json["created_at"]),
        user: json["user"],
        post: json["post"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "created_at": createdAt.toIso8601String(),
        "user": user,
        "post": post,
      };
}
