class UserUpdateModel {
  String fullName;
  String birthDate;
  bool gender;
  String profilePicture;
  String phoneNumber;
  String password;

  UserUpdateModel({
    required this.fullName,
    required this.birthDate,
    required this.gender,
    required this.profilePicture,
    required this.phoneNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "birthDate":
        "${birthDate.split("/").last}-${birthDate.substring(3, 5)}-${birthDate.split("/").first}",
    "gender": gender ? "MALE" : "FEMALE",
    "profilePicture": profilePicture,
    "phoneNumber": phoneNumber,
    "password": password,
  };
}
