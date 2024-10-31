// To parse this JSON data, do
//
//     final participantModel = participantModelFromJson(jsonString);

import 'dart:convert';

List<ParticipantModel> participantModelFromJson(String str) =>
    List<ParticipantModel>.from(
        json.decode(str).map((x) => ParticipantModel.fromJson(x)));

String participantModelToJson(List<ParticipantModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ParticipantModel {
  final int id;
  final String? name;
  final String? firstName;
  final String? email;
  final String? phone;
  final String? phoneCode;
  final bool status;

  ParticipantModel({
    required this.id,
    required this.name,
    required this.firstName,
    required this.email,
    required this.phone,
    required this.phoneCode,
    required this.status,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) =>
      ParticipantModel(
        id: json["id"],
        name: json["name"],
        firstName: json["first_name"],
        email: json["email"],
        phone: json["phone"],
        phoneCode: json["phone_code"],
        status: json["status"] == 0 ? false : true,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "first_name": firstName,
        "email": email,
        "phone": phone,
        "phone_code": phoneCode,
        "status": status,
      };
}
