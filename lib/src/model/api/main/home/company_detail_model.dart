import 'dart:convert';

CompanyDetailModel companyDetailModelFromJson(String str) =>
    CompanyDetailModel.fromJson(json.decode(str));

class CompanyDetailModel {
  CompanyDetailModelData data;

  CompanyDetailModel({required this.data});

  factory CompanyDetailModel.fromJson(Map<String, dynamic> json) =>
      CompanyDetailModel(
        data: json["data"] == null
            ? CompanyDetailModelData.fromJson({})
            : CompanyDetailModelData.fromJson(json["data"]),
      );
}

class CompanyDetailModelData {
  CompanyDetailData data;
  String message;

  CompanyDetailModelData({required this.data, required this.message});

  factory CompanyDetailModelData.fromJson(Map<String, dynamic> json) =>
      CompanyDetailModelData(
        data: json["data"] == null
            ? CompanyDetailData.fromJson({})
            : CompanyDetailData.fromJson(json["data"]),
        message: json["message"] ?? "",
      );
}

class CompanyDetailData {
  int id;
  String name;
  Location location;
  List<Category> categories;
  bool isOpen247;
  String logo;
  WorkingHours workingHours;
  List<Category> resourceCategories;
  List<Resource> resources;
  List<ImageData> images;

  CompanyDetailData({
    required this.id,
    required this.name,
    required this.location,
    required this.categories,
    required this.isOpen247,
    required this.logo,
    required this.workingHours,
    required this.resourceCategories,
    required this.resources,
    required this.images,
  });

  factory CompanyDetailData.fromJson(Map<String, dynamic> json) =>
      CompanyDetailData(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        location: json["location"] == null
            ? Location.fromJson({})
            : Location.fromJson(json["location"]),
        categories: json["categories"] == null
            ? List<Category>.from({})
            : List<Category>.from(
                json["categories"].map((x) => Category.fromJson(x)),
              ),
        isOpen247: json["isOpen247"] ?? false,
        logo: json["logo"] ?? "",
        workingHours: json["workingHours"] == null
            ? WorkingHours.fromJson({})
            : WorkingHours.fromJson(json["workingHours"]),
        resourceCategories: json["resourceCategories"] == null
            ? List<Category>.from({})
            : List<Category>.from(
                json["resourceCategories"].map((x) => Category.fromJson(x)),
              ),
        resources: json["resources"] == null
            ? List<Resource>.from({})
            : List<Resource>.from(
                json["resources"].map((x) => Resource.fromJson(x)),
              ),
        images: json["images"] == null
            ? List<ImageData>.from({})
            : List<ImageData>.from(
                json["images"].map((x) => ImageData.fromJson(x)),
              ),
      );
}

class Category {
  int id;
  String name;
  String description;
  CategoryMetadata metadata;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.metadata,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    description: json["description"] ?? "",
    metadata: json["metadata"] == null
        ? CategoryMetadata.fromJson({})
        : CategoryMetadata.fromJson(json["metadata"]),
  );
}

class CategoryMetadata {
  String type;
  String equipment;

  CategoryMetadata({required this.type, required this.equipment});

  factory CategoryMetadata.fromJson(Map<String, dynamic> json) =>
      CategoryMetadata(
        type: json["type"] ?? "",
        equipment: json["equipment"] ?? "",
      );
}

class ImageData {
  int id;
  String url;
  String filename;
  String mimeType;
  String size;
  int index;
  bool isMain;
  String createdAt;
  String updatedAt;

  ImageData({
    required this.id,
    required this.url,
    required this.filename,
    required this.mimeType,
    required this.size,
    required this.index,
    required this.isMain,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
    id: json["id"] ?? 0,
    url: json["url"] ?? "",
    filename: json["filename"] ?? "",
    mimeType: json["mimeType"] ?? "",
    size: json["size"]?.toString() ?? "",
    index: json["index"] ?? 0,
    isMain: json["isMain"] ?? false,
    createdAt: json["createdAt"] ?? "",
    updatedAt: json["updatedAt"] ?? "",
  );
}

class Location {
  int id;
  String address;
  double latitude;
  double longitude;

  Location({
    required this.id,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    id: json["id"] ?? 0,
    address: json["address"] ?? "",
    latitude: json["latitude"]?.toDouble() ?? 0.0,
    longitude: json["longitude"]?.toDouble() ?? 0.0,
  );
}

class Resource {
  int id;
  String name;
  int price;
  int selectCount;
  ResourceMetadata metadata;
  ResourceCategory category;
  bool isBookable;
  bool isTimeSlotBased;
  int timeSlotDurationMinutes;
  List<Image> images;

