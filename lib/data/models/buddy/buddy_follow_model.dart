// To parse this JSON data, do
//
//     final buddyFollowModel = buddyFollowModelFromJson(jsonString);

import 'dart:convert';

List<BuddyFollowModel> buddyFollowModelFromJson(String str) => List<BuddyFollowModel>.from(json.decode(str).map((x) => BuddyFollowModel.fromJson(x)));

String buddyFollowModelToJson(List<BuddyFollowModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BuddyFollowModel {
  int id;
  BuddyPartialModel follower;
  BuddyPartialModel following;

  BuddyFollowModel({
    required this.id,
    required this.follower,
    required this.following,
  });

  factory BuddyFollowModel.fromJson(Map<String, dynamic> json) => BuddyFollowModel(
    id: json["id"],
    follower: BuddyPartialModel.fromJson(json["follower"]),
    following: BuddyPartialModel.fromJson(json["following"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "follower": follower.toJson(),
    "following": following.toJson(),
  };
}

class BuddyPartialModel {
  int id;
  String firstName;
  String lastName;
  String username;
  String profilePic;

  BuddyPartialModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.profilePic,
  });

  factory BuddyPartialModel.fromJson(Map<String, dynamic> json) => BuddyPartialModel(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    username: json["username"],
    profilePic: json["profile_pic"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "username": username,
    "profile_pic": profilePic,
  };
}
