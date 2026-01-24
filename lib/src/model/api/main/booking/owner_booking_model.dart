class OwnerBookingModel {
  List<OwnerBookingItemData> data;
  OwnerBookingMeta meta;
  String message;

  OwnerBookingModel({
    required this.data,
    required this.meta,
    required this.message,
  });

  factory OwnerBookingModel.fromJson(Map<String, dynamic> json) =>
      OwnerBookingModel(
        data: json["data"] == null || json["data"] is! List
            ? []
            : List<OwnerBookingItemData>.from(
                json["data"].map((x) => OwnerBookingItemData.fromJson(x))),
        meta: json["meta"] == null
            ? OwnerBookingMeta.empty()
            : OwnerBookingMeta.fromJson(json["meta"]),
        message: json["message"] ?? "",
      );
}

class OwnerBookingItemData {
  int id;
  int numbersOfPeople;
  int totalPrice;
  String status;
  DateTime? bookingTime;
  DateTime? bookingEndTime;
  String note;
  String? ownerNote;
  String qrToken;
  String? cancelledBy;
  String? cancelReason;
  DateTime? cancelledAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<OwnerBookingItem> bookingItems;
  List<OwnerPlace> places;
  OwnerBookingUser user;
  OwnerBookingCompany company;

  OwnerBookingItemData({
    required this.id,
    required this.numbersOfPeople,
    required this.totalPrice,
    required this.status,
    required this.bookingTime,
    required this.bookingEndTime,
    required this.note,
    this.ownerNote,
    required this.qrToken,
    this.cancelledBy,
    this.cancelReason,
    this.cancelledAt,
    this.createdAt,
    this.updatedAt,
    required this.bookingItems,
    required this.places,
    required this.user,
    required this.company,
  });

