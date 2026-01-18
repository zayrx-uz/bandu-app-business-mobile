class DashboardSummaryModel {
  DashboardSummaryData data;
  String message;

  DashboardSummaryModel({
    required this.data,
    required this.message,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) =>
      DashboardSummaryModel(
        data: json["data"] == null
            ? DashboardSummaryData.fromJson({})
            : DashboardSummaryData.fromJson(json["data"]),
        message: json["message"] ?? "",
      );
}

class DashboardSummaryData {
  int companyId;
  String date;
  DailyIncome dailyIncome;
  IncomingCustomers incomingCustomers;
  Places places;

  DashboardSummaryData({
    required this.companyId,
    required this.date,
    required this.dailyIncome,
    required this.incomingCustomers,
    required this.places,
  });

  factory DashboardSummaryData.fromJson(Map<String, dynamic> json) =>
      DashboardSummaryData(
        companyId: json["companyId"] ?? 0,
        date: json["date"] ?? "",
        dailyIncome: json["dailyIncome"] == null
            ? DailyIncome.fromJson({})
            : DailyIncome.fromJson(json["dailyIncome"]),
        incomingCustomers: json["incomingCustomers"] == null
            ? IncomingCustomers.fromJson({})
            : IncomingCustomers.fromJson(json["incomingCustomers"]),
        places: json["places"] == null
            ? Places.fromJson({})
            : Places.fromJson(json["places"]),
      );
}

class DailyIncome {
  double amount;
  double changePercent;

  DailyIncome({
    required this.amount,
    required this.changePercent,
  });

  factory DailyIncome.fromJson(Map<String, dynamic> json) => DailyIncome(
        amount: (json["amount"] ?? 0).toDouble(),
        changePercent: (json["changePercent"] ?? 0).toDouble(),
      );
}

class IncomingCustomers {
  int count;
  double changePercent;

  IncomingCustomers({
    required this.count,
    required this.changePercent,
  });

  factory IncomingCustomers.fromJson(Map<String, dynamic> json) =>
      IncomingCustomers(
        count: json["count"] ?? 0,
        changePercent: (json["changePercent"] ?? 0).toDouble(),
      );
}

class Places {
  int bookedNowCount;
  int emptyNowCount;

  Places({
    required this.bookedNowCount,
    required this.emptyNowCount,
  });

  factory Places.fromJson(Map<String, dynamic> json) => Places(
        bookedNowCount: json["bookedNowCount"] ?? 0,
        emptyNowCount: json["emptyNowCount"] ?? 0,
      );
}
