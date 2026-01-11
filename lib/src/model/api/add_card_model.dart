import 'dart:convert';

AddCardResponseModel addCardModelFromJson(String str) => AddCardResponseModel.fromJson(json.decode(str));

String addCardModelToJson(AddCardResponseModel data) => json.encode(data.toJson());

class AddCardResponseModel {
  String status;
  String message;
  CardResponse card;

  AddCardResponseModel({
    required this.status,
    required this.message,
    required this.card,
  });

  factory AddCardResponseModel.fromJson(Map<String, dynamic> json) => AddCardResponseModel(
    status: json["status"]??"error",
    message: json["message"]??"",
    card: CardResponse.fromJson(json["card"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "card": card.toJson(),
  };
}

class CardResponse {
  int id;
  String label;
  String phone;
  String key;

  CardResponse({
    required this.id,
    required this.label,
    required this.phone,
    required this.key,
  });

  factory CardResponse.fromJson(Map<String, dynamic> json) => CardResponse(
    id: json["id"]??0,
    label: json["label"]??"",
    phone: json["phone"]??"",
    key: json["key"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "phone": phone,
    "key": key,
  };
}