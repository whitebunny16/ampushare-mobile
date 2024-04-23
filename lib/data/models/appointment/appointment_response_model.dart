// To parse this JSON data, do
//
//     final appointmentResponseModel = appointmentResponseModelFromJson(jsonString);

import 'dart:convert';

AppointmentResponseModel appointmentResponseModelFromJson(String str) =>
    AppointmentResponseModel.fromJson(json.decode(str));

String appointmentResponseModelToJson(AppointmentResponseModel data) =>
    json.encode(data.toJson());

class AppointmentResponseModel {
  int id;
  DateTime date;
  String time;
  String remark;
  int doctor;

  AppointmentResponseModel({
    required this.id,
    required this.date,
    required this.time,
    required this.remark,
    required this.doctor,
  });

  factory AppointmentResponseModel.fromJson(Map<String, dynamic> json) =>
      AppointmentResponseModel(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        remark: json["remark"],
        doctor: json["doctor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
        "remark": remark,
        "doctor": doctor,
      };
}
