// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) => UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) => json.encode(data.toJson());

class UserProfileModel {
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

  UserProfileModel({
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

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
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
    "date_of_birth": "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
    "gender": gender,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
