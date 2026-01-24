class IconModel {
  List<IconData> data;
  String message;

  IconModel({
    required this.data,
    required this.message,
  });

  factory IconModel.fromJson(Map<String, dynamic> json) => IconModel(
    data: json["data"] == null || json["data"] is! List
        ? []
        : List<IconData>.from((json["data"] as List).map((x) => IconData.fromJson(x))),
    message: json["message"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class IconData {
  int id;
  String url;
  String name;
  String createdAt;
  String updatedAt;

  IconData({
    required this.id,
    required this.url,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IconData.fromJson(Map<String, dynamic> json) => IconData(
    id: json["id"] is int ? json["id"] : (json["id"] is String ? int.tryParse(json["id"]) ?? 0 : 0),
    url: json["url"]?.toString() ?? "",
    name: json["name"]?.toString() ?? "",
    createdAt: json["createdAt"]?.toString() ?? "",
    updatedAt: json["updatedAt"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
    "name": name,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}
