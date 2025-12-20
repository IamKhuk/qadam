class UserModel {
  int id;
  String firstName;
  String lastName;
  String fatherName;
  String email;
  String phone;
  String password;
  String image;
  String role;
  int isVerified;
  dynamic verificationCode;
  String drivingVerificationStatus;
  DateTime createdAt;
  DateTime updatedAt;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.email,
    required this.phone,
    required this.password,
    required this.image,
    required this.role,
    required this.isVerified,
    required this.verificationCode,
    required this.drivingVerificationStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"]??0,
    firstName: json["first_name"]??"",
    lastName: json["last_name"]??"",
    fatherName: json["father_name"]??"",
    email: json["email"]??"",
    phone: json["phone"]??"",
    password: json["password"]??"",
    image: json["image"]??"default.jpg",
    role: json["role"]??"client",
    isVerified: json["is_verified"]??1,
    verificationCode: json["verification_code"]??"",
    drivingVerificationStatus: json["driving_verification_status"]??"",
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "father_name": fatherName,
    "phone": phone,
    "password": password,
    "image": image,
    "role": role,
    "is_verified": isVerified,
    "verification_code": verificationCode,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}