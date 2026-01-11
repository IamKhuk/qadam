import 'dart:convert';

MyCardsResponseModel myCardResponseModelFromJson(String str) => MyCardsResponseModel.fromJson(json.decode(str));

String myCardResponseModelToJson(MyCardsResponseModel data) => json.encode(data.toJson());

class MyCardsResponseModel {
  String status;
  String message;
  List<Card> cards;

  MyCardsResponseModel({
    required this.status,
    required this.message,
    required this.cards,
  });

  factory MyCardsResponseModel.fromJson(Map<String, dynamic> json) => MyCardsResponseModel(
    status: json["status"],
    message: json["message"],
    cards: List<Card>.from(json["cards"].map((x) => Card.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "cards": List<dynamic>.from(cards.map((x) => x.toJson())),
  };
}

class Card {
  int id;
  int userId;
  String cardId;
  String number;
  String expiry;
  String phone;
  String label;
  int isDefault;
  String status;
  String meta;
  DateTime createdAt;
  DateTime updatedAt;

  Card({
    required this.id,
    required this.userId,
    required this.cardId,
    required this.number,
    required this.expiry,
    required this.phone,
    required this.label,
    required this.isDefault,
    required this.status,
    required this.meta,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Card.fromJson(Map<String, dynamic> json) => Card(
    id: json["id"],
    userId: json["user_id"],
    cardId: json["card_id"],
    number: json["number"],
    expiry: json["expiry"],
    phone: json["phone"],
    label: json["label"],
    isDefault: json["is_default"],
    status: json["status"],
    meta: json["meta"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "card_id": cardId,
    "number": number,
    "expiry": expiry,
    "phone": phone,
    "label": label,
    "is_default": isDefault,
    "status": status,
    "meta": meta,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}