  factory OwnerBookingItemData.fromJson(Map<String, dynamic> json) =>
      OwnerBookingItemData(
        id: json["id"] ?? 0,
        numbersOfPeople: json["numbersOfPeople"] ?? 0,
        totalPrice: json["totalPrice"] ?? 0,
        status: json["status"] ?? "",
        bookingTime: json["bookingTime"] == null
            ? null
            : DateTime.parse(json["bookingTime"]),
        bookingEndTime: json["bookingEndTime"] == null
            ? null
            : DateTime.parse(json["bookingEndTime"]),
        note: json["note"] ?? "",
        ownerNote: json["ownerNote"],
        qrToken: json["qrToken"] ?? "",
        cancelledBy: json["cancelledBy"],
        cancelReason: json["cancelReason"],
        cancelledAt: json["cancelledAt"] == null
            ? null
            : DateTime.parse(json["cancelledAt"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        bookingItems: json["bookingItems"] == null
            ? []
            : List<OwnerBookingItem>.from(
                json["bookingItems"].map((x) => OwnerBookingItem.fromJson(x))),
        places: json["places"] == null
            ? []
            : List<OwnerPlace>.from(
                json["places"].map((x) => OwnerPlace.fromJson(x))),
        user: json["user"] == null
            ? OwnerBookingUser.empty()
            : OwnerBookingUser.fromJson(json["user"]),
        company: json["company"] == null
            ? OwnerBookingCompany.empty()
            : OwnerBookingCompany.fromJson(json["company"]),
      );
}

class OwnerBookingItem {
  int id;
  int quantity;
  String status;
  String? ownerNote;
  String? cancelledBy;
  String? cancelReason;
  DateTime? cancelledAt;
  OwnerBookingResource resource;

  OwnerBookingItem({
    required this.id,
    required this.quantity,
    required this.status,
    this.ownerNote,
    this.cancelledBy,
    this.cancelReason,
    this.cancelledAt,
    required this.resource,
  });

  factory OwnerBookingItem.fromJson(Map<String, dynamic> json) =>
      OwnerBookingItem(
        id: json["id"] ?? 0,
        quantity: json["quantity"] ?? 0,
        status: json["status"] ?? "",
        ownerNote: json["ownerNote"],
        cancelledBy: json["cancelledBy"],
        cancelReason: json["cancelReason"],
        cancelledAt: json["cancelledAt"] == null
            ? null
            : DateTime.parse(json["cancelledAt"]),
        resource: json["resource"] == null
            ? OwnerBookingResource.empty()
            : OwnerBookingResource.fromJson(json["resource"]),
      );
}

class OwnerBookingResource {
  int id;
  String name;
  int price;
  dynamic metadata;
  bool isBookable;
  bool isTimeSlotBased;
  int timeSlotDurationMinutes;

  OwnerBookingResource({
    required this.id,
    required this.name,
    required this.price,
    this.metadata,
    required this.isBookable,
    required this.isTimeSlotBased,
    required this.timeSlotDurationMinutes,
  });

  factory OwnerBookingResource.fromJson(Map<String, dynamic> json) =>
      OwnerBookingResource(
        id: json["id"] ?? 0,
        name: json["name"]?.toString() ?? "",
        price: json["price"] ?? 0,
        metadata: json["metadata"],
        isBookable: json["isBookable"] ?? false,
        isTimeSlotBased: json["isTimeSlotBased"] ?? false,
        timeSlotDurationMinutes: json["timeSlotDurationMinutes"] ?? 0,
      );

  factory OwnerBookingResource.empty() => OwnerBookingResource(
        id: 0,
        name: "",
        price: 0,
        metadata: null,
        isBookable: false,
        isTimeSlotBased: false,
        timeSlotDurationMinutes: 0,
      );
}

class OwnerPlace {
  int id;
  String name;
  int capacity;
  dynamic visualMetadata;
  int positionX;
  int positionY;
  bool isActive;

  OwnerPlace({
    required this.id,
    required this.name,
    required this.capacity,
    this.visualMetadata,
    required this.positionX,
    required this.positionY,
    this.isActive = true,
  });

  factory OwnerPlace.fromJson(Map<String, dynamic> json) => OwnerPlace(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        capacity: json["capacity"] ?? 0,
        visualMetadata: json["visualMetadata"],
        positionX: json["positionX"] ?? 0,
        positionY: json["positionY"] ?? 0,
        isActive: json["isActive"] ?? true,
      );
}

class OwnerBookingUser {
  int id;
  String? email;
  String fullName;
  String? firstName;
  String? lastName;
  String? profilePicture;
  DateTime? birthDate;
  String? gender;
  bool verified;
  bool isBlocked;
  List<String> roles;
  int? companyId;
  String fcmToken;
  String? telegramId;
  DateTime? createdAt;
  DateTime? updatedAt;

  OwnerBookingUser({
    required this.id,
    this.email,
    required this.fullName,
    this.firstName,
    this.lastName,
    this.profilePicture,
    this.birthDate,
    this.gender,
    required this.verified,
    required this.isBlocked,
    required this.roles,
    this.companyId,
    required this.fcmToken,
    this.telegramId,
    this.createdAt,
    this.updatedAt,
  });

  factory OwnerBookingUser.fromJson(Map<String, dynamic> json) =>
      OwnerBookingUser(
        id: json["id"] ?? 0,
        email: json["email"],
        fullName: json["fullName"] ?? "",
        firstName: json["firstName"],
        lastName: json["lastName"],
        profilePicture: json["profilePicture"],
        birthDate: json["birthDate"] == null
            ? null
            : DateTime.tryParse(json["birthDate"]),
        gender: json["gender"],
        verified: json["verified"] ?? false,
        isBlocked: json["isBlocked"] ?? false,
        roles: json["roles"] == null || json["roles"] is! List
            ? []
            : List<String>.from(json["roles"].map((x) => x.toString())),
        companyId: json["companyId"],
        fcmToken: json["fcmToken"] ?? "",
        telegramId: json["telegramId"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.tryParse(json["updatedAt"]),
      );

  factory OwnerBookingUser.empty() => OwnerBookingUser(
        id: 0,
        email: null,
        fullName: "",
        firstName: null,
        lastName: null,
        profilePicture: null,
        birthDate: null,
        gender: null,
        verified: false,
        isBlocked: false,
        roles: [],
        companyId: null,
        fcmToken: "",
        telegramId: null,
        createdAt: null,
        updatedAt: null,
      );
}

class OwnerBookingCompany {
  int id;
  String name;
  bool isOpen247;
  String? logo;
  double? rating;
  Map<String, dynamic> workingHours;

  OwnerBookingCompany({
    required this.id,
    required this.name,
    required this.isOpen247,
    this.logo,
    this.rating,
    required this.workingHours,
  });

  factory OwnerBookingCompany.fromJson(Map<String, dynamic> json) =>
      OwnerBookingCompany(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        isOpen247: json["isOpen247"] ?? false,
        logo: json["logo"],
        rating: json["rating"]?.toDouble(),
        workingHours: json["workingHours"] ?? {},
      );

  factory OwnerBookingCompany.empty() => OwnerBookingCompany(
        id: 0,
        name: "",
        isOpen247: false,
        logo: null,
        rating: null,
        workingHours: {},
      );
}

class OwnerBookingMeta {
  int total;
  int page;
  int limit;
  int totalPages;

  OwnerBookingMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory OwnerBookingMeta.fromJson(Map<String, dynamic> json) =>
      OwnerBookingMeta(
        total: json["total"] ?? 0,
        page: json["page"] ?? 1,
        limit: json["limit"] ?? 10,
        totalPages: json["totalPages"] ?? 1,
      );

  factory OwnerBookingMeta.empty() => OwnerBookingMeta(
        total: 0,
        page: 1,
        limit: 10,
        totalPages: 1,
      );
}
