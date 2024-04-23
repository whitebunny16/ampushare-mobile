// To parse this JSON data, do
//
//     final appointmentCreateModel = appointmentCreateModelFromJson(jsonString);

import 'dart:convert';

AppointmentCreateModel appointmentCreateModelFromJson(String str) =>
    AppointmentCreateModel.fromJson(json.decode(str));

String appointmentCreateModelToJson(AppointmentCreateModel data) =>
    json.encode(data.toJson());

class AppointmentCreateModel {
  DateTime date;
  String time;
  String remark;
  int doctor;

  AppointmentCreateModel({
    required this.date,
    required this.time,
    required this.remark,
    required this.doctor,
  });

  factory AppointmentCreateModel.fromJson(Map<String, dynamic> json) =>
      AppointmentCreateModel(
        date: DateTime.parse(json["date"]),
        time: json["time"],
        remark: json["remark"],
        doctor: json["doctor"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
        "remark": remark,
        "doctor": doctor,
      };
}
