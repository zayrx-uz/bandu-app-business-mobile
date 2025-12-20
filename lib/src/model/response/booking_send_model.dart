import 'dart:convert';

String bookingSendModelToJson(BookingSendModel data) =>
    json.encode(data.toJson());

class BookingSendModel {
  int? companyId;
  int? numbersOfPeople;
  List<int> placeIds;
  DateTime? bookingDate;
  List<BookItemModel> items;

  BookingSendModel({
    this.companyId,
    this.numbersOfPeople,
    required this.placeIds,
    this.bookingDate,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
    "companyId": companyId,
    "numbersOfPeople": 1,
    "placeIds": List<dynamic>.from(placeIds.map((x) => x)),
    "bookingDate":
        "${bookingDate!.year.toString().padLeft(4, '0')}-${bookingDate!.month.toString().padLeft(2, '0')}-${bookingDate!.day.toString().padLeft(2, '0')}",
    "startTime": "${bookingDate!.hour}:${bookingDate!.minute}",
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class BookItemModel {
  int resourceId;
  int quantity;

  BookItemModel({required this.resourceId, required this.quantity});

  Map<String, dynamic> toJson() => {
    "resourceId": resourceId,
    "quantity": quantity,
  };
}
