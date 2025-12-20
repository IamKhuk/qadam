import 'dart:convert';

AddVehicleModel addVehicleModelFromJson(String str) => AddVehicleModel.fromJson(json.decode(str));

String addVehicleModelToJson(AddVehicleModel data) => json.encode(data.toJson());

class AddVehicleModel {
  String status;
  String message;
  VehicleData data;

  AddVehicleModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddVehicleModel.fromJson(Map<String, dynamic> json) => AddVehicleModel(
    status: json["status"],
    message: json["message"],
    data: VehicleData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class VehicleData {
  int id;
  String model;
  String carNumber;
  String techPassportNumber;
  String seats;
  DateTime createdAt;
  DateTime updatedAt;
  List<String> vehicleImages;
  String techPassportImage;
  VehicleColor color;
  You you;

  VehicleData({
    required this.id,
    required this.model,
    required this.carNumber,
    required this.techPassportNumber,
    required this.seats,
    required this.createdAt,
    required this.updatedAt,
    required this.vehicleImages,
    required this.techPassportImage,
    required this.color,
    required this.you,
  });

  factory VehicleData.fromJson(Map<String, dynamic> json) => VehicleData(
    id: json["id"],
    model: json["model"],
    carNumber: json["car_number"],
    techPassportNumber: json["tech_passport_number"],
    seats: json["seats"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    vehicleImages: List<String>.from(json["vehicle_images"].map((x) => x)),
    techPassportImage: json["tech_passport_image"],
    color: VehicleColor.fromJson(json["color"]),
    you: You.fromJson(json["you"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "model": model,
    "car_number": carNumber,
    "tech_passport_number": techPassportNumber,
    "seats": seats,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "vehicle_images": List<dynamic>.from(vehicleImages.map((x) => x)),
    "tech_passport_image": techPassportImage,
    "color": color.toJson(),
    "you": you.toJson(),
  };
}

class VehicleColor {
  String titleUz;
  String titleRu;
  String titleEn;
  String code;

  VehicleColor({
    required this.titleUz,
    required this.titleRu,
    required this.titleEn,
    required this.code,
  });

  factory VehicleColor.fromJson(Map<String, dynamic> json) => VehicleColor(
    titleUz: json["title_uz"],
    titleRu: json["title_ru"],
    titleEn: json["title_en"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "title_uz": titleUz,
    "title_ru": titleRu,
    "title_en": titleEn,
    "code": code,
  };
}

class You {
  int id;
  String firstName;
  String lastName;
  String phone;

  You({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  factory You.fromJson(Map<String, dynamic> json) => You(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "phone": phone,
  };
}