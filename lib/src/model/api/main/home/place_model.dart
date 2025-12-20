import 'dart:convert';

PlaceModel placeModelFromJson(String str) =>
    PlaceModel.fromJson(json.decode(str));

class PlaceModel {
  final PlaceData data;

  PlaceModel({required this.data});

  factory PlaceModel.fromJson(Map<String, dynamic> json) => PlaceModel(
    data: json["data"] == null
        ? PlaceData.fromJson({})
        : PlaceData.fromJson(json["data"]),
  );
}

class PlaceData {
  final List<PlaceItemData> data;
  final String message;

  PlaceData({required this.data, required this.message});

  factory PlaceData.fromJson(Map<String, dynamic>? json) => PlaceData(
    data: json?["data"] == null
        ? List<PlaceItemData>.from({})
        : List<PlaceItemData>.from(json!["data"].map((x) => PlaceItemData.fromJson(x))),
    message: json?["message"] ?? "",
  );
}

class PlaceItemData {
  final int id;
  final String name;
  final int capacity;
  final dynamic visualMetadata;
  final int positionX;
  final int positionY;
  final bool isActive;
  final Company company;
  final PlaceCategory placeCategory;

  PlaceItemData({
    required this.id,
    required this.name,
    required this.capacity,
    required this.visualMetadata,
    required this.positionX,
    required this.positionY,
    required this.isActive,
    required this.company,
    required this.placeCategory,
  });

  factory PlaceItemData.fromJson(Map<String, dynamic> json) => PlaceItemData(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    capacity: json["capacity"] ?? 0,
    visualMetadata: json["visualMetadata"],
    positionX: json["positionX"] ?? 0,
    positionY: json["positionY"] ?? 0,
    isActive: json["isActive"] ?? false,

    company: json["company"] == null
        ? Company.fromJson({})
        : Company.fromJson(json["company"]),

    placeCategory: json["placeCategory"] == null
        ? PlaceCategory.fromJson({})
        : PlaceCategory.fromJson(json["placeCategory"]),
  );
}

class Company {
  final int id;
  final String name;
  final bool isOpen247;
  final String logo;
  final double rating;
  final WorkingHours workingHours;

  Company({
    required this.id,
    required this.name,
    required this.isOpen247,
    required this.logo,
    required this.rating,
    required this.workingHours,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    isOpen247: json["isOpen247"] ?? false,
    logo: json["logo"] ?? "",
    rating: json["rating"] ?? 0,
    workingHours: json["workingHours"] == null
        ? WorkingHours.fromJson({})
        : WorkingHours.fromJson(json["workingHours"]),
  );
}

class WorkingHours {
  final Day monday;
  final Day tuesday;
  final Day wednesday;
  final Day thursday;
  final Day friday;
  final Day saturday;
  final Day sunday;

  WorkingHours({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  factory WorkingHours.fromJson(Map<String, dynamic>? json) => WorkingHours(
    monday: json?["monday"] == null
        ? Day.fromJson({})
        : Day.fromJson(json!["monday"]),

    tuesday: json?["tuesday"] == null
        ? Day.fromJson({})
        : Day.fromJson(json!["tuesday"]),

    wednesday: json?["wednesday"] == null
        ? Day.fromJson({})
        : Day.fromJson(json!["wednesday"]),

    thursday: json?["thursday"] == null
        ? Day.fromJson({})
        : Day.fromJson(json!["thursday"]),

    friday: json?["friday"] == null
        ? Day.fromJson({})
        : Day.fromJson(json!["friday"]),

    saturday: json?["saturday"] == null
        ? Day.fromJson({})
        : Day.fromJson(json!["saturday"]),

    sunday: json?["sunday"] == null
        ? Day.fromJson({})
        : Day.fromJson(json!["sunday"]),
  );
}

class Day {
  final String open; // ENUM → STRING
  final String close; // ENUM → STRING
  final bool closed;

  Day({required this.open, required this.close, required this.closed});

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    open: json["open"] ?? "",
    close: json["close"] ?? "",
    closed: json["closed"] ?? false,
  );
}

class PlaceCategory {
  final int id;
  final String name; // ENUM → STRING
  final int price;

  PlaceCategory({required this.id, required this.name, required this.price});

  factory PlaceCategory.fromJson(Map<String, dynamic> json) => PlaceCategory(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    price: json["price"] ?? 0,
  );
}
