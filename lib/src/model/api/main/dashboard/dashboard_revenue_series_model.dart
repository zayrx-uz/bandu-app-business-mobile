class DashboardRevenueSeriesModel {
  DashboardRevenueSeriesData data;
  String message;

  DashboardRevenueSeriesModel({
    required this.data,
    required this.message,
  });

  factory DashboardRevenueSeriesModel.fromJson(Map<String, dynamic> json) =>
      DashboardRevenueSeriesModel(
        data: json["data"] == null
            ? DashboardRevenueSeriesData.fromJson({})
            : DashboardRevenueSeriesData.fromJson(json["data"]),
        message: json["message"] ?? "",
      );
}

class DashboardRevenueSeriesData {
  int companyId;
  String period;
  Total total;
  String? lastUpdatedAt;
  List<SeriesItem> series;

  DashboardRevenueSeriesData({
    required this.companyId,
    required this.period,
    required this.total,
    this.lastUpdatedAt,
    required this.series,
  });

  factory DashboardRevenueSeriesData.fromJson(Map<String, dynamic> json) =>
      DashboardRevenueSeriesData(
        companyId: json["companyId"] ?? 0,
        period: json["period"] ?? "",
        total: json["total"] == null
            ? Total.fromJson({})
            : Total.fromJson(json["total"]),
        lastUpdatedAt: json["lastUpdatedAt"],
        series: json["series"] == null
            ? []
            : List<SeriesItem>.from(
                json["series"].map((x) => SeriesItem.fromJson(x))),
      );
}

class Total {
  double amount;
  double changePercent;

  Total({
    required this.amount,
    required this.changePercent,
  });

  factory Total.fromJson(Map<String, dynamic> json) => Total(
        amount: (json["amount"] ?? 0).toDouble(),
        changePercent: (json["changePercent"] ?? 0).toDouble(),
      );
}

class SeriesItem {
  String key;
  String label;
  double amount;

  SeriesItem({
    required this.key,
    required this.label,
    required this.amount,
  });

  factory SeriesItem.fromJson(Map<String, dynamic> json) => SeriesItem(
        key: json["key"] ?? "",
        label: json["label"] ?? "",
        amount: (json["amount"] ?? 0).toDouble(),
      );
}
