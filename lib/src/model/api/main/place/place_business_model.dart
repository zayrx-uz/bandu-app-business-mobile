class PlaceBusinessModel {
  Data data;

  PlaceBusinessModel({required this.data});

  factory PlaceBusinessModel.fromJson(Map<String, dynamic> json) =>
      PlaceBusinessModel(
        data: json["data"] == null
            ? Data.fromJson({})
            : Data.fromJson(json["data"]),
      );
}

class Data {
  List<PlaceBusinessItemData> data;
  String message;

  Data({required this.data, required this.message});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    data: json["data"] == null
        ? List<PlaceBusinessItemData>.from({})
        : List<PlaceBusinessItemData>.from(json["data"].map((x) => PlaceBusinessItemData.fromJson(x))),
    message: json["message"] ?? "",
  );
}

class PlaceBusinessItemData {
  int id;
  String name;
  int capacity;
  dynamic visualMetadata;
  dynamic positionX;
  dynamic positionY;
  Booking? booking;
  dynamic placeCategory;

  PlaceBusinessItemData({
    required this.id,
    required this.name,
    required this.capacity,
    required this.visualMetadata,
    required this.positionX,
    required this.positionY,
    required this.booking,
    required this.placeCategory,
  });

  factory PlaceBusinessItemData.fromJson(Map<String, dynamic> json) => PlaceBusinessItemData(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    capacity: json["capacity"] ?? 0,
    visualMetadata: json["visualMetadata"],
    positionX: json["positionX"],
    positionY: json["positionY"],
    booking: json["booking"] == null
        ? Booking.fromJson({})
        : Booking.fromJson(json["booking"]),
    placeCategory: json["placeCategory"],
  );
}

class Booking {
  int id;
  int numbersOfPeople;
  int totalPrice;
  String status;
  DateTime? bookingTime;
  dynamic bookingEndTime;
  dynamic note;
  dynamic ownerNote;
  String qrCode;

  Booking({
    required this.id,
    required this.numbersOfPeople,
    required this.totalPrice,
    required this.status,
    required this.bookingTime,
    required this.bookingEndTime,
    required this.note,
    required this.ownerNote,
    required this.qrCode,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json["id"] ?? 0,
    numbersOfPeople: json["numbersOfPeople"] ?? 0,
    totalPrice: json["totalPrice"] ?? 0,
    status: json["status"] ?? "",
    bookingTime: json["bookingTime"] == null
        ? null
        : DateTime.parse(json["bookingTime"]),
    bookingEndTime: json["bookingEndTime"],
    note: json["note"],
    ownerNote: json["ownerNote"],
    qrCode: json["qrCode"] ?? "",
  );
}
