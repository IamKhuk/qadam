import 'dart:convert';

TopUpModel topUpModelFromJson(String str) => TopUpModel.fromJson(json.decode(str));

String topUpModelToJson(TopUpModel data) => json.encode(data.toJson());

class TopUpModel {
  String status;
  String message;
  TransactionModel? transaction; // make nullable

  TopUpModel({
    required this.status,
    required this.message,
    this.transaction,
  });

  factory TopUpModel.fromJson(Map<String, dynamic> json) => TopUpModel(
    status: json["status"] ?? "failed",
    message: json["message"] ?? "",
    transaction: json["transaction"] != null
        ? TransactionModel.fromJson(json["transaction"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "transaction": transaction?.toJson(),
  };
}

class TransactionModel {
  int id;
  String type;
  String amount;
  String balanceBefore;
  String balanceAfter;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
    id: json["id"] ?? 0,
    type: json["type"] ?? "",
    amount: json["amount"] ?? "",
    balanceBefore: json["balance_before"] ?? "",
    balanceAfter: json["balance_after"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "amount": amount,
    "balance_before": balanceBefore,
    "balance_after": balanceAfter,
  };
}