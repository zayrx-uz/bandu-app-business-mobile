import 'dart:convert';

EmployeeModel employeeModelFromJson(String str) =>
    EmployeeModel.fromJson(json.decode(str));

class EmployeeModel {
  final List<EmployeeItemData> data;
  final String message;

  EmployeeModel({
    required this.data,
    required this.message,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
    data: json["data"] == null
        ? []
        : List<EmployeeItemData>.from(
            json["data"].map((x) => EmployeeItemData.fromJson(x)),
          ),
    message: json["message"] ?? "",
  );
}

/// ---------------- EMPLOYEE ITEM ----------------

class EmployeeItemData {
  final int id;
  final dynamic email;
  final String fullName;
  final dynamic firstName;
  final dynamic lastName;
  final dynamic profilePicture;
  final dynamic birthDate;
  final dynamic gender;
  final bool verified;
  final bool isBlocked;
  final String role;
  final int companyId;
  final dynamic fcmToken;
  final dynamic telegramId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final List<AuthProvider> authProviders;

  EmployeeItemData({
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
    required this.authProviders,
  });

  factory EmployeeItemData.fromJson(Map<String, dynamic> json) =>
      EmployeeItemData(
        id: json["id"] ?? 0,
        email: json["email"],
        fullName: json["fullName"] ?? "",
        firstName: json["firstName"],
        lastName: json["lastName"],
        profilePicture: json["profilePicture"],
        birthDate: json["birthDate"],
        gender: json["gender"],
        verified: json["verified"] ?? false,
        isBlocked: json["isBlocked"] ?? false,
        role: json["role"] ?? "",
        companyId: json["companyId"] ?? 0,
        fcmToken: json["fcmToken"],
        telegramId: json["telegramId"],
        createdAt: json["createdAt"] == null
            ? DateTime.now()
            : DateTime.tryParse(json["createdAt"]) ?? DateTime.now(),
        updatedAt: json["updatedAt"] == null
            ? DateTime.now()
            : DateTime.tryParse(json["updatedAt"]) ?? DateTime.now(),
        deletedAt: json["deletedAt"],
        authProviders: json["authProviders"] == null
            ? []
            : List<AuthProvider>.from(
          json["authProviders"].map((x) => AuthProvider.fromJson(x)),
        ),
      );
}

/// ---------------- AUTH PROVIDER ----------------

class AuthProvider {
  final int id;
  final String phoneNumber;
  final String password;
  final String useType;
  final String providerType;
  final String providersUserId;
  final dynamic email;
  final bool inUse;
  final dynamic refreshToken;

  AuthProvider({
    required this.id,
    required this.phoneNumber,
    required this.password,
    required this.useType,
    required this.providerType,
    required this.providersUserId,
    required this.email,
    required this.inUse,
    required this.refreshToken,
  });

  factory AuthProvider.fromJson(Map<String, dynamic> json) => AuthProvider(
    id: json["id"] ?? 0,
    phoneNumber: json["phoneNumber"] ?? "",
    password: json["password"] ?? "",
    useType: json["useType"] ?? "",
    providerType: json["providerType"] ?? "",
    providersUserId: json["providersUserId"] ?? "",
    email: json["email"],
    inUse: json["inUse"] ?? false,
    refreshToken: json["refreshToken"],
  );
}
