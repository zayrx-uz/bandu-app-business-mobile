class BookingDetailModel {
  BookingDetailData data;
  String message;

  BookingDetailModel({
    required this.data,
    required this.message,
  });

  factory BookingDetailModel.fromJson(Map<String, dynamic> json) =>
      BookingDetailModel(
        data: json["data"] == null
            ? BookingDetailData.empty()
            : BookingDetailData.fromJson(json["data"]),
        message: json["message"] ?? "",
      );
}

class BookingDetailData {
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
  List<BookingDetailItem> bookingItems;
  List<dynamic> places;
  List<dynamic> feedbacks;
  List<BookingDetailPayment> payments;
  int? paymentId;
  BookingDetailUser user;
  BookingDetailCompany company;

  BookingDetailData({
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
    required this.createdAt,
    required this.updatedAt,
    required this.bookingItems,
    required this.places,
    required this.feedbacks,
    required this.payments,
    this.paymentId,
    required this.user,
    required this.company,
  });

  factory BookingDetailData.fromJson(Map<String, dynamic> json) =>
      BookingDetailData(
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
            : List<BookingDetailItem>.from(
                json["bookingItems"].map((x) => BookingDetailItem.fromJson(x))),
        places: json["places"] ?? [],
        feedbacks: json["feedbacks"] ?? [],
        payments: json["payments"] == null || json["payments"] is! List
            ? []
            : List<BookingDetailPayment>.from(
                json["payments"].map((x) => BookingDetailPayment.fromJson(x))),
        paymentId: json["paymentId"],
        user: json["user"] == null
            ? BookingDetailUser.empty()
            : BookingDetailUser.fromJson(json["user"]),
        company: json["company"] == null
            ? BookingDetailCompany.empty()
            : BookingDetailCompany.fromJson(json["company"]),
      );

  factory BookingDetailData.empty() => BookingDetailData(
        id: 0,
        numbersOfPeople: 0,
        totalPrice: 0,
        status: "",
        bookingTime: null,
        bookingEndTime: null,
        note: "",
        ownerNote: null,
        qrToken: "",
        cancelledBy: null,
        cancelReason: null,
        cancelledAt: null,
        createdAt: null,
        updatedAt: null,
        bookingItems: [],
        places: [],
        feedbacks: [],
        payments: [],
        paymentId: null,
        user: BookingDetailUser.empty(),
        company: BookingDetailCompany.empty(),
      );
}

class BookingDetailPayment {
  int id;
  String? providerTransactionId;
  String amount;
  String provider;
  int state;
  String status;
  String createTime;
  String performTime;
  String cancelTime;
  String? reason;
  String? cardMask;
  DateTime? createdAt;
  DateTime? updatedAt;

  BookingDetailPayment({
    required this.id,
    this.providerTransactionId,
    required this.amount,
    required this.provider,
    required this.state,
    required this.status,
    required this.createTime,
    required this.performTime,
    required this.cancelTime,
    this.reason,
    this.cardMask,
    this.createdAt,
    this.updatedAt,
  });

  factory BookingDetailPayment.fromJson(Map<String, dynamic> json) =>
      BookingDetailPayment(
        id: json["id"] ?? 0,
        providerTransactionId: json["providerTransactionId"],
        amount: json["amount"]?.toString() ?? "0",
        provider: json["provider"]?.toString() ?? "",
        state: json["state"] ?? 0,
        status: json["status"]?.toString() ?? "",
        createTime: json["createTime"]?.toString() ?? "0",
        performTime: json["performTime"]?.toString() ?? "0",
        cancelTime: json["cancelTime"]?.toString() ?? "0",
        reason: json["reason"],
        cardMask: json["cardMask"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"] ?? ""),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.tryParse(json["updatedAt"] ?? ""),
      );
}

class BookingDetailItem {
  int id;
  int quantity;
  String status;
  String? ownerNote;
  String? cancelledBy;
  String? cancelReason;
  DateTime? cancelledAt;
  BookingDetailResource resource;
  BookingDetailUser? employee;

  BookingDetailItem({
    required this.id,
    required this.quantity,
    required this.status,
    this.ownerNote,
    this.cancelledBy,
    this.cancelReason,
    this.cancelledAt,
    required this.resource,
    this.employee,
  });

  factory BookingDetailItem.fromJson(Map<String, dynamic> json) =>
      BookingDetailItem(
        id: json["id"] ?? 0,
        quantity: json["quantity"] ?? 0,
        status: json["status"] ?? "",
        ownerNote: json["ownerNote"],
        cancelledBy: json["cancelledBy"],
        cancelReason: json["cancelReason"],
        cancelledAt: json["cancelledAt"] == null
            ? null
            : DateTime.tryParse(json["cancelledAt"] ?? ""),
        resource: json["resource"] == null
            ? BookingDetailResource.empty()
            : BookingDetailResource.fromJson(json["resource"]),
        employee: json["employee"] == null
            ? null
            : BookingDetailUser.fromJson(json["employee"]),
      );
}

class BookingDetailResource {
  int id;
  String name;
  int price;
  dynamic metadata;
  bool isBookable;
  bool isTimeSlotBased;
  int? timeSlotDurationMinutes;

