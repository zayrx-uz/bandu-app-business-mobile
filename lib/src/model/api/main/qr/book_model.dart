class BookModel {
  final BookModelData data;

  BookModel({required this.data});

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      BookModel(
        data: json["data"] == null
            ? BookModelData.fromJson({})
            : BookModelData.fromJson(json["data"]),
      );
}

class BookModelData {
  final BookingData data;
  final String message;

  BookModelData({required this.data, required this.message});

  factory BookModelData.fromJson(Map<String, dynamic> json) =>
      BookModelData(
        data: json["data"] == null
            ? BookingData.fromJson({})
            : BookingData.fromJson(json["data"]),
        message: json["message"] ?? "",
      );
}

class BookingData {
  final int id;
  final DateTime? bookingTime;
  final DateTime? bookingEndTime;
  final int totalPrice;
  final int numbersOfPeople;
  final String status;
  final dynamic note;
  final String qrCode;

  final User user;
  final Company company;

  final List<BookingItem> bookingItems;
  final List<Place> places;

  BookingData({
    required this.id,
    required this.bookingTime,
    required this.bookingEndTime,
    required this.totalPrice,
    required this.numbersOfPeople,
    required this.status,
    required this.note,
    required this.qrCode,
    required this.user,
    required this.company,
    required this.bookingItems,
    required this.places,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) => BookingData(
    id: json["id"] ?? 0,
    bookingTime: json["bookingTime"] == null
        ? null
        : DateTime.tryParse(json["bookingTime"]),
    bookingEndTime: json["bookingEndTime"] == null
        ? null
        : DateTime.tryParse(json["bookingEndTime"]),
    totalPrice: json["totalPrice"] ?? 0,
    numbersOfPeople: json["numbersOfPeople"] ?? 0,
    status: json["status"] ?? "",
    note: json["note"],
    qrCode: json["qrCode"] ?? "",
    user: json["user"] == null
        ? User.fromJson({})
        : User.fromJson(json["user"]),
    company: json["company"] == null
        ? Company.fromJson({})
        : Company.fromJson(json["company"]),
    bookingItems: json["bookingItems"] == null
        ? []
        : List<BookingItem>.from(
      json["bookingItems"].map(
            (x) => BookingItem.fromJson(x),
      ),
    ),
    places: json["places"] == null
        ? []
        : List<Place>.from(
      json["places"].map(
            (x) => Place.fromJson(x),
      ),
    ),
  );
}

class BookingItem {
  final int id;
  final int quantity;
  final String status;
  final Resource resource;

  BookingItem({
    required this.id,
    required this.quantity,
    required this.status,
    required this.resource,
  });

  factory BookingItem.fromJson(Map<String, dynamic> json) => BookingItem(
    id: json["id"] ?? 0,
    quantity: json["quantity"] ?? 0,
    status: json["status"] ?? "",
    resource: json["resource"] == null
        ? Resource.fromJson({})
        : Resource.fromJson(json["resource"]),
  );
}

class Resource {
  final int id;
  final String name;
  final int price;

  Resource({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    price: json["price"] ?? 0,
  );
}

class Company {
  final int id;
  final String name;
  final String logo;
  final dynamic rating;
  final String address;

  Company({
    required this.id,
    required this.name,
    required this.logo,
    required this.rating,
    required this.address,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    logo: json["logo"] ?? "",
    rating: json["rating"],
    address: json["address"] ?? "",
  );
}

class Place {
  final int id;
  final String name;

  Place({
    required this.id,
    required this.name,
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
  );
}

class User {
  final int id;
  final dynamic firstName;
  final dynamic lastName;
  final dynamic email;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] ?? 0,
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
  );
}
