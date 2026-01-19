class DashboardEmployeesEmptyModel {
  DashboardEmployeesEmptyData data;
  String message;

  DashboardEmployeesEmptyModel({
    required this.data,
    required this.message,
  });

  factory DashboardEmployeesEmptyModel.fromJson(Map<String, dynamic> json) =>
      DashboardEmployeesEmptyModel(
        data: json["data"] == null
            ? DashboardEmployeesEmptyData.fromJson({})
            : DashboardEmployeesEmptyData.fromJson(json["data"]),
        message: json["message"] ?? "",
      );
}

class DashboardEmployeesEmptyData {
  int companyId;
  List<DashboardEmployeesEmptyGroup> groups;

  DashboardEmployeesEmptyData({
    required this.companyId,
    required this.groups,
  });

  factory DashboardEmployeesEmptyData.fromJson(Map<String, dynamic> json) =>
      DashboardEmployeesEmptyData(
        companyId: json["companyId"] ?? 0,
        groups: json["groups"] == null
            ? []
            : List<DashboardEmployeesEmptyGroup>.from(json["groups"]
                .map((x) => DashboardEmployeesEmptyGroup.fromJson(x))),
      );
}

class DashboardEmployeesEmptyGroup {
  String groupName;
  List<DashboardEmptyEmployee> employees;

  DashboardEmployeesEmptyGroup({
    required this.groupName,
    required this.employees,
  });

  factory DashboardEmployeesEmptyGroup.fromJson(Map<String, dynamic> json) =>
      DashboardEmployeesEmptyGroup(
        groupName: json["groupName"] ?? "Employees",
        employees: json["employees"] == null
            ? []
            : List<DashboardEmptyEmployee>.from(
                json["employees"].map((x) => DashboardEmptyEmployee.fromJson(x))),
      );
}

class DashboardEmptyEmployee {
  int id;
  String fullName;
  String? profilePicture;
  String phoneNumber;

  DashboardEmptyEmployee({
    required this.id,
    required this.fullName,
    this.profilePicture,
    required this.phoneNumber,
  });

  factory DashboardEmptyEmployee.fromJson(Map<String, dynamic> json) =>
      DashboardEmptyEmployee(
        id: json["id"] ?? 0,
        fullName: json["fullName"] ?? "",
        profilePicture: json["profilePicture"],
        phoneNumber: json["phoneNumber"] ?? "",
      );
}
