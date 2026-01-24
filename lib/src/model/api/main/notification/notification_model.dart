class NotificationModel {
  List<NotificationItemData> data;
  NotificationMeta meta;
  String message;

  NotificationModel({
    required this.data,
    required this.meta,
    required this.message,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        data: json["data"] == null || json["data"] is! List
            ? []
            : List<NotificationItemData>.from(
                json["data"].map((x) => NotificationItemData.fromJson(x))),
        meta: json["meta"] == null
            ? NotificationMeta.empty()
            : NotificationMeta.fromJson(json["meta"]),
        message: json["message"] ?? "",
      );
}

class NotificationItemData {
  int id;
  int userId;
  String title;
  String description;
  String type;
  dynamic data;
  int? bookingId;
  DateTime? sentAt;
  DateTime? readAt;

  NotificationItemData({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.type,
    this.data,
    this.bookingId,
    this.sentAt,
    this.readAt,
  });

  bool get isRead => readAt != null;

  factory NotificationItemData.fromJson(Map<String, dynamic> json) =>
      NotificationItemData(
        id: json["id"] ?? 0,
        userId: json["userId"] ?? 0,
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        type: json["type"] ?? "",
        data: json["data"],
        bookingId: json["bookingId"],
        sentAt: json["sentAt"] == null
            ? null
            : DateTime.parse(json["sentAt"]),
        readAt: json["readAt"] == null
            ? null
            : DateTime.parse(json["readAt"]),
      );
}

class NotificationMeta {
  int total;
  int page;
  int limit;
  int totalPages;

  NotificationMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory NotificationMeta.fromJson(Map<String, dynamic> json) =>
      NotificationMeta(
        total: json["total"] ?? 0,
        page: json["page"] ?? 1,
        limit: json["limit"] ?? 10,
        totalPages: json["totalPages"] ?? 1,
      );

  factory NotificationMeta.empty() => NotificationMeta(
        total: 0,
        page: 1,
        limit: 10,
        totalPages: 1,
      );
}
