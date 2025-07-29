import 'dart:convert';

import 'package:qadam/src/model/api/user_model.dart';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String status;
  String message;
  UserModel user;
  Authorisation authorisation;

  LoginModel({
    required this.status,
    required this.message,
    required this.user,
    required this.authorisation,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    status: json["status"]??"error",
    message: json["message"]??"",
    user: UserModel.fromJson(json["user"]),
    authorisation: Authorisation.fromJson(json["authorisation"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "user": user.toJson(),
    "authorisation": authorisation.toJson(),
  };
}

class Authorisation {
  String token;
  String type;

  Authorisation({
    required this.token,
    required this.type,
  });

  factory Authorisation.fromJson(Map<String, dynamic> json) => Authorisation(
    token: json["token"]??"",
    type: json["type"]??"",
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "type": type,
  };
}