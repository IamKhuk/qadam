import 'dart:convert';

ApplyDriverResponseModel applyDriverResponseModelFromJson(String str) => ApplyDriverResponseModel.fromJson(json.decode(str));

String applyDriverResponseModelToJson(ApplyDriverResponseModel data) => json.encode(data.toJson());

class ApplyDriverResponseModel {
  String status;
  String message;
  int vehicleId;

  ApplyDriverResponseModel({
    required this.status,
    required this.message,
    required this.vehicleId,
  });

  factory ApplyDriverResponseModel.fromJson(Map<String, dynamic> json) => ApplyDriverResponseModel(
    status: json["status"]??"error",
    message: json["message"]??"",
    vehicleId: json["vehicle_id"]??0,
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "vehicle_id": vehicleId,
  };
}