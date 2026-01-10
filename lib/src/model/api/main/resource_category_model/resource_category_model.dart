class ResourceCategoryModel {
  Data data;

  ResourceCategoryModel({
    required this.data,
  });

  factory ResourceCategoryModel.fromJson(Map<String, dynamic> json) => ResourceCategoryModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  List<Datum> data;
  String message;

  Data({
    required this.data,
    required this.message,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class Datum {
  Category category;
  List<ResourceItem> resources;

  Datum({
    required this.category,
    required this.resources,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    category: Category.fromJson(json["category"]),
    resources: json["resources"] == null
        ? []
        : List<ResourceItem>.from(json["resources"].map((x) => ResourceItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "category": category.toJson(),
    "resources": List<dynamic>.from(resources.map((x) => x.toJson())),
  };
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
    id: json["id"],
    name: json["name"],
    description: json["description"],
    metadata: json["metadata"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "metadata": metadata,
  };
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
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    price: json["price"] ?? 0,
    resourceCategory: json["resourceCategory"] == null
        ? null
        : ResourceCategoryInfo.fromJson(json["resourceCategory"]),
    metadata: json["metadata"],
    isBookable: json["isBookable"] ?? false,
    isTimeSlotBased: json["isTimeSlotBased"] ?? false,
    timeSlotDurationMinutes: json["timeSlotDurationMinutes"] ?? 0,
    images: json["images"] == null
        ? []
        : List<ResourceImage>.from(json["images"].map((x) => ResourceImage.fromJson(x))),
    resourceCategoryId: json["resourceCategoryId"] ?? 0,
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
    "resourceCategoryId": resourceCategoryId,
  };
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

  factory ResourceCategoryInfo.fromJson(Map<String, dynamic> json) => ResourceCategoryInfo(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    description: json["description"],
    metadata: json["metadata"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "metadata": metadata,
  };
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

  factory ResourceImage.fromJson(Map<String, dynamic> json) => ResourceImage(
    id: json["id"] ?? 0,
    url: json["url"] ?? "",
    filename: json["filename"] ?? "",
    mimeType: json["mimeType"] ?? "",
    size: json["size"] ?? 0,
    index: json["index"] ?? 0,
    isMain: json["isMain"] ?? false,
    createdAt: DateTime.parse(json["createdAt"] ?? DateTime.now().toIso8601String()),
    updatedAt: DateTime.parse(json["updatedAt"] ?? DateTime.now().toIso8601String()),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
    "filename": filename,
    "mimeType": mimeType,
    "size": size,
    "index": index,
    "isMain": isMain,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}


Map<String , dynamic> bigResponse = {
  "data" : [
    {
      "name": "1-maktab",
      "item name": "sinf",
      "items": [
        {
          "name": "1-A sinf",
          "item name": "teacher",
          "items": [
            {
              "name": "O'qituvchi 1.1",
              "item name": "student",
              "items": [
                {
                  "name": "O'quvchi 1.1.1",
                  "item name": "book",
                  "items": [
                    {"name": "Matematika", "item name": "info", "items": []},
                    {"name": "Fizika", "item name": "info", "items": []}
                  ]
                },
                {
                  "name": "O'quvchi 1.1.2",
                  "item name": "book",
                  "items": [
                    {"name": "Tarix", "item name": "info", "items": []},
                    {"name": "Ona tili", "item name": "info", "items": []}
                  ]
                }
              ]
            },
            {
              "name": "O'qituvchi 1.2",
              "item name": "student",
              "items": [
                {
                  "name": "O'quvchi 1.2.1",
                  "item name": "book",
                  "items": [
                    {"name": "Kimyo", "item name": "info", "items": []},
                    {"name": "Biologiya", "item name": "info", "items": []}
                  ]
                },
                {
                  "name": "O'quvchi 1.2.2",
                  "item name": "book",
                  "items": [
                    {"name": "Ingliz tili", "item name": "info", "items": []},
                    {"name": "Geometriya", "item name": "info", "items": []}
                  ]
                }
              ]
            }
          ]
        },
        {
          "name": "1-B sinf",
          "item name": "teacher",
          "items": [
            {
              "name": "O'qituvchi 1.3",
              "item name": "student",
              "items": [
                {
                  "name": "O'quvchi 1.3.1",
                  "item name": "book",
                  "items": [
                    {"name": "Adabiyot", "item name": "info", "items": []},
                    {"name": "Rus tili", "item name": "info", "items": []}
                  ]
                },
                {
                  "name": "O'quvchi 1.3.2",
                  "item name": "book",
                  "items": [
                    {"name": "Informatika", "item name": "info", "items": []},
                    {"name": "Musiqa", "item name": "info", "items": []}
                  ]
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "name": "2-maktab",
      "item name": "sinf",
      "items": [
        {
          "name": "2-A sinf",
          "item name": "teacher",
          "items": [
            {
              "name": "O'qituvchi 2.1",
              "item name": "student",
              "items": [
                { "name": "O'quvchi 2.1.1", "item name": "book", "items": [ {"name": "Kitob A", "item name": "info", "items": []}, {"name": "Kitob B", "item name": "info", "items": []} ] }
              ]
            }
          ]
        }
      ]
    },
    {
      "name": "3-maktab",
      "item name": "sinf",
      "items": [
        {
          "name": "3-A sinf",
          "item name": "teacher",
          "items": [
            {
              "name": "O'qituvchi 3.1",
              "item name": "student",
              "items": [
                { "name": "O'quvchi 3.1.1", "item name": "book", "items": [ {"name": "Kitob C", "item name": "info", "items": []} ] }
              ]
            }
          ]
        }
      ]
    },
    {
      "name": "4-maktab",
      "item name": "sinf",
      "items": [
        {
          "name": "4-A sinf",
          "item name": "teacher",
          "items": [
            {
              "name": "O'qituvchi 4.1",
              "item name": "student",
              "items": [
                { "name": "O'quvchi 4.1.1", "item name": "book", "items": [ {"name": "Kitob D", "item name": "info", "items": []} ] }
              ]
            }
          ]
        }
      ]
    },
    {
      "name": "5-maktab",
      "item name": "sinf",
      "items": [
        {
          "name": "5-A sinf",
          "item name": "teacher",
          "items": [
            {
              "name": "O'qituvchi 5.1",
              "item name": "student",
              "items": [
                { "name": "O'quvchi 5.1.1", "item name": "book", "items": [ {"name": "Kitob E", "item name": "info", "items": []} ] }
              ]
            }
          ]
        }
      ]
    }
  ]
};


class SchoolResponse {
  List<SchoolItemModel>? data;

  SchoolResponse({this.data});

  SchoolResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SchoolItemModel>[];
      json['data'].forEach((v) {
        data!.add(SchoolItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> res = <String, dynamic>{};
    if (data != null) {
      res['data'] = data!.map((v) => v.toJson()).toList();
    }
    return res;
  }
}

class SchoolItemModel {
  String? name;
  String? itemName;
  List<SchoolItemModel>? items;

  SchoolItemModel({this.name, this.itemName, this.items});

  SchoolItemModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    itemName = json['item name'];
    if (json['items'] != null) {
      items = <SchoolItemModel>[];
      json['items'].forEach((v) {
        items!.add(SchoolItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> res = <String, dynamic>{};
    res['name'] = name;
    res['item name'] = itemName;
    if (items != null) {
      res['items'] = items!.map((v) => v.toJson()).toList();
    }
    return res;
  }
}