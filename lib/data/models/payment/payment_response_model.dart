// To parse this JSON data, do
//
//     final paymentResponseModel = paymentResponseModelFromJson(jsonString);

import 'dart:convert';

PaymentResponseModel paymentResponseModelFromJson(String str) =>
    PaymentResponseModel.fromJson(json.decode(str));

String paymentResponseModelToJson(PaymentResponseModel data) =>
    json.encode(data.toJson());

class PaymentResponseModel {
  int id;
  String paymentStatus;
  int amount;
  String paymentMethod;
  int appointment;

  PaymentResponseModel({
    required this.id,
    required this.paymentStatus,
    required this.amount,
    required this.paymentMethod,
    required this.appointment,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) =>
      PaymentResponseModel(
        id: json["id"],
        paymentStatus: json["payment_status"],
        amount: json["amount"],
        paymentMethod: json["payment_method"],
        appointment: json["appointment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "payment_status": paymentStatus,
        "amount": amount,
        "payment_method": paymentMethod,
        "appointment": appointment,
      };
}
