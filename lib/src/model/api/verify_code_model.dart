import 'dart:convert';

VerifyCodeModel verifyCodeModelFromJson(String str) => VerifyCodeModel.fromJson(json.decode(str));

String verifyCodeModelToJson(VerifyCodeModel data) => json.encode(data.toJson());

class VerifyCodeModel {
  String status;
  String message;
  String go;

  VerifyCodeModel({
    required this.status,
    required this.message,
    required this.go,
  });

  factory VerifyCodeModel.fromJson(Map<String, dynamic> json) => VerifyCodeModel(
    status: json["status"]??"error",
    message: json["message"]??"",
    go: json["go"]??"",
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "go": go,
  };
}