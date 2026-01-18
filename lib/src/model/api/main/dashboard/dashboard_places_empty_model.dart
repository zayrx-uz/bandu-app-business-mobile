class DashboardPlacesEmptyModel {
  DashboardPlacesEmptyData data;
  String message;

  DashboardPlacesEmptyModel({
    required this.data,
    required this.message,
  });

  factory DashboardPlacesEmptyModel.fromJson(Map<String, dynamic> json) =>
      DashboardPlacesEmptyModel(
        data: json["data"] == null
            ? DashboardPlacesEmptyData.fromJson({})
            : DashboardPlacesEmptyData.fromJson(json["data"]),
        message: json["message"] ?? "",
      );
}

class DashboardPlacesEmptyData {
  int companyId;
  List<DashboardPlacesEmptyGroup> groups;

  DashboardPlacesEmptyData({
    required this.companyId,
    required this.groups,
  });

  factory DashboardPlacesEmptyData.fromJson(Map<String, dynamic> json) =>
      DashboardPlacesEmptyData(
        companyId: json["companyId"] ?? 0,
        groups: json["groups"] == null
            ? []
            : List<DashboardPlacesEmptyGroup>.from(json["groups"]
                .map((x) => DashboardPlacesEmptyGroup.fromJson(x))),
      );
}

class DashboardPlacesEmptyGroup {
  String categoryName;
  List<DashboardEmptyPlace> places;

  DashboardPlacesEmptyGroup({
    required this.categoryName,
    required this.places,
  });

  factory DashboardPlacesEmptyGroup.fromJson(Map<String, dynamic> json) =>
      DashboardPlacesEmptyGroup(
        categoryName: json["categoryName"] ?? "Uncategorized",
        places: json["places"] == null
            ? []
            : List<DashboardEmptyPlace>.from(
                json["places"].map((x) => DashboardEmptyPlace.fromJson(x))),
      );
}

class DashboardEmptyPlace {
  int id;
  String name;

  DashboardEmptyPlace({
    required this.id,
    required this.name,
  });

  factory DashboardEmptyPlace.fromJson(Map<String, dynamic> json) =>
      DashboardEmptyPlace(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
      );
}
