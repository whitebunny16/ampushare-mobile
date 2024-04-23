// To parse this JSON data, do
//
//     final userRegistrationModel = userRegistrationModelFromJson(jsonString);

import 'dart:convert';

UserRegistrationModel userRegistrationModelFromJson(String str) =>
    UserRegistrationModel.fromJson(json.decode(str));

String userRegistrationModelToJson(UserRegistrationModel data) =>
    json.encode(data.toJson());

class UserRegistrationModel {
  String username;
  String email;
  String password;
  String firstName;
  String lastName;
  Profile profile;

  UserRegistrationModel({
    required this.username,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.profile,
  });

  factory UserRegistrationModel.fromJson(Map<String, dynamic> json) =>
      UserRegistrationModel(
        username: json["username"],
        email: json["email"],
        password: json["password"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        profile: Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "password": password,
        "first_name": firstName,
        "last_name": lastName,
        "profile": profile.toJson(),
      };
}

class Profile {
  DateTime dateOfBirth;
  String profilePic;
  String gender;

  Profile({
    required this.dateOfBirth,
    required this.profilePic,
    required this.gender,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        dateOfBirth: DateTime.parse(json["date_of_birth"]),
        profilePic: json["profile_pic"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "date_of_birth":
            "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "profile_pic": profilePic,
        "gender": gender,
      };
}
