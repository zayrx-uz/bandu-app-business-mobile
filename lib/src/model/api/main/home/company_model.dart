class CompanyModel {
  final List<CompanyData> data;
  final String message;

  CompanyModel({
    required this.data,
    required this.message,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
    data: json["data"] == null
        ? []
        : List<CompanyData>.from(
            json["data"].map((x) => CompanyData.fromJson(x))),
    message: json["message"] ?? "",
  );
}

class CompanyDataList {
  final List<CompanyData> data;
  final Meta meta;
  final String message;

  CompanyDataList({
    required this.data,
    required this.meta,
    required this.message,
  });

  factory CompanyDataList.empty() => CompanyDataList(
    data: [],
    meta: Meta.empty(),
    message: "",
  );

  factory CompanyDataList.fromJson(Map<String, dynamic> json) {
    return CompanyDataList(
      data: json["data"] == null
          ? []
          : List<CompanyData>.from(
          json["data"].map((x) => CompanyData.fromJson(x))),
      meta: json["meta"] == null ? Meta.empty() : Meta.fromJson(json["meta"]),
      message: json["message"] ?? "",
    );
  }
}

// ---------------------------------------------------------

class CompanyData {
  final int id;
  final String name;
  final Location location;
  final List<Category> categories;
  final List<int>? resourceCategoryIds;
  final int? serviceTypeId;
  final bool isOpen247;
  final String logo;
  final double? rating;
  final WorkingHours workingHours;
  final List<ImageModel> images;

  CompanyData({
    required this.id,
    required this.name,
    required this.location,
    required this.categories,
    required this.resourceCategoryIds,
    required this.serviceTypeId,
    required this.isOpen247,
    required this.logo,
    this.rating,
    required this.workingHours,
    required this.images,
  });

  factory CompanyData.fromJson(Map<String, dynamic> json) {
    return CompanyData(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      location: json["location"] == null
          ? Location.empty()
          : Location.fromJson(json["location"]),
      categories: json["categories"] == null
          ? []
          : List<Category>.from(
          json["categories"].map((x) => Category.fromJson(x))),
      resourceCategoryIds: json["resourceCategoryIds"] == null
          ? null
          : List<int>.from(json["resourceCategoryIds"].map((x) => x)),
      serviceTypeId: json["serviceTypeId"],
      isOpen247: json["isOpen247"] ?? false,
      logo: json["logo"] ?? "",
      rating: json["rating"]?.toDouble(),
      workingHours: json["workingHours"] == null
          ? WorkingHours.empty()
          : WorkingHours.fromJson(json["workingHours"]),
      images: json["images"] == null
          ? []
          : List<ImageModel>.from(
          json["images"].map((x) => ImageModel.fromJson(x))),
    );
  }
}

// ---------------------------------------------------------

class Category {
  final int id;
  final String name;
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    description: json["description"] ?? "",
  );
}

// ---------------------------------------------------------

class ImageModel {
  final int id;
  final String url;
  final String filename;
  final String mimeType;
  final dynamic size;
  final int index;
  final bool isMain;
  final DateTime createdAt;
  final DateTime updatedAt;

  ImageModel({
    required this.id,
    required this.url,
    required this.filename,
    required this.mimeType,
    required this.size,
    required this.index,
    required this.isMain,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
    id: json["id"] ?? 0,
    url: json["url"] ?? "",
    filename: json["filename"] ?? "",
    mimeType: json["mimeType"] ?? "",
    size: json["size"],
    index: json["index"] ?? 0,
    isMain: json["isMain"] ?? false,
    createdAt: json["createdAt"] == null
        ? DateTime.now()
        : DateTime.tryParse(json["createdAt"]) ?? DateTime.now(),
    updatedAt: json["updatedAt"] == null
        ? DateTime.now()
        : DateTime.tryParse(json["updatedAt"]) ?? DateTime.now(),
  );
}

// ---------------------------------------------------------

class Location {
  final int id;
  final String address;
  final double latitude;
  final double longitude;

  Location({
    required this.id,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Location.empty() => Location(
    id: 0,
    address: "",
    latitude: 0,
    longitude: 0,
  );

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    id: json["id"] ?? 0,
    address: json["address"] ?? "",
    latitude: (json["latitude"] ?? 0).toDouble(),
    longitude: (json["longitude"] ?? 0).toDouble(),
  );
}

// ---------------------------------------------------------

class WorkingHours {
  final DayHours monday;
  final DayHours tuesday;
  final DayHours wednesday;
  final DayHours thursday;
  final DayHours friday;
  final DayHours saturday;
  final DayHours sunday;

  WorkingHours({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  factory WorkingHours.empty() => WorkingHours(
    monday: DayHours.empty(),
    tuesday: DayHours.empty(),
    wednesday: DayHours.empty(),
    thursday: DayHours.empty(),
    friday: DayHours.empty(),
    saturday: DayHours.empty(),
    sunday: DayHours.empty(),
  );

  factory WorkingHours.fromJson(Map<String, dynamic> json) => WorkingHours(
    monday: DayHours.fromJson(json["monday"] ?? {}),
    tuesday: DayHours.fromJson(json["tuesday"] ?? {}),
    wednesday: DayHours.fromJson(json["wednesday"] ?? {}),
    thursday: DayHours.fromJson(json["thursday"] ?? {}),
    friday: DayHours.fromJson(json["friday"] ?? {}),
    saturday: DayHours.fromJson(json["saturday"] ?? {}),
    sunday: DayHours.fromJson(json["sunday"] ?? {}),
  );
}

// ---------------------------------------------------------

class DayHours {
  final String? open;
  final String? close;
  final bool closed;

  DayHours({
    this.open,
    this.close,
    required this.closed,
  });

  factory DayHours.empty() => DayHours(
    open: null,
    close: null,
    closed: true,
  );

  factory DayHours.fromJson(Map<String, dynamic> json) => DayHours(
    open: json["open"]?.toString(),
    close: json["close"]?.toString(),
    closed: json["closed"] ?? true,
  );
}

// ---------------------------------------------------------

class Meta {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  Meta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory Meta.empty() => Meta(
    page: 0,
    limit: 0,
    total: 0,
    totalPages: 0,
  );

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    page: json["page"] ?? 0,
    limit: json["limit"] ?? 0,
    total: json["total"] ?? 0,
    totalPages: json["totalPages"] ?? 0,
  );
}
