class MonitoringModel {
  MonitoringData data;

  MonitoringModel({required this.data});

  factory MonitoringModel.fromJson(Map<String, dynamic> json) =>
      MonitoringModel(
        data: json["data"] == null
            ? MonitoringData.fromJson({})
            : MonitoringData.fromJson(json["data"]),
      );
}

class MonitoringData {
  List<MonitoringItemData> data;
  String message;

  MonitoringData({required this.data, required this.message});

  factory MonitoringData.fromJson(Map<String, dynamic> json) => MonitoringData(
    data: json["data"] == null
        ? List<MonitoringItemData>.from({})
        : List<MonitoringItemData>.from(json["data"].map((x) => MonitoringItemData.fromJson(x))),
    message: json["message"] ?? "",
  );
}

class MonitoringItemData {
  int id;
  int numbersOfPeople;
  int totalPrice;
  String status;
  DateTime? bookingTime;
  DateTime? bookingEndTime;
  String note;
  String ownerNote;
  String qrCode;
  List<BookingItem> bookingItems;
  List<Place> places;
  Company company;

  MonitoringItemData({
    required this.id,
    required this.numbersOfPeople,
    required this.totalPrice,
    required this.status,
    required this.bookingTime,
    required this.bookingEndTime,
    required this.note,
    required this.ownerNote,
    required this.qrCode,
    required this.bookingItems,
    required this.places,
    required this.company,
  });

  factory MonitoringItemData.fromJson(Map<String, dynamic> json) => MonitoringItemData(
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
    ownerNote: json["ownerNote"] ?? "",
    qrCode: json["qrCode"] ?? "",
    bookingItems: json["bookingItems"] == null
        ? List<BookingItem>.from({})
        : List<BookingItem>.from(
            json["bookingItems"].map((x) => BookingItem.fromJson(x)),
          ),
    places: json["places"] == null
        ? List<Place>.from({})
        : List<Place>.from(json["places"].map((x) => Place.fromJson(x))),
    company: json["company"] == null
        ? Company.fromJson({})
        : Company.fromJson(json["company"]),
  );
}

class BookingItem {
  int id;
  int quantity;
  String status;
  String ownerNote;
  Resource resource;

  BookingItem({
    required this.id,
    required this.quantity,
    required this.status,
    required this.ownerNote,
    required this.resource,
  });

  factory BookingItem.fromJson(Map<String, dynamic> json) => BookingItem(
    id: json["id"] ?? 0,
    quantity: json["quantity"] ?? 0,
    status: json["status"] ?? "",
    ownerNote: json["ownerNote"] ?? "",
    resource: json["resource"] == null
        ? Resource.fromJson({})
        : Resource.fromJson(json["resource"]),
  );
}

class Resource {
  int id;
  String name;
  int price;
  String metadata;
  bool isBookable;
  bool isTimeSlotBased;
  int timeSlotDurationMinutes;

  Resource({
    required this.id,
    required this.name,
    required this.price,
    required this.metadata,
    required this.isBookable,
    required this.isTimeSlotBased,
    required this.timeSlotDurationMinutes,
  });

  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    price: json["price"] ?? 0,
    metadata: json["metadata"] ?? "",
    isBookable: json["isBookable"] ?? false,
    isTimeSlotBased: json["isTimeSlotBased"] ?? false,
    timeSlotDurationMinutes: json["timeSlotDurationMinutes"] ?? 0,
  );
}

class Company {
  int id;
  String name;
  bool isOpen247;
  String logo;
  double rating;
  WorkingHours workingHours;

  Company({
    required this.id,
    required this.name,
    required this.isOpen247,
    required this.logo,
    required this.rating,
    required this.workingHours,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    isOpen247: json["isOpen247"] ?? false,
    logo: json["logo"] ?? "",
    rating: json["rating"] ?? 0,
    workingHours: json["workingHours"] == null
        ? WorkingHours.fromJson({})
        : WorkingHours.fromJson(json["workingHours"]),
  );
}

class WorkingHours {
  Day monday;
  Day tuesday;
  Day wednesday;
  Day thursday;
  Day friday;
  Day saturday;
  Day sunday;

  WorkingHours({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  factory WorkingHours.fromJson(Map<String, dynamic> json) => WorkingHours(
    monday: json["monday"] == null
        ? Day.fromJson({})
        : Day.fromJson(json["monday"]),
    tuesday: json["tuesday"] == null
        ? Day.fromJson({})
        : Day.fromJson(json["tuesday"]),
    wednesday: json["wednesday"] == null
        ? Day.fromJson({})
        : Day.fromJson(json["wednesday"]),
    thursday: json["thursday"] == null
        ? Day.fromJson({})
        : Day.fromJson(json["thursday"]),
    friday: json["friday"] == null
        ? Day.fromJson({})
        : Day.fromJson(json["friday"]),
    saturday: json["saturday"] == null
        ? Day.fromJson({})
        : Day.fromJson(json["saturday"]),
    sunday: json["sunday"] == null
        ? Day.fromJson({})
        : Day.fromJson(json["sunday"]),
  );
}

class Day {
  String open;
  String close;
  bool closed;

  Day({required this.open, required this.close, required this.closed});

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    open: json["open"] ?? "",
    close: json["close"] ?? "",
    closed: json["closed"] ?? false,
  );
}

class Place {
  int id;
  String name;
  int capacity;
  String visualMetadata;
  int positionX;
  int positionY;
  bool isActive;

  Place({
    required this.id,
    required this.name,
    required this.capacity,
    required this.visualMetadata,
    required this.positionX,
    required this.positionY,
    required this.isActive,
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    capacity: json["capacity"] ?? 0,
    visualMetadata: json["visualMetadata"] ?? "",
    positionX: json["positionX"] ?? 0,
    positionY: json["positionY"] ?? 0,
    isActive: json["isActive"] ?? false,
  );
}
