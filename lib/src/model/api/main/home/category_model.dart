class CategoryModel {
  List<CategoryData> data;
  String message;

  CategoryModel({
    required this.data,
    required this.message,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    data: json["data"] == null
        ? []
        : List<CategoryData>.from(
            json["data"].map((x) => CategoryData.fromJson(x))),
    message: json["message"] ?? "",
  );
}

class CategoryDataList {
  List<CategoryData> data;
  String message;

  CategoryDataList({required this.data, required this.message});

  factory CategoryDataList.fromJson(Map<String, dynamic> json) =>
      CategoryDataList(
        data: json["data"] == null
            ? []
            : List<CategoryData>.from(
                json["data"].map((x) => CategoryData.fromJson(x))),
        message: json["message"] ?? "",
      );
}

class CategoryData {
  int id;
  String name;
  String description;
  String ikpuCode;

  CategoryData({
    required this.id,
    required this.name,
    required this.description,
    required this.ikpuCode,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    description: json["description"] ?? "",
    ikpuCode: json["ikpuCode"] ?? "",
  );
}
