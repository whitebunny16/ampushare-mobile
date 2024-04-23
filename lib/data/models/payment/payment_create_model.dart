// To parse this JSON data, do
//
//     final paymentCreateModel = paymentCreateModelFromJson(jsonString);

import 'dart:convert';

PaymentCreateModel paymentCreateModelFromJson(String str) =>
    PaymentCreateModel.fromJson(json.decode(str));

String paymentCreateModelToJson(PaymentCreateModel data) =>
    json.encode(data.toJson());

class PaymentCreateModel {
  String paymentStatus;
  int amount;
  String paymentMethod;
  int appointment;

  PaymentCreateModel({
    required this.paymentStatus,
    required this.amount,
    required this.paymentMethod,
    required this.appointment,
  });

  factory PaymentCreateModel.fromJson(Map<String, dynamic> json) =>
      PaymentCreateModel(
        paymentStatus: json["payment_status"],
        amount: json["amount"],
        paymentMethod: json["payment_method"],
        appointment: json["appointment"],
      );

  Map<String, dynamic> toJson() => {
        "payment_status": paymentStatus,
        "amount": amount,
        "payment_method": paymentMethod,
        "appointment": appointment,
      };
}
