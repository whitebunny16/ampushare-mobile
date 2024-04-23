// To parse this JSON data, do
//
//     final profileSearchModel = profileSearchModelFromJson(jsonString);

import 'dart:convert';

List<ProfileSearchModel> profileSearchModelFromJson(String str) =>
    List<ProfileSearchModel>.from(
        json.decode(str).map((x) => ProfileSearchModel.fromJson(x)));

String profileSearchModelToJson(List<ProfileSearchModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProfileSearchModel {
  int userId;
  String firstName;
  String lastName;
  String email;
  String username;
  String profilePic;
  DateTime dateOfBirth;
  String gender;
  DateTime createdAt;
  DateTime updatedAt;

  ProfileSearchModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.profilePic,
    required this.dateOfBirth,
    required this.gender,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileSearchModel.fromJson(Map<String, dynamic> json) =>
      ProfileSearchModel(
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        username: json["username"],
        profilePic: json["profile_pic"],
        dateOfBirth: DateTime.parse(json["date_of_birth"]),
        gender: json["gender"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "username": username,
        "profile_pic": profilePic,
        "date_of_birth":
            "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
