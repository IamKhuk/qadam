class UserModel {
  int id;
  String name;
  String phone;
  String password;
  String image;
  String regionId;
  String districtId;
  String quarterId;
  String home;
  String role;
  int isVerified;
  dynamic verificationCode;
  DateTime createdAt;
  DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.password,
    required this.image,
    required this.regionId,
    required this.districtId,
    required this.quarterId,
    required this.home,
    required this.role,
    required this.isVerified,
    required this.verificationCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"]??0,
    name: json["name"]??"",
    phone: json["phone"]??"",
    password: json["password"]??"",
    image: json["image"]??"",
    regionId: json["region_id"]??"0",
    districtId: json["district_id"]??"0",
    quarterId: json["quarter_id"]??"0",
    home: json["home"]??"0",
    role: json["role"]??"client",
    isVerified: json["is_verified"]??1,
    verificationCode: json["verification_code"]??"",
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "password": password,
    "image": image,
    "region_id": regionId,
    "district_id": districtId,
    "quarter_id": quarterId,
    "home": home,
    "role": role,
    "is_verified": isVerified,
    "verification_code": verificationCode,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}