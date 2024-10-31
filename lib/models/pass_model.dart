import 'dart:convert';

List<PassModel> listPassModelFromJson(String str) =>
    List<PassModel>.from(json.decode(str).map((x) => PassModel.fromJson(x)));

String listPassModelToJson(List<PassModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

//single
PassModel passModelFromJson(String str) => PassModel.fromJson(json.decode(str));

String passModelToJson(PassModel data) => json.encode(data.toJson());

class PassModel {
  final int id;
  final int eventId;
  final String name;
  final String? description;
  final int price;
  final String? passesQuantity;
  final String? remainingPasses;
  final bool unlimited;
  final bool active;
  final String peopleMax; // peaople max default 1

  PassModel({
    required this.id,
    required this.eventId,
    required this.name,
    required this.description,
    required this.price,
    required this.passesQuantity,
    required this.remainingPasses,
    required this.unlimited,
    required this.active,
    required this.peopleMax,
  });

  factory PassModel.fromJson(Map<String, dynamic> json) => PassModel(
        id: json["id"],
        eventId: json["event_id"] ?? 0,
        name: json["name"] ?? '',
        description: json["description"] ?? '',
        price: json["price"] ?? 0,
        passesQuantity: json["passes_quantity"] ?? '',
        remainingPasses: json["remaining_passes"] ?? '',
        unlimited: json["unlimited"] == 0 ? false : true,
        active: json["active"] == 0 ? false : true,
        peopleMax: json["people_max"] ?? '1',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_id": eventId,
        "name": name,
        "description": description,
        "price": price,
        "passes_quantity": passesQuantity,
        "remaining_passes": remainingPasses,
        "unlimited": unlimited,
        "active": active,
        "people_max": peopleMax,
      };

  static List<PassModel> sortPassesByPrice(List<PassModel> passes) {
    passes.sort((a, b) => a.price.compareTo(b.price));
    return passes;
  }
}