  Resource({
    required this.id,
    required this.name,
    required this.price,
    required this.metadata,
    required this.isBookable,
    required this.isTimeSlotBased,
    required this.timeSlotDurationMinutes,
    required this.images,
    required this.category,
    this.selectCount = 0,
  });

  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
    id: json["id"] ?? 0,
    name: json["name"]?.toString() ?? "",
    price: json["price"] ?? 0,
    metadata: json["metadata"] == null || json["metadata"] is! Map<String, dynamic>
        ? ResourceMetadata.fromJson({})
        : ResourceMetadata.fromJson(json["metadata"] as Map<String, dynamic>),
    isBookable: json["isBookable"] ?? false,
    isTimeSlotBased: json["isTimeSlotBased"] ?? false,
    timeSlotDurationMinutes: json["timeSlotDurationMinutes"] ?? 0,
    category: json["resourceCategory"] == null || json["resourceCategory"] is! Map<String, dynamic>
        ? ResourceCategory.fromJson({})
        : ResourceCategory.fromJson(json["resourceCategory"] as Map<String, dynamic>),
    images: json["images"] == null || json["images"] is! List
        ? List<Image>.from({})
        : List<Image>.from((json["images"] as List).map((x) => Image.fromJson(x))),
  );
}

class ResourceCategory {
  int id;
  String name;

  ResourceCategory({required this.id, required this.name});

  factory ResourceCategory.fromJson(Map<String, dynamic> json) =>
      ResourceCategory(
        id: json["id"] ?? 0, 
        name: json["name"]?.toString() ?? "",
      );
}

class Image {
  int id;
  String url;
  String filename;
  String mimeType;
  int size;
  int index;
  bool isMain;

  Image({
    required this.id,
    required this.url,
    required this.filename,
    required this.mimeType,
    required this.size,
    required this.index,
    required this.isMain,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    id: json["id"] ?? 0,
    url: json["url"]?.toString() ?? "",
    filename: json["filename"]?.toString() ?? "",
    mimeType: json["mimeType"]?.toString() ?? "",
    size: json["size"] ?? 0,
    index: json["index"] ?? 0,
    isMain: json["isMain"] ?? false,
  );
}

class ResourceMetadata {
  int capacity;
  List<String> equipment;

  ResourceMetadata({required this.capacity, required this.equipment});

  factory ResourceMetadata.fromJson(Map<String, dynamic> json) =>
      ResourceMetadata(
        capacity: json["capacity"] ?? 0,
        equipment: json["equipment"] == null
            ? List<String>.from({})
            : List<String>.from(json["equipment"].map((x) => x.toString())),
      );
}

class WorkingHours {
  FridayClass monday;
  FridayClass tuesday;
  FridayClass wednesday;
  FridayClass thursday;
  FridayClass friday;
  SaturdayClass saturday;
  SaturdayClass sunday;

  WorkingHours({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  factory WorkingHours.fromJson(Map<String, dynamic> json) => WorkingHours(
    monday: json["monday"] == null
        ? FridayClass.fromJson({})
        : FridayClass.fromJson(json["monday"]),
    tuesday: json["tuesday"] == null
        ? FridayClass.fromJson({})
        : FridayClass.fromJson(json["tuesday"]),
    wednesday: json["wednesday"] == null
        ? FridayClass.fromJson({})
        : FridayClass.fromJson(json["wednesday"]),
    thursday: json["thursday"] == null
        ? FridayClass.fromJson({})
        : FridayClass.fromJson(json["thursday"]),
    friday: json["friday"] == null
        ? FridayClass.fromJson({})
        : FridayClass.fromJson(json["friday"]),
    saturday: json["saturday"] == null
        ? SaturdayClass.fromJson({})
        : SaturdayClass.fromJson(json["saturday"]),
    sunday: json["sunday"] == null
        ? SaturdayClass.fromJson({})
        : SaturdayClass.fromJson(json["sunday"]),
  );
}

class FridayClass {
  String open;
  String close;
  bool closed;

  FridayClass({required this.open, required this.close, required this.closed});

  factory FridayClass.fromJson(Map<String, dynamic> json) => FridayClass(
    open: json["open"] ?? "",
    close: json["close"] ?? "",
    closed: json["closed"] ?? false,
  );
}

class SaturdayClass {
  bool closed;

  SaturdayClass({required this.closed});

  factory SaturdayClass.fromJson(Map<String, dynamic> json) =>
      SaturdayClass(closed: json["closed"] ?? false);
}
