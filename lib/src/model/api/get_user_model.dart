import 'dart:convert';

GetUserModel getUserModelFromJson(String str) => GetUserModel.fromJson(json.decode(str));
String getUserModelToJson(GetUserModel data) => json.encode(data.toJson());

class GetUserModel {
  String status;
  User user;

  GetUserModel({
    required this.status,
    required this.user,
  });

  factory GetUserModel.fromJson(Map<String, dynamic> json) => GetUserModel(
    status: json["status"] ?? "",
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "user": user.toJson(),
  };
}

class User {
  int id;
  String firstName;
  String lastName;
  String fatherName;
  String email;
  String phone;
  String role;
  DateTime? birthDate;
  String drivingVerificationStatus;
  DateTime? createdAt;
  String image;
  Balance balance;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.email,
    required this.phone,
    required this.role,
    required this.birthDate,
    required this.drivingVerificationStatus,
    required this.createdAt,
    required this.image,
    required this.balance,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] ?? 0,
    firstName: json["first_name"] ?? "",
    lastName: json["last_name"] ?? "",
    fatherName: json["father_name"] ?? "",
    email: json["email"] ?? "",
    phone: json["phone"] ?? "",
    role: json["role"] ?? "",
    birthDate: json["birth_date"] != null && json["birth_date"] != ""
        ? DateTime.tryParse(json["birth_date"])
        : DateTime(2000, 1,1,1,1),
    drivingVerificationStatus: json["driving_verification_status"] ?? "none",
    createdAt: DateTime.parse(json["created_at"]),
    image: json["image"] ?? "",
    balance: Balance.fromJson(json["balance"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "father_name": fatherName,
    "email": email,
    "phone": phone,
    "role": role,
    "birth_date": birthDate?.toIso8601String(),
    "driving_verification_status": drivingVerificationStatus,
    "created_at": createdAt?.toIso8601String(),
    "image": image,
    "balance": balance.toJson(),
  };
}

class Balance {
  String balance;
  String afterTax;
  String tax;
  String lockedBalance;
  String currency;

  Balance({
    required this.balance,
    required this.afterTax,
    required this.tax,
    required this.lockedBalance,
    required this.currency,
  });

  factory Balance.fromJson(Map<String, dynamic> json) => Balance(
    balance: json["balance"] ?? "0",
    afterTax: json["after_tax"]??"0",
    tax: json["tax"] ?? "0",
    lockedBalance: json["locked_balance"] ?? "0",
    currency: json["currency"] ?? "USD",
  );

  Map<String, dynamic> toJson() => {
    "balance": balance,
    "after_tax": afterTax,
    "tax": tax,
    "locked_balance": lockedBalance,
    "currency": currency,
  };
}