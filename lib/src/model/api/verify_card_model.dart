import 'dart:convert';

VerifyCardResponseModel verifyCardResponseModelFromJson(String str) => VerifyCardResponseModel.fromJson(json.decode(str));

String verifyCardResponseModelToJson(VerifyCardResponseModel data) => json.encode(data.toJson());

class VerifyCardResponseModel {
  String status;
  String message;
  VerifyCard card;

  VerifyCardResponseModel({
    required this.status,
    required this.message,
    required this.card,
  });

  factory VerifyCardResponseModel.fromJson(Map<String, dynamic> json) => VerifyCardResponseModel(
    status: json["status"]??"error",
    message: json["message"]??"Something went wrong",
    card: VerifyCard.fromJson(json["card"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "card": card.toJson(),
  };
}

class VerifyCard {
  String id;

  VerifyCard({
    required this.id,
  });

  factory VerifyCard.fromJson(Map<String, dynamic> json) => VerifyCard(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}