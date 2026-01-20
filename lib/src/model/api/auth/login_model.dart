// login_model.dart

class LoginModel {
  DataData data;
  String message;
  Tokens tokens;

  LoginModel({
    required this.data,
    required this.message,
    required this.tokens,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    data: json["data"] == null
        ? DataData.fromJson({})
        : DataData.fromJson(json["data"]),
    message: json["message"] ?? "",
    tokens: json["tokens"] == null
        ? Tokens.fromJson({})
        : Tokens.fromJson(json["tokens"]),
  );
}

class DataData {
  int id;
  String phoneNumber;
  String password;
  String useType;
  String providerType;
  String providersUserId;
  String email;
  bool inUse;
  String refreshToken;
  User user;

  DataData({
    required this.id,
    required this.phoneNumber,
    required this.password,
    required this.useType,
    required this.providerType,
    required this.providersUserId,
    required this.email,
    required this.inUse,
    required this.refreshToken,
    required this.user,
  });

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
    id: json["id"] is int ? json["id"] : (json["id"] is String ? int.tryParse(json["id"]) ?? 0 : 0),
    phoneNumber: json["phoneNumber"] ?? "",
    password: json["password"] ?? "",
    useType: json["useType"] ?? "",
    providerType: json["providerType"] ?? "",
    providersUserId: json["providersUserId"] ?? "",
    email: json["email"]?.toString() ?? "",
    inUse: json["inUse"] ?? false,
    refreshToken: json["refreshToken"] ?? "",
    user: json["user"] == null
        ? User.fromJson({})
        : User.fromJson(json["user"]),
  );
}

class User {
  int id;
  String? email;
  String fullName;
  String? firstName;
  String? lastName;
  String profilePicture;
  String? birthDate;
  String gender;
  bool verified;
  bool isBlocked;
  String role; // For backward compatibility
  List<String> roles; // New roles array
  int? companyId;
  String fcmToken;
  String? telegramId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? deletedAt;

  User({
    required this.id,
    this.email,
    required this.fullName,
    this.firstName,
    this.lastName,
    required this.profilePicture,
    this.birthDate,
    required this.gender,
    required this.verified,
    required this.isBlocked,
    required this.role,
    required this.roles,
    this.companyId,
    required this.fcmToken,
    this.telegramId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Handle roles array - if roles exists, use it, otherwise use role field
    List<String> rolesList = [];
    if (json["roles"] != null && json["roles"] is List) {
      rolesList = List<String>.from(json["roles"].map((x) => x.toString()));
    } else if (json["role"] != null && json["role"].toString().isNotEmpty) {
      rolesList = [json["role"].toString()];
    }
    
    // For backward compatibility, use first role or empty string
    String roleString = rolesList.isNotEmpty ? rolesList.first : (json["role"]?.toString() ?? "");
    
    return User(
      id: json["id"] is int ? json["id"] : (json["id"] is String ? int.tryParse(json["id"]) ?? 0 : 0),
      email: json["email"]?.toString(),
      fullName: json["fullName"] ?? "",
      firstName: json["firstName"]?.toString(),
      lastName: json["lastName"]?.toString(),
      profilePicture: json["profilePicture"] ?? "",
      birthDate: json["birthDate"]?.toString(),
      gender: json["gender"] ?? "",
      verified: json["verified"] ?? false,
      isBlocked: json["isBlocked"] ?? false,
      role: roleString,
      roles: rolesList,
      companyId: json["companyId"] is int ? json["companyId"] : (json["companyId"] is String ? int.tryParse(json["companyId"]) : null),
      fcmToken: json["fcmToken"] ?? "",
      telegramId: json["telegramId"]?.toString(),
      createdAt: json["createdAt"] == null
          ? null
          : DateTime.tryParse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null
          ? null
          : DateTime.tryParse(json["updatedAt"]),
      deletedAt: json["deletedAt"]?.toString(),
    );
  }
  
  // Helper method to check if user has a specific role
  bool hasRole(String roleToCheck) {
    return roles.contains(roleToCheck.toUpperCase());
  }
  
  // Helper method to check if user is employee (WORKER, MODERATOR, MANAGER)
  bool isEmployee() {
    return hasRole("WORKER") || hasRole("MODERATOR") || hasRole("MANAGER");
  }
  
  // Helper method to check if user is business owner
  bool isBusinessOwner() {
    return hasRole("BUSINESS_OWNER");
  }
}

class Tokens {
  String accessToken;
  String refreshToken;

  Tokens({required this.accessToken, required this.refreshToken});

  factory Tokens.fromJson(Map<String, dynamic> json) => Tokens(
    accessToken: json["access_token"] ?? "",
    refreshToken: json["refresh_token"] ?? "",
  );
}
