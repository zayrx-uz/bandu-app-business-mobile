class BarcodeModel {
  String type;
  int placeId;
  String placeName;
  int companyId;
  String companyName;
  String category;
  DateTime? timestamp;
  String url;

  BarcodeModel({
    required this.type,
    required this.placeId,
    required this.placeName,
    required this.companyId,
    required this.companyName,
    required this.category,
    required this.timestamp,
    required this.url,
  });

  factory BarcodeModel.fromJson(Map<String, dynamic> json) => BarcodeModel(
    type: json["type"] ?? "",
    placeId: json["placeId"] ?? 0,
    placeName: json["placeName"] ?? "",
    companyId: json["companyId"] ?? 0,
    companyName: json["companyName"] ?? "",
    category: json["category"] ?? "",
    timestamp: json["timestamp"] == null
        ? null
        : DateTime.parse(json["timestamp"]),
    url: json["url"] ?? "",
  );
}
