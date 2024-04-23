// To parse this JSON data, do
//
//     final refreshTokenPayloadModel = refreshTokenPayloadModelFromJson(jsonString);

import 'dart:convert';

RefreshTokenPayloadModel refreshTokenPayloadModelFromJson(String str) => RefreshTokenPayloadModel.fromJson(json.decode(str));

String refreshTokenPayloadModelToJson(RefreshTokenPayloadModel data) => json.encode(data.toJson());

class RefreshTokenPayloadModel {
  String refresh;

  RefreshTokenPayloadModel({
    required this.refresh,
  });

  factory RefreshTokenPayloadModel.fromJson(Map<String, dynamic> json) => RefreshTokenPayloadModel(
    refresh: json["refresh"],
  );

  Map<String, dynamic> toJson() => {
    "refresh": refresh,
  };
}
