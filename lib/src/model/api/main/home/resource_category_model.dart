class ResourceCategoryModel {
  Data data;

  ResourceCategoryModel({required this.data});

  factory ResourceCategoryModel.fromJson(Map<String, dynamic> json) =>
      ResourceCategoryModel(
        data: json["data"] == null || json["data"] is! Map
            ? Data.fromJson(<String, dynamic>{})
            : Data.fromJson(json["data"] as Map<String, dynamic>),
      );
}

class Data {
  List<ResourceCategoryData> data;
  String message;

  Data({required this.data, required this.message});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    data: json["data"] == null || json["data"] is! List
        ? <ResourceCategoryData>[]
        : List<ResourceCategoryData>.from(
            (json["data"] as List).map((x) => x is Map<String, dynamic> 
                ? ResourceCategoryData.fromJson(x) 
                : ResourceCategoryData(
                    id: 0,
                    name: "",
                    parent: null,
                    children: [],
                  )),
          ),
    message: json["message"] ?? "",
  );
}

class ResourceCategoryData {
  int id;
  String name;
  String? description;
  Category? parent;
  List<Category> children;
  dynamic metadata;

  ResourceCategoryData({
    required this.id,
    required this.name,
    this.description,
    this.parent,
    required this.children,
    this.metadata,
  });

  factory ResourceCategoryData.fromJson(Map<String, dynamic> json) =>
      ResourceCategoryData(
        id: json["id"] is int ? json["id"] : (json["id"] != null ? int.tryParse(json["id"].toString()) ?? 0 : 0),
        name: json["name"]?.toString() ?? "",
        description: json["description"]?.toString(),
        parent: json["parent"] == null || json["parent"] is! Map
            ? null
            : Category.fromJson(json["parent"] as Map<String, dynamic>),
        children: json["children"] == null || json["children"] is! List
            ? <Category>[]
            : List<Category>.from(
                (json["children"] as List).map((x) => x is Map<String, dynamic>
                    ? Category.fromJson(x)
                    : Category(id: 0, name: "")),
              ),
        metadata: json["metadata"],
      );
}

class Category {
  int id;
  String name;
  String? description;
  dynamic metadata;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.metadata,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"] is int ? json["id"] : (json["id"] != null ? int.tryParse(json["id"].toString()) ?? 0 : 0),
        name: json["name"]?.toString() ?? "",
        description: json["description"]?.toString(),
        metadata: json["metadata"],
      );
}

class ResourceItem {
  int id;
  String name;
  int price;
  ResourceCategoryInfo? resourceCategory;
  dynamic metadata;
  bool isBookable;
  bool isTimeSlotBased;
  int timeSlotDurationMinutes;
  List<ResourceImage> images;
  int resourceCategoryId;

  ResourceItem({
    required this.id,
    required this.name,
    required this.price,
    this.resourceCategory,
    this.metadata,
    required this.isBookable,
    required this.isTimeSlotBased,
    required this.timeSlotDurationMinutes,
    required this.images,
    required this.resourceCategoryId,
  });

  factory ResourceItem.fromJson(Map<String, dynamic> json) => ResourceItem(
        id: json["id"] is int ? json["id"] : (json["id"] != null ? int.tryParse(json["id"].toString()) ?? 0 : 0),
        name: json["name"]?.toString() ?? "",
        price: json["price"] is int ? json["price"] : (json["price"] != null ? int.tryParse(json["price"].toString()) ?? 0 : 0),
        resourceCategory: json["resourceCategory"] == null || json["resourceCategory"] is! Map
            ? null
            : ResourceCategoryInfo.fromJson(json["resourceCategory"] as Map<String, dynamic>),
        metadata: json["metadata"],
        isBookable: json["isBookable"] is bool ? json["isBookable"] : false,
        isTimeSlotBased: json["isTimeSlotBased"] is bool ? json["isTimeSlotBased"] : false,
        timeSlotDurationMinutes: json["timeSlotDurationMinutes"] is int ? json["timeSlotDurationMinutes"] : (json["timeSlotDurationMinutes"] != null ? int.tryParse(json["timeSlotDurationMinutes"].toString()) ?? 0 : 0),
        images: json["images"] == null || json["images"] is! List
            ? <ResourceImage>[]
            : List<ResourceImage>.from(
                (json["images"] as List).map((x) => x is Map<String, dynamic>
                    ? ResourceImage.fromJson(x)
                    : ResourceImage(
                        id: 0,
                        url: "",
                        filename: "",
                        mimeType: "",
                        size: 0,
                        index: 0,
                        isMain: false,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      )),
              ),
        resourceCategoryId: json["resourceCategoryId"] is int ? json["resourceCategoryId"] : (json["resourceCategoryId"] != null ? int.tryParse(json["resourceCategoryId"].toString()) ?? 0 : 0),
      );
}

class ResourceCategoryInfo {
  int id;
  String name;
  String? description;
  dynamic metadata;

  ResourceCategoryInfo({
    required this.id,
    required this.name,
    this.description,
    this.metadata,
  });

  factory ResourceCategoryInfo.fromJson(Map<String, dynamic> json) =>
      ResourceCategoryInfo(
        id: json["id"] is int ? json["id"] : (json["id"] != null ? int.tryParse(json["id"].toString()) ?? 0 : 0),
        name: json["name"]?.toString() ?? "",
        description: json["description"]?.toString(),
        metadata: json["metadata"],
      );
}

class ResourceImage {
  int id;
  String url;
  String filename;
  String mimeType;
  int size;
  int index;
  bool isMain;
  DateTime createdAt;
  DateTime updatedAt;

  ResourceImage({
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

  factory ResourceImage.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic dateValue) {
      if (dateValue == null) return DateTime.now();
      try {
        if (dateValue is String) {
          return DateTime.parse(dateValue);
        }
        return DateTime.now();
      } catch (e) {
        return DateTime.now();
      }
    }
    
    return ResourceImage(
      id: json["id"] is int ? json["id"] : (json["id"] != null ? int.tryParse(json["id"].toString()) ?? 0 : 0),
      url: json["url"]?.toString() ?? "",
      filename: json["filename"]?.toString() ?? "",
      mimeType: json["mimeType"]?.toString() ?? "",
      size: json["size"] is int ? json["size"] : (json["size"] != null ? int.tryParse(json["size"].toString()) ?? 0 : 0),
      index: json["index"] is int ? json["index"] : (json["index"] != null ? int.tryParse(json["index"].toString()) ?? 0 : 0),
      isMain: json["isMain"] is bool ? json["isMain"] : false,
      createdAt: parseDate(json["createdAt"]),
      updatedAt: parseDate(json["updatedAt"]),
    );
  }
}
