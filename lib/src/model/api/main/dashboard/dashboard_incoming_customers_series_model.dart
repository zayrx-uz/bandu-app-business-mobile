class DashboardIncomingCustomersSeriesModel {
  DashboardIncomingCustomersSeriesData data;
  String message;

  DashboardIncomingCustomersSeriesModel({
    required this.data,
    required this.message,
  });

  factory DashboardIncomingCustomersSeriesModel.fromJson(
          Map<String, dynamic> json) =>
      DashboardIncomingCustomersSeriesModel(
        data: json["data"] == null
            ? DashboardIncomingCustomersSeriesData.fromJson({})
            : DashboardIncomingCustomersSeriesData.fromJson(json["data"]),
        message: json["message"] ?? "",
      );
}

class DashboardIncomingCustomersSeriesData {
  int companyId;
  String period;
  TotalCount total;
  String? lastUpdatedAt;
  List<SeriesCountItem> series;

  DashboardIncomingCustomersSeriesData({
    required this.companyId,
    required this.period,
    required this.total,
    this.lastUpdatedAt,
    required this.series,
  });

  factory DashboardIncomingCustomersSeriesData.fromJson(
          Map<String, dynamic> json) =>
      DashboardIncomingCustomersSeriesData(
        companyId: json["companyId"] ?? 0,
        period: json["period"] ?? "",
        total: json["total"] == null
            ? TotalCount.fromJson({})
            : TotalCount.fromJson(json["total"]),
        lastUpdatedAt: json["lastUpdatedAt"],
        series: json["series"] == null
            ? []
            : List<SeriesCountItem>.from(
                json["series"].map((x) => SeriesCountItem.fromJson(x))),
      );
}

class TotalCount {
  int count;
  double changePercent;

  TotalCount({
    required this.count,
    required this.changePercent,
  });

  factory TotalCount.fromJson(Map<String, dynamic> json) => TotalCount(
        count: json["count"] ?? 0,
        changePercent: (json["changePercent"] ?? 0).toDouble(),
      );
}

class SeriesCountItem {
  String key;
  String label;
  int count;

  SeriesCountItem({
    required this.key,
    required this.label,
    required this.count,
  });

  factory SeriesCountItem.fromJson(Map<String, dynamic> json) =>
      SeriesCountItem(
        key: json["key"] ?? "",
        label: json["label"] ?? "",
        count: json["count"] ?? 0,
      );
}
