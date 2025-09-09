import 'dart:convert';

ImageUploadResponseModel imageUploadResponseModelFromJson(String str) => ImageUploadResponseModel.fromJson(json.decode(str));

String imageUploadResponseModelToJson(ImageUploadResponseModel data) => json.encode(data.toJson());

class ImageUploadResponseModel {
  String status;
  String message;

  ImageUploadResponseModel({
    required this.status,
    required this.message,
  });

  factory ImageUploadResponseModel.fromJson(Map<String, dynamic> json) => ImageUploadResponseModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}