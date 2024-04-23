// To parse this JSON data, do
//
//     final postResponseModel = postResponseModelFromJson(jsonString);

import 'dart:convert';

PostResponseModel postResponseModelFromJson(String str) =>
    PostResponseModel.fromJson(json.decode(str));

String postResponseModelToJson(PostResponseModel data) =>
    json.encode(data.toJson());

class PostResponseModel {
  int id;
  String caption;
  String video;
  String image;
  String type;
  DateTime createdAt;
  DateTime updatedAt;
  int user;

  PostResponseModel({
    required this.id,
    required this.caption,
    required this.video,
    required this.image,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory PostResponseModel.fromJson(Map<String, dynamic> json) =>
      PostResponseModel(
        id: json["id"],
        caption: json["caption"],
        video: json["video"],
        image: json["image"],
        type: json["type"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "caption": caption,
        "video": video,
        "image": image,
        "type": type,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user": user,
      };
}
