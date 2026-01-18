class DashboardPlacesBookedModel {
  DashboardPlacesBookedData data;
  String message;

  DashboardPlacesBookedModel({
    required this.data,
    required this.message,
  });

  factory DashboardPlacesBookedModel.fromJson(Map<String, dynamic> json) =>
      DashboardPlacesBookedModel(
        data: json["data"] == null
            ? DashboardPlacesBookedData.fromJson({})
            : DashboardPlacesBookedData.fromJson(json["data"]),
        message: json["message"] ?? "",
      );
}

class DashboardPlacesBookedData {
  int companyId;
  List<DashboardPlacesGroup> groups;

  DashboardPlacesBookedData({
    required this.companyId,
    required this.groups,
  });

  factory DashboardPlacesBookedData.fromJson(Map<String, dynamic> json) =>
      DashboardPlacesBookedData(
        companyId: json["companyId"] ?? 0,
        groups: json["groups"] == null
            ? []
            : List<DashboardPlacesGroup>.from(
                json["groups"].map((x) => DashboardPlacesGroup.fromJson(x))),
      );
}

class DashboardPlacesGroup {
  String categoryName;
  List<DashboardBookedPlace> places;

  DashboardPlacesGroup({
    required this.categoryName,
    required this.places,
  });

  factory DashboardPlacesGroup.fromJson(Map<String, dynamic> json) =>
      DashboardPlacesGroup(
        categoryName: json["categoryName"] ?? "Uncategorized",
        places: json["places"] == null
            ? []
            : List<DashboardBookedPlace>.from(
                json["places"].map((x) => DashboardBookedPlace.fromJson(x))),
      );
}

class DashboardBookedPlace {
  int id;
  String name;
  int? bookingId;
  DateTime? bookingTime;
  DateTime? bookingEndTime;

  DashboardBookedPlace({
    required this.id,
    required this.name,
    this.bookingId,
    this.bookingTime,
    this.bookingEndTime,
  });

  factory DashboardBookedPlace.fromJson(Map<String, dynamic> json) =>
      DashboardBookedPlace(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        bookingId: json["bookingId"],
        bookingTime: json["bookingTime"] == null
            ? null
            : DateTime.tryParse(json["bookingTime"]),
        bookingEndTime: json["bookingEndTime"] == null
            ? null
            : DateTime.tryParse(json["bookingEndTime"]),
      );
}
