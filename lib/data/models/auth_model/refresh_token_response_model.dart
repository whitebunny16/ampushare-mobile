// To parse this JSON data, do
//
//     final refreshTokenResponseModel = refreshTokenResponseModelFromJson(jsonString);

import 'dart:convert';

RefreshTokenResponseModel refreshTokenResponseModelFromJson(String str) =>
    RefreshTokenResponseModel.fromJson(json.decode(str));

String refreshTokenResponseModelToJson(RefreshTokenResponseModel data) =>
    json.encode(data.toJson());

class RefreshTokenResponseModel {
  String access;

  RefreshTokenResponseModel({
    required this.access,
  });

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) =>
      RefreshTokenResponseModel(
        access: json["access"],
      );

  Map<String, dynamic> toJson() => {
        "access": access,
      };
}
