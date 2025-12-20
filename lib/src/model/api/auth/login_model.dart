// login_model.dart

class LoginModel {
  LoginModelData data;

  LoginModel({required this.data});

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    data: json["data"] == null
        ? LoginModelData.fromJson({})
        : LoginModelData.fromJson(json["data"]),
  );
}

class LoginModelData {
  DataData data;
  String message;
  Tokens tokens;

  LoginModelData({
    required this.data,
    required this.message,
    required this.tokens,
  });

  factory LoginModelData.fromJson(Map<String, dynamic> json) => LoginModelData(
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
    id: json["id"] ?? 0,
    phoneNumber: json["phoneNumber"] ?? "",
    password: json["password"] ?? "",
    useType: json["useType"] ?? "",
    providerType: json["providerType"] ?? "",
    providersUserId: json["providersUserId"] ?? "",
    email: json["email"] ?? "",
    inUse: json["inUse"] ?? false,
    refreshToken: json["refreshToken"] ?? "",
    user: json["user"] == null
        ? User.fromJson({})
        : User.fromJson(json["user"]),
  );
}

class User {
  int id;
  String email;
  String fullName;
  String firstName;
  String lastName;
  String profilePicture;
  String birthDate;
  String gender;
  bool verified;
  bool isBlocked;
  String role;
  int companyId;
  String fcmToken;
  String telegramId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String deletedAt;

  User({
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

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] ?? 0,
    email: json["email"] ?? "",
    fullName: json["fullName"] ?? "",
    firstName: json["firstName"] ?? "",
    lastName: json["lastName"] ?? "",
    profilePicture: json["profilePicture"] ?? "",
    birthDate: json["birthDate"] ?? "",
    gender: json["gender"] ?? "",
    verified: json["verified"] ?? false,
    isBlocked: json["isBlocked"] ?? false,
    role: json["role"] ?? "",
    companyId: json["companyId"] ?? 0,
    fcmToken: json["fcmToken"] ?? "",
    telegramId: json["telegramId"] ?? "",
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.tryParse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.tryParse(json["updatedAt"]),
    deletedAt: json["deletedAt"]?.toString() ?? "",
  );
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
