// To parse this JSON data, do
//
//     final authModel = authModelFromJson(jsonString);

import 'dart:convert';

AuthModel authModelFromJson(String str) => AuthModel.fromJson(json.decode(str));

String authModelToJson(AuthModel data) => json.encode(data.toJson());

class AuthModel {
  String access;
  String refresh;
  AuthUser user;

  AuthModel({
    required this.access,
    required this.refresh,
    required this.user,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        access: json["access"],
        refresh: json["refresh"],
        user: AuthUser.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "access": access,
        "refresh": refresh,
        "user": user.toJson(),
      };
}

class AuthUser {
  int id;
  String email;
  String firstName;
  String lastName;
  String profileImage;

  AuthUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "profile_image": profileImage,
      };
}
