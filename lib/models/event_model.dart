import 'dart:convert';

import '../constants/constants.dart';
import 'image_model.dart';
import 'inspector_model.dart';
import 'localization_model.dart';
import 'pass_model.dart';

/* List<EventModel> listEventModelFromJson(String str) =>
    List<EventModel>.from(json.decode(str).map((x) => EventModel.fromJson(x))); */

String listEventModelToJson(List<EventModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<EventModel> listEventModelFromJson(String str) {
  final jsonData = json.decode(str);

  // Récupère la liste d'objets à partir de la clé 'data'
  final data = jsonData['data'] as List;

  // Convertit chaque élément en un objet PrestatorMdel
  return List<EventModel>.from(data.map((x) => EventModel.fromJson(x)));
}

////single
EventModel eventModelFromJson(String str) =>
    EventModel.fromJson(json.decode(str));
String eventModelToJson(EventModel data) => json.encode(data.toJson());

class EventModel {
  final int id;
  final int categoryId;
  final int eventTypeId;
  final String name;
  final String uniqueCode;
  final String? slug;
  final String? description;
  final String? shortDescription;
  final bool free;
  final String? qrcode;
  final String? image;
  final bool published;
  final bool active;
  final DateTime? publishedAt;
  final String? paymentTerms;
  final String? infoline;
  final bool visibility;
  final String? shortUrl;
  final List<LocalizationModel> localizations;
  final List<PassModel>? passes;
  final List<InspectorModel>? inspectors;
  final String category;
  final List<ImageModel>? images;
  final String? video;
  final String eventType;

  EventModel({
    required this.id,
    required this.categoryId,
    required this.eventTypeId,
    required this.name,
    required this.uniqueCode,
    required this.slug,
    required this.description,
    required this.shortDescription,
    required this.free,
    this.qrcode,
    required this.image,
    required this.published,
    required this.active,
    this.publishedAt,
    this.paymentTerms,
    required this.infoline,
    required this.visibility,
    required this.shortUrl,
    required this.localizations,
    required this.passes,
    required this.inspectors,
    required this.category,
    required this.images,
    this.video,
    required this.eventType,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json["id"],
        categoryId: json["category_id"],
        eventTypeId: json["event_type_id"],
        name: json["name"],
        uniqueCode: json["unique_code"],
        slug: json["slug"],
        description: json["description"],
        shortDescription: json["short_description"],
        free: json["free"] == 0 ? false : true,
        qrcode: json["qrcode"],
        image: json["image"] != null
            ? 'https://anowan.com/events/images/${json["image"]}'
            : networtImgPlaceholder,
        published: json["published"] == 0 ? false : true,
        active: json["active"] == 0 ? false : true,
        publishedAt: json["published_at"] != null
            ? DateTime.parse(json["published_at"])
            : null,
        paymentTerms: json["payment_terms"],
        infoline: json["infoline"],
        visibility: json["visibility"] == 0 ? false : true,
        shortUrl: json["short_url"],
        localizations: List<LocalizationModel>.from(
            json["localizations"].map((x) => LocalizationModel.fromJson(x))),
        passes: json["passes"] != null
            ? List<PassModel>.from(
                json["passes"].map((x) => PassModel.fromJson(x)))
            : null,
        inspectors: json["inspectors"] != null
            ? List<InspectorModel>.from(
                json["inspectors"].map((x) => InspectorModel.fromJson(x)))
            : null,
        category: json["category"] ?? "",
        images: json["images"] != null
            ? List<ImageModel>.from(
                json["images"].map((x) => ImageModel.fromJson(x)))
            : null,
        video: json["video"],
        eventType: json["event_type"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "event_type_id": eventTypeId,
        "name": name,
        "unique_code": uniqueCode,
        "slug": slug,
        "description": description,
        "short_description": shortDescription,
        "free": free,
        "qrcode": qrcode,
        "image": image,
        "published": published,
        "active": active,
        "published_at": publishedAt!.toIso8601String(),
        "payment_terms": paymentTerms,
        "infoline": infoline,
        "visibility": visibility,
        "short_url": shortUrl,
        "localizations":
            List<LocalizationModel>.from(localizations.map((x) => x.toJson())),
        "passes": List<PassModel>.from(passes!.map((x) => x.toJson())),
        "inspectors":
            List<InspectorModel>.from(inspectors!.map((x) => x.toJson())),
        "category": category,
        "images": List<ImageModel>.from(images!.map((x) => x.toJson())),
        "video": video,
        "event_type": eventType,
      };
}
