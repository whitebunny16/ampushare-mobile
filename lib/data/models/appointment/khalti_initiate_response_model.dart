import 'dart:convert';

class KhaltiInitiateResponseModel {
  String pidx;

  KhaltiInitiateResponseModel({
    required this.pidx,
  });

  factory KhaltiInitiateResponseModel.fromJson(Map<String, dynamic> json) =>
      KhaltiInitiateResponseModel(
        pidx: json["pidx"],
      );

}
