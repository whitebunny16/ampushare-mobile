// To parse this JSON data, do
//
//     final doctorsViewModel = doctorsViewModelFromJson(jsonString);

import 'dart:convert';

List<DoctorsViewModel> doctorsViewModelFromJson(String str) =>
    List<DoctorsViewModel>.from(
        json.decode(str).map((x) => DoctorsViewModel.fromJson(x)));

String doctorsViewModelToJson(List<DoctorsViewModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DoctorsViewModel {
  int id;
  String firstName;
  String lastName;
  String image;
  String email;
  String phoneNumber;
  String speciality;

  DoctorsViewModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.email,
    required this.phoneNumber,
    required this.speciality,
  });

  factory DoctorsViewModel.fromJson(Map<String, dynamic> json) =>
      DoctorsViewModel(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        image: json["image"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        speciality: json["speciality"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "image": image,
        "email": email,
        "phone_number": phoneNumber,
        "speciality": speciality,
      };
}
