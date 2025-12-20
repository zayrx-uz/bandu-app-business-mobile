class CategoryModel {
  CategoryDataList data;

  CategoryModel({required this.data});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    data: json["data"] == null
        ? CategoryDataList.fromJson({})
        : CategoryDataList.fromJson(json["data"]),
  );
}

class CategoryDataList {
  List<CategoryData> data;
  String message;

  CategoryDataList({required this.data, required this.message});

  factory CategoryDataList.fromJson(Map<String, dynamic> json) =>
      CategoryDataList(
        data: json["data"] == null
            ? List<CategoryData>.from({})
            : List<CategoryData>.from(
                json["data"].map((x) => CategoryData.fromJson(x)),
              ),
        message: json["message"] ?? "",
      );
}

class CategoryData {
  int id;
  String name;
  String description;

  CategoryData({
    required this.id,
    required this.name,
    required this.description,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
    id: json["id"] ?? "",
    name: json["name"] ?? "",
    description: json["description"] ?? "",
  );
}
