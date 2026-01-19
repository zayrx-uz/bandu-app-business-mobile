class DashboardEmployeesBookedModel {
  DashboardEmployeesBookedData data;
  String message;

  DashboardEmployeesBookedModel({
    required this.data,
    required this.message,
  });

  factory DashboardEmployeesBookedModel.fromJson(Map<String, dynamic> json) =>
      DashboardEmployeesBookedModel(
        data: json["data"] == null
            ? DashboardEmployeesBookedData.fromJson({})
            : DashboardEmployeesBookedData.fromJson(json["data"]),
        message: json["message"] ?? "",
      );
}

class DashboardEmployeesBookedData {
  int companyId;
  List<DashboardEmployeesBookedGroup> groups;

  DashboardEmployeesBookedData({
    required this.companyId,
    required this.groups,
  });

  factory DashboardEmployeesBookedData.fromJson(Map<String, dynamic> json) =>
      DashboardEmployeesBookedData(
        companyId: json["companyId"] ?? 0,
        groups: json["groups"] == null
            ? []
            : List<DashboardEmployeesBookedGroup>.from(json["groups"]
                .map((x) => DashboardEmployeesBookedGroup.fromJson(x))),
      );
}

class DashboardEmployeesBookedGroup {
  String groupName;
  List<DashboardBookedEmployee> employees;

  DashboardEmployeesBookedGroup({
    required this.groupName,
    required this.employees,
  });

  factory DashboardEmployeesBookedGroup.fromJson(Map<String, dynamic> json) =>
      DashboardEmployeesBookedGroup(
        groupName: json["groupName"] ?? "Employees",
        employees: json["employees"] == null
            ? []
            : List<DashboardBookedEmployee>.from(
                json["employees"].map((x) => DashboardBookedEmployee.fromJson(x))),
      );
}

class DashboardBookedEmployee {
  int id;
  String fullName;
  String? profilePicture;
  String phoneNumber;

  DashboardBookedEmployee({
    required this.id,
    required this.fullName,
    this.profilePicture,
    required this.phoneNumber,
  });

  factory DashboardBookedEmployee.fromJson(Map<String, dynamic> json) =>
      DashboardBookedEmployee(
        id: json["id"] ?? 0,
        fullName: json["fullName"] ?? "",
        profilePicture: json["profilePicture"],
        phoneNumber: json["phoneNumber"] ?? "",
      );
}
