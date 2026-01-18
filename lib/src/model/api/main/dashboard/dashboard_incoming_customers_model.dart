class DashboardIncomingCustomersModel {
  List<DashboardIncomingCustomerItem> data;
  DashboardMeta meta;
  String message;

  DashboardIncomingCustomersModel({
    required this.data,
    required this.meta,
    required this.message,
  });

  factory DashboardIncomingCustomersModel.fromJson(
          Map<String, dynamic> json) =>
      DashboardIncomingCustomersModel(
        data: json["data"] == null
            ? []
            : List<DashboardIncomingCustomerItem>.from(json["data"]
                .map((x) => DashboardIncomingCustomerItem.fromJson(x))),
        meta: json["meta"] == null
            ? DashboardMeta.fromJson({})
            : DashboardMeta.fromJson(json["meta"]),
        message: json["message"] ?? "",
      );
}

class DashboardIncomingCustomerItem {
  int bookingId;
  DateTime? bookingTime;
  DateTime? bookingEndTime;
  DashboardIncomingCustomerUser user;
  List<DashboardPlace> places;

  DashboardIncomingCustomerItem({
    required this.bookingId,
    this.bookingTime,
    this.bookingEndTime,
    required this.user,
    required this.places,
  });

  factory DashboardIncomingCustomerItem.fromJson(Map<String, dynamic> json) =>
      DashboardIncomingCustomerItem(
        bookingId: json["bookingId"] ?? 0,
        bookingTime: json["bookingTime"] == null
            ? null
            : DateTime.tryParse(json["bookingTime"]),
        bookingEndTime: json["bookingEndTime"] == null
            ? null
            : DateTime.tryParse(json["bookingEndTime"]),
        user: json["user"] == null
            ? DashboardIncomingCustomerUser.fromJson({})
            : DashboardIncomingCustomerUser.fromJson(json["user"]),
        places: json["places"] == null
            ? []
            : List<DashboardPlace>.from(
                json["places"].map((x) => DashboardPlace.fromJson(x))),
      );
}

class DashboardIncomingCustomerUser {
  int id;
  String? fullName;
  String? profilePicture;
  String? phoneNumber;

  DashboardIncomingCustomerUser({
    required this.id,
    this.fullName,
    this.profilePicture,
    this.phoneNumber,
  });

  factory DashboardIncomingCustomerUser.fromJson(Map<String, dynamic> json) =>
      DashboardIncomingCustomerUser(
        id: json["id"] ?? 0,
        fullName: json["fullName"],
        profilePicture: json["profilePicture"],
        phoneNumber: json["phoneNumber"],
      );
}

class DashboardPlace {
  int id;
  String name;

  DashboardPlace({
    required this.id,
    required this.name,
  });

  factory DashboardPlace.fromJson(Map<String, dynamic> json) =>
      DashboardPlace(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
      );
}

class DashboardMeta {
  int total;
  int page;
  int limit;
  int totalPages;

  DashboardMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory DashboardMeta.fromJson(Map<String, dynamic> json) => DashboardMeta(
        total: json["total"] ?? 0,
        page: json["page"] ?? 1,
        limit: json["limit"] ?? 10,
        totalPages: json["totalPages"] ?? 0,
      );
}
