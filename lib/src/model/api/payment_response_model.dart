class PaymentResponseModel {
  String? payId;
  String? phone;
  String? message;
  bool? sent;
  String? waitTimer;

  PaymentResponseModel({
    this.payId,
    this.phone,
    this.message,
    this.sent,
    this.waitTimer,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) => PaymentResponseModel(
    payId: json["pay_id"],
    phone: json["phone"],
    message: json["message"] ?? json["result"]?["message"], // Handle nested or direct message
    sent: json["sent"],
    waitTimer: json["wait"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "pay_id": payId,
    "phone": phone,
    "message": message,
    "sent": sent,
    "wait": waitTimer,
  };
}
