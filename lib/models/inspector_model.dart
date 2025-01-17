// To parse this JSON data, do
//
//     final inspector = inspectorFromJson(jsonString);

import 'dart:convert';

InspectorModel inspectorFromJson(String str) =>
    InspectorModel.fromJson(json.decode(str));

String inspectorToJson(InspectorModel data) => json.encode(data.toJson());

class InspectorModel {
  int id;
  String name;
  String? firstname;
  String? phone;
  String? email;
  // ajout d'un nouveau champs "bool isAsigned = false par defaut
  // et mettre a jour lorsque le scanToken est utilisé"
  String scanToken;

  InspectorModel({
    required this.id,
    required this.name,
    required this.firstname,
    required this.phone,
    required this.email,
    required this.scanToken,
  });

  factory InspectorModel.fromJson(Map<String, dynamic> json) => InspectorModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        firstname: json["firstname"] ?? "",
        phone: json["phone"] ?? "",
        email: json["email"] ?? "",
        scanToken: json["scan_token"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "firstname": firstname,
        "phone": phone,
        "email": email,
        "scan_token": scanToken,
      };
}
