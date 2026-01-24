import 'package:bandu_business/src/model/api/main/employee/employee_model.dart';

class ResourceModel {
  List<Datum> data;
  String message;

  ResourceModel({
    required this.data,
    required this.message,
  });

  factory ResourceModel.fromJson(Map<String, dynamic> json) => ResourceModel(
    data: json["data"] == null || json["data"] is! List
        ? []
        : List<Datum>.from((json["data"] as List).map((x) => Datum.fromJson(x))),
    message: json["message"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class Datum {
  int id;
  String name;
  int price;
  ResourceCategory? resourceCategory;
  dynamic metadata;
  bool isBookable;
  bool isTimeSlotBased;
  int timeSlotDurationMinutes;
  List<Image> images;
  List<EmployeeItemData> businessUsers;

  Datum({
    required this.id,
    required this.name,
    required this.price,
    required this.resourceCategory,
    required this.metadata,
    required this.isBookable,
    required this.isTimeSlotBased,
    required this.timeSlotDurationMinutes,
    required this.images,
    required this.businessUsers,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] ?? 0,
    name: json["name"]?.toString() ?? "",
    price: json["price"] ?? 0,
    resourceCategory: json["resourceCategory"] == null || json["resourceCategory"] is! Map<String, dynamic>
        ? null
        : ResourceCategory.fromJson(json["resourceCategory"] as Map<String, dynamic>),
    metadata: json["metadata"],
    isBookable: json["isBookable"] ?? false,
    isTimeSlotBased: json["isTimeSlotBased"] ?? false,
    timeSlotDurationMinutes: json["timeSlotDurationMinutes"] ?? 0,
    images: json["images"] == null || json["images"] is! List
        ? []
        : List<Image>.from((json["images"] as List).map((x) => Image.fromJson(x))),
    businessUsers: json["businessUsers"] == null || json["businessUsers"] is! List
        ? []
        : List<EmployeeItemData>.from((json["businessUsers"] as List).map((x) => EmployeeItemData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "resourceCategory": resourceCategory?.toJson(),
    "metadata": metadata,
    "isBookable": isBookable,
    "isTimeSlotBased": isTimeSlotBased,
    "timeSlotDurationMinutes": timeSlotDurationMinutes,
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
    // "businessUsers": List<dynamic>.from(businessUsers.map((x) => x.toJson())),
  };
}

class Image {
  int id;
  String url;
  String filename;
  MimeType mimeType;
  int size;
  int index;
  bool isMain;
  DateTime createdAt;
  DateTime updatedAt;

  Image({
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

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    id: json["id"] ?? 0,
    url: json["url"]?.toString() ?? "",
    filename: json["filename"]?.toString() ?? "",
    mimeType: json["mimeType"] != null && mimeTypeValues.map.containsKey(json["mimeType"])
        ? mimeTypeValues.map[json["mimeType"]]!
        : MimeType.IMAGE_JPEG,
    size: json["size"] ?? 0,
    index: json["index"] ?? 0,
    isMain: json["isMain"] ?? false,
    createdAt: json["createdAt"] != null && json["createdAt"].toString().isNotEmpty
        ? DateTime.tryParse(json["createdAt"].toString()) ?? DateTime.now()
        : DateTime.now(),
    updatedAt: json["updatedAt"] != null && json["updatedAt"].toString().isNotEmpty
        ? DateTime.tryParse(json["updatedAt"].toString()) ?? DateTime.now()
        : DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
    "filename": filename,
    "mimeType": mimeTypeValues.reverse[mimeType],
    "size": size,
    "index": index,
    "isMain": isMain,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

enum MimeType {
  IMAGE_JPEG
}

final mimeTypeValues = EnumValues({
  "image/jpeg": MimeType.IMAGE_JPEG
});

class ResourceCategory {
  int id;
  String name;
  String description;
  dynamic metadata;

  ResourceCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.metadata,
  });

  factory ResourceCategory.fromJson(Map<String, dynamic> json) => ResourceCategory(
    id: json["id"] ?? 0,
    name: json["name"]?.toString() ?? "",
    description: json["description"]?.toString() ?? "",
    metadata: json["metadata"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "metadata": metadata,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
