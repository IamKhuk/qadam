class CreditCardModel {
  CreditCardModel({
    this.id,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    this.isDefault = false,
    this.balance,
  });

  int? id;
  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;
  bool isDefault;
  double? balance;

  factory CreditCardModel.fromJson(Map<String, dynamic> json) => CreditCardModel(
    id: json["id"] is int ? json["id"] : int.tryParse(json["id"]?.toString() ?? ""),
    cardNumber: json["card_number"] ?? json["pan"] ?? "",
    expiryDate: json["expiry"] ?? "",
    cardHolderName: json["card_holder"] ?? json["holder_name"] ?? "",
    cvvCode: "", // Usually not returned by API
    balance: json["balance"] != null ? double.tryParse(json["balance"].toString()) : null,
  );
}
