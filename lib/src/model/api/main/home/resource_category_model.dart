class ResourceCategoryModel {
  Data data;

  ResourceCategoryModel({required this.data});

  factory ResourceCategoryModel.fromJson(Map<String, dynamic> json) =>
      ResourceCategoryModel(
        data: json["data"] == null
            ? Data.fromJson({})
            : Data.fromJson(json["data"]),
      );
}

class Data {
  List<ResourceCategoryData> data;

  Data({required this.data});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    data: json["data"] == null
        ? List<ResourceCategoryData>.from({})
        : List<ResourceCategoryData>.from(
            json["data"].map((x) => ResourceCategoryData.fromJson(x)),
          ),
  );
}

class ResourceCategoryData {
  int id;
  String name;

  ResourceCategoryData({required this.id, required this.name});

  factory ResourceCategoryData.fromJson(Map<String, dynamic> json) =>
      ResourceCategoryData(id: json["id"] ?? 0, name: json["name"] ?? "");
}
