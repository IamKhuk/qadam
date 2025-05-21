class CreditCardModel {
  CreditCardModel({
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    this.isDefault = false,
  });

  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;
  bool isDefault;
}