  BookingDetailResource({
    required this.id,
    required this.name,
    required this.price,
    this.metadata,
    required this.isBookable,
    required this.isTimeSlotBased,
    this.timeSlotDurationMinutes,
  });

  factory BookingDetailResource.fromJson(Map<String, dynamic> json) =>
      BookingDetailResource(
        id: json["id"] ?? 0,
        name: json["name"]?.toString() ?? "",
        price: json["price"] ?? 0,
        metadata: json["metadata"],
        isBookable: json["isBookable"] ?? false,
        isTimeSlotBased: json["isTimeSlotBased"] ?? false,
        timeSlotDurationMinutes: json["timeSlotDurationMinutes"],
      );

  factory BookingDetailResource.empty() => BookingDetailResource(
        id: 0,
        name: "",
        price: 0,
        metadata: null,
        isBookable: false,
        isTimeSlotBased: false,
        timeSlotDurationMinutes: null,
      );
}

class BookingDetailUser {
  int id;
  String? email;
  String fullName;
  String? firstName;
  String? lastName;
  String? profilePicture;
  DateTime? birthDate;
  String gender;
  bool verified;
  bool isBlocked;
  String role;
  int? companyId;
  String fcmToken;
  String? telegramId;
  DateTime? createdAt;
  DateTime? updatedAt;

  BookingDetailUser({
    required this.id,
    this.email,
    required this.fullName,
    this.firstName,
    this.lastName,
    this.profilePicture,
    this.birthDate,
    required this.gender,
    required this.verified,
    required this.isBlocked,
    required this.role,
    this.companyId,
    required this.fcmToken,
    this.telegramId,
    this.createdAt,
    this.updatedAt,
  });

  factory BookingDetailUser.fromJson(Map<String, dynamic> json) =>
      BookingDetailUser(
        id: json["id"] ?? 0,
        email: json["email"],
        fullName: json["fullName"] ?? "",
        firstName: json["firstName"],
        lastName: json["lastName"],
        profilePicture: json["profilePicture"],
        birthDate: json["birthDate"] == null
            ? null
            : DateTime.parse(json["birthDate"]),
        gender: json["gender"] ?? "",
        verified: json["verified"] ?? false,
        isBlocked: json["isBlocked"] ?? false,
        role: json["role"] ?? "",
        companyId: json["companyId"],
        fcmToken: json["fcmToken"] ?? "",
        telegramId: json["telegramId"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  factory BookingDetailUser.empty() => BookingDetailUser(
        id: 0,
        email: null,
        fullName: "",
        firstName: null,
        lastName: null,
        profilePicture: null,
        birthDate: null,
        gender: "",
        verified: false,
        isBlocked: false,
        role: "",
        companyId: null,
        fcmToken: "",
        telegramId: null,
        createdAt: null,
        updatedAt: null,
      );
}

class BookingDetailCompany {
  int id;
  String name;
  bool isOpen247;
  String? logo;
  double? rating;
  Map<String, dynamic> workingHours;
  List<BookingDetailCategory> categories;
  BookingDetailUser? owner;

  BookingDetailCompany({
    required this.id,
    required this.name,
    required this.isOpen247,
    this.logo,
    this.rating,
    required this.workingHours,
    required this.categories,
    this.owner,
  });

  factory BookingDetailCompany.fromJson(Map<String, dynamic> json) =>
      BookingDetailCompany(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        isOpen247: json["isOpen247"] ?? false,
        logo: json["logo"],
        rating: json["rating"]?.toDouble(),
        workingHours: json["workingHours"] ?? {},
        categories: json["categories"] == null
            ? []
            : List<BookingDetailCategory>.from(
                json["categories"].map((x) => BookingDetailCategory.fromJson(x))),
        owner: json["owner"] == null
            ? null
            : BookingDetailUser.fromJson(json["owner"]),
      );

  factory BookingDetailCompany.empty() => BookingDetailCompany(
        id: 0,
        name: "",
        isOpen247: false,
        logo: null,
        rating: null,
        workingHours: {},
        categories: [],
        owner: null,
      );
}

class BookingDetailCategory {
  int id;
  String name;
  String? description;
  BookingDetailServiceType? serviceType;
  dynamic metadata;

  BookingDetailCategory({
    required this.id,
    required this.name,
    this.description,
    this.serviceType,
    this.metadata,
  });

  String get ikpuCode => serviceType?.ikpuCode ?? "";

  factory BookingDetailCategory.fromJson(Map<String, dynamic> json) =>
      BookingDetailCategory(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        description: json["description"],
        serviceType: json["serviceType"] == null
            ? null
            : BookingDetailServiceType.fromJson(json["serviceType"]),
        metadata: json["metadata"],
      );
}

class BookingDetailServiceType {
  int id;
  String name;
  String ikpuCode;
  DateTime? createdAt;
  DateTime? updatedAt;

  BookingDetailServiceType({
    required this.id,
    required this.name,
    required this.ikpuCode,
    this.createdAt,
    this.updatedAt,
  });

  factory BookingDetailServiceType.fromJson(Map<String, dynamic> json) =>
      BookingDetailServiceType(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        ikpuCode: json["ikpuCode"] ?? "",
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"]) ?? DateTime.now(),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.tryParse(json["updatedAt"]) ?? DateTime.now(),
      );
}
