// To parse this JSON data, do
//
//     final commentViewModel = commentViewModelFromJson(jsonString);

import 'dart:convert';

List<CommentViewModel> commentViewModelFromJson(String str) =>
    List<CommentViewModel>.from(
        json.decode(str).map((x) => CommentViewModel.fromJson(x)));

String commentViewModelToJson(List<CommentViewModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentViewModel {
  int id;
  CommentUser user;
  int post;
  String text;
  DateTime createdAt;

  CommentViewModel({
    required this.id,
    required this.user,
    required this.post,
    required this.text,
    required this.createdAt,
  });

  factory CommentViewModel.fromJson(Map<String, dynamic> json) =>
      CommentViewModel(
        id: json["id"],
        user: CommentUser.fromJson(json["user"]),
        post: json["post"],
        text: json["text"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "post": post,
        "text": text,
        "created_at": createdAt.toIso8601String(),
      };
}

class CommentUser {
  int id;
  String username;
  String profilePic;

  CommentUser({
    required this.id,
    required this.username,
    required this.profilePic,
  });

  factory CommentUser.fromJson(Map<String, dynamic> json) => CommentUser(
        id: json["id"],
        username: json["username"],
        profilePic: json["profile_pic"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "profile_pic": profilePic,
      };
}
