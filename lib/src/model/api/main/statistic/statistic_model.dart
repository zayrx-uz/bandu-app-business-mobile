class StatisticModel {
  final StatisticModelData data;

  StatisticModel({required this.data});

  factory StatisticModel.fromJson(Map<String, dynamic> json) =>
      StatisticModel(
        data: json["data"] == null
            ? StatisticModelData.fromJson({})
            : StatisticModelData.fromJson(json["data"]),
      );
}

class StatisticModelData {
  final StatisticItemData data;
  final String message;

  StatisticModelData({
    required this.data,
    required this.message,
  });

  factory StatisticModelData.fromJson(Map<String, dynamic> json) =>
      StatisticModelData(
        data: json["data"] == null
            ? StatisticItemData.fromJson({})
            : StatisticItemData.fromJson(json["data"]),
        message: json["message"] ?? "",
      );
}

class StatisticItemData {
  final String period;
  final String year;
  final int totalRevenue;
  final int totalCustomers;
  final int totalPlaces;
  final List<NewCustomer> newCustomers;
  final int revenuePercentageChange;
  final int customersPercentageChange;
  final int placesPercentageChange;
  final List<MonthlyDatum> monthlyData;

  StatisticItemData({
    required this.period,
    required this.year,
    required this.totalRevenue,
    required this.totalCustomers,
    required this.totalPlaces,
    required this.newCustomers,
    required this.revenuePercentageChange,
    required this.customersPercentageChange,
    required this.placesPercentageChange,
    required this.monthlyData,
  });

  factory StatisticItemData.fromJson(Map<String, dynamic> json) => StatisticItemData(
    period: json["period"] ?? "",
    year: json["year"] ?? "",
    totalRevenue: json["totalRevenue"] ?? 0,
    totalCustomers: json["totalCustomers"] ?? 0,
    totalPlaces: json["totalPlaces"] ?? 0,
    newCustomers: json["newCustomers"] == null
        ? []
        : List<NewCustomer>.from(
      json["newCustomers"].map((x) => NewCustomer.fromJson(x)),
    ),
    revenuePercentageChange: json["revenuePercentageChange"] ?? 0,
    customersPercentageChange: json["customersPercentageChange"] ?? 0,
    placesPercentageChange: json["placesPercentageChange"] ?? 0,
    monthlyData: json["monthlyData"] == null
        ? []
        : List<MonthlyDatum>.from(
      json["monthlyData"].map((x) => MonthlyDatum.fromJson(x)),
    ),
  );
}

class MonthlyDatum {
  final int month;
  final String monthName;
  final String date;
  final int revenue;
  final int customers;

  MonthlyDatum({
    required this.month,
    required this.monthName,
    required this.date,
    required this.revenue,
    required this.customers,
  });

  factory MonthlyDatum.fromJson(Map<String, dynamic> json) => MonthlyDatum(
    month: json["month"] ?? 0,
    monthName: json["monthName"] ?? "",
    date: json["date"] ?? "",
    revenue: json["revenue"] ?? 0,
    customers: json["customers"] ?? 0,
  );
}

class NewCustomer {
  final int id;
  final dynamic email;
  final String fullName;
  final dynamic firstName;
  final dynamic lastName;
  final String profilePicture;
  final dynamic birthDate;
  final String gender;
  final bool verified;
  final bool isBlocked;
  final String role;
  final dynamic companyId;
  final dynamic fcmToken;
  final dynamic telegramId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;

  NewCustomer({
    required this.id,
    required this.email,
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
    required this.birthDate,
    required this.gender,
    required this.verified,
    required this.isBlocked,
    required this.role,
    required this.companyId,
    required this.fcmToken,
    required this.telegramId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory NewCustomer.fromJson(Map<String, dynamic> json) => NewCustomer(
    id: json["id"] ?? 0,
    email: json["email"],
    fullName: json["fullName"] ?? "",
    firstName: json["firstName"],
    lastName: json["lastName"],
    profilePicture: json["profilePicture"] ?? "",
    birthDate: json["birthDate"],
    gender: json["gender"] ?? "",
    verified: json["verified"] ?? false,
    isBlocked: json["isBlocked"] ?? false,
    role: json["role"] ?? "",
    companyId: json["companyId"],
    fcmToken: json["fcmToken"],
    telegramId: json["telegramId"],
    createdAt: json["createdAt"] == null
        ? DateTime.now()
        : DateTime.tryParse(json["createdAt"]) ?? DateTime.now(),
    updatedAt: json["updatedAt"] == null
        ? DateTime.now()
        : DateTime.tryParse(json["updatedAt"]) ?? DateTime.now(),
    deletedAt: json["deletedAt"],
  );
}
