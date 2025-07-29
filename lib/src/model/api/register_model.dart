import 'dart:convert';

RegisterModel registerModelFromJson(String str) => RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  String status;
  String message;
  int userId;
  int code;

  RegisterModel({
    required this.status,
    required this.message,
    required this.userId,
    required this.code,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
    status: json["status"]??"error",
    message: json["message"]??"",
    userId: json["user_id"]??0,
    code: json["code"]??0,
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "user_id": userId,
    "code": code,
  };
}