// To parse this JSON data, do
//
//     final createCompanyModel = createCompanyModelFromJson(jsonString);

import 'dart:convert';

String createCompanyModelToJson(CreateCompanyModel data) =>
    json.encode(data.toJson());

class CreateCompanyModel {
  String name;
  Location location;
  List<int> categoryIds;
  List<int> resourceCategoryIds;
  bool isOpen247;
  WorkingHours workingHours;
  List<ImageCreateModel> images;

  CreateCompanyModel({
    required this.name,
    required this.location,
    required this.categoryIds,
    required this.resourceCategoryIds,
    required this.isOpen247,
    required this.workingHours,
    required this.images,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "location": location.toJson(),
    "categoryIds": List<dynamic>.from(categoryIds.map((x) => x)),
    "resourceCategoryIds": List<dynamic>.from(
      resourceCategoryIds.map((x) => x),
    ),
    "isOpen247": isOpen247,
    "workingHours": workingHours.toJson(),
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
  };
}

class ImageCreateModel {
  String url;
  int index;
  bool isMain;

  ImageCreateModel({required this.url, required this.index, required this.isMain});

  Map<String, dynamic> toJson() => {
    "url": url,
    "index": index,
    "isMain": isMain,
  };
}

class Location {
  String address;
  double latitude;
  double longitude;

  Location({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
  };
}

class WorkingHours {
  Day monday;
  Day tuesday;
  Day wednesday;
  Day thursday;
  Day friday;
  Day saturday;
  Day sunday;

  WorkingHours({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  Map<String, dynamic> toJson() => {
    "monday": monday.toJson(),
    "tuesday": tuesday.toJson(),
    "wednesday": wednesday.toJson(),
    "thursday": thursday.toJson(),
    "friday": friday.toJson(),
    "saturday": saturday.toJson(),
    "sunday": sunday.toJson(),
  };
}

class Day {
  String? open;
  String? close;
  bool closed;

  Day({required this.open, required this.close, required this.closed});

  Map<String, dynamic> toJson() => {
    "open": open,
    "close": close,
    "closed": closed,
  };
}
