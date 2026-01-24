import 'dart:convert';

import 'package:bandu_business/src/model/api/main/home/company_model.dart';

String createCompanyModelToJson(CreateCompanyModel data) =>
    json.encode(data.toJson());

class CreateCompanyModel {
  String name;
  Location location;
  List<int> categoryIds;
  List<int> resourceCategoryIds;
  bool isOpen247;
  WorkingHours? workingHours;
  List<ImageCreateModel> images;
  int? serviceTypeId;
  int? iconId;

  CreateCompanyModel({
    required this.name,
    required this.location,
    required this.categoryIds,
    required this.resourceCategoryIds,
    required this.isOpen247,
    required this.workingHours,
    required this.images,
    this.serviceTypeId,
    this.iconId,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "serviceTypeId": serviceTypeId ?? 1,
    "location": location.toJson(),
    "categoryIds": List<dynamic>.from(categoryIds.map((x) => x)),
    "isOpen247": isOpen247,
    "workingHours": workingHours != null ? workingHours!.toJson() : {},
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
    if (iconId != null) "iconId": iconId,
  };
}

class UpdateCompanyModel extends CreateCompanyModel {
  UpdateCompanyModel({
    required super.name,
    required super.location,
    required super.categoryIds,
    required super.resourceCategoryIds,
    required super.isOpen247,
    required super.workingHours,
    required super.images,
    super.serviceTypeId,
    super.iconId,
  });

  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      "name": name,
      "serviceTypeId": serviceTypeId ?? 1,
      "location": location.toJson(),
      "categoryIds": categoryIds.isNotEmpty
          ? List<dynamic>.from(categoryIds.map((x) => x))
          : [],
      "resourceCategoryIds": resourceCategoryIds.isNotEmpty
          ? List<dynamic>.from(resourceCategoryIds.map((x) => x))
          : [],
      "isOpen247": isOpen247,
      "images": List<dynamic>.from(images.map((x) => x.toJson())),
    };
    
    if (workingHours != null) {
      json["workingHours"] = workingHours!.toJson();
    }
    
    if (iconId != null) {
      json["iconId"] = iconId;
    }
    
    return json;
  }

  factory UpdateCompanyModel.fromCompanyData(CompanyData data) {
    return UpdateCompanyModel(
      name: data.name,
      serviceTypeId: data.serviceTypeId ?? 1,
      location: Location(
        address: data.location.address,
        latitude: data.location.latitude,
        longitude: data.location.longitude,
      ),
      categoryIds: data.categories.map((e) => e.id).toList(),
      resourceCategoryIds: data.resourceCategoryIds ?? [],
      isOpen247: data.isOpen247,
      workingHours: WorkingHours(
        monday: Day(
          open: data.workingHours.monday.open,
          close: data.workingHours.monday.close,
          closed: data.workingHours.monday.closed,
        ),
        tuesday: Day(
          open: data.workingHours.tuesday.open,
          close: data.workingHours.tuesday.close,
          closed: data.workingHours.tuesday.closed,
        ),
        wednesday: Day(
          open: data.workingHours.wednesday.open,
          close: data.workingHours.wednesday.close,
          closed: data.workingHours.wednesday.closed,
        ),
        thursday: Day(
          open: data.workingHours.thursday.open,
          close: data.workingHours.thursday.close,
          closed: data.workingHours.thursday.closed,
        ),
        friday: Day(
          open: data.workingHours.friday.open,
          close: data.workingHours.friday.close,
          closed: data.workingHours.friday.closed,
        ),
        saturday: Day(
          open: null,
          close: null,
          closed: data.workingHours.saturday.closed,
        ),
        sunday: Day(
          open: null,
          close: null,
          closed: data.workingHours.sunday.closed,
        ),
      ),
      images: data.images
          .map((e) => ImageCreateModel(
                url: e.url,
                index: e.index,
                isMain: e.isMain,
              ))
          .toList(),
    );
  }
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
