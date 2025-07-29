import 'dart:convert';

VerificationResendModel verificationResendFromJson(String str) => VerificationResendModel.fromJson(json.decode(str));

String verificationResendToJson(VerificationResendModel data) => json.encode(data.toJson());

class VerificationResendModel {
  String status;
  String message;
  int code;

  VerificationResendModel({
    required this.status,
    required this.message,
    required this.code,
  });

  factory VerificationResendModel.fromJson(Map<String, dynamic> json) => VerificationResendModel(
    status: json["status"]??"error",
    message: json["message"]??"",
    code: json["code"]??0,
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
  };
}