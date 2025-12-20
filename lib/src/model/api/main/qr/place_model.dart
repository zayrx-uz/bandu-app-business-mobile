class QrPlaceModel {
  Data data;

  QrPlaceModel({required this.data});

  factory QrPlaceModel.fromJson(Map<String, dynamic> json) => QrPlaceModel(
    data: json["data"] == null
        ? Data.fromJson({})
        : Data.fromJson(json["data"]),
  );
}

class Data {
  Place place;
  Company company;
  bool isBooked;
  bool booking;

  Data({
    required this.place,
    required this.company,
    required this.isBooked,
    required this.booking,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    place: json["place"] == null
        ? Place.fromJson({})
        : Place.fromJson(json["place"]),
    company: json["company"] == null
        ? Company.fromJson({})
        : Company.fromJson(json["company"]),
    isBooked: json["isBooked"] ?? false,
    booking: json["booking"] ?? false,
  );
}

class Company {
  int id;
  String name;

  Company({required this.id, required this.name});

  factory Company.fromJson(Map<String, dynamic> json) =>
      Company(id: json["id"] ?? 0, name: json["name"] ?? "");
}

class Place {
  int id;
  String name;
  int capacity;
  String category;

  Place({
    required this.id,
    required this.name,
    required this.capacity,
    required this.category,
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    capacity: json["capacity"] ?? 0,
    category: json["category"] ?? "",
  );
}
