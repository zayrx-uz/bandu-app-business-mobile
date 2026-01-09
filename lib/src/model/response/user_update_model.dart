class UserUpdateModel {
  String fullName;
  String? firstName;
  String? lastName;
  String? birthDate;
  String? gender;
  String profilePicture;
  String phoneNumber;
  String? password;

  UserUpdateModel({
    required this.fullName,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.gender,
    required this.profilePicture,
    required this.phoneNumber,
    this.password,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      "fullName": fullName,
      "profilePicture": profilePicture,
      "phoneNumber": phoneNumber,
    };

    if (firstName != null && firstName!.isNotEmpty) {
      json["firstName"] = firstName;
    }

    if (lastName != null && lastName!.isNotEmpty) {
      json["lastName"] = lastName;
    }

    if (birthDate != null && birthDate!.isNotEmpty) {
      try {
        final parts = birthDate!.split("/");
        if (parts.length == 3) {
          json["birthDate"] =
              "${parts[2]}-${parts[1]}-${parts[0].padLeft(2, '0')}";
        }
      } catch (_) {}
    }

    if (gender != null && gender!.isNotEmpty) {
      json["gender"] = gender;
    }

    if (password != null && password!.isNotEmpty) {
      json["password"] = password;
    }

    return json;
  }
}
