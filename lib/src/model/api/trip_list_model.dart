import 'dart:convert';

List<TripListModel> tripListModelFromJson(String str) => List<TripListModel>.from(json.decode(str).map((x) => TripListModel.fromJson(x)));

String tripListModelToJson(List<TripListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TripListModel {
  int id;
  String fromWhere;
  String toWhere;
  int fromRegionId;
  int toRegionId;
  int fromCityId;
  int toCityId;
  int fromVillageId;
  int toVillageId;
  DateTime startTime;
  DateTime endTime;
  String pricePerSeat;
  int totalSeats;
  int availableSeats;
  String startLat;
  String startLong;
  String endLat;
  String endLong;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  Driver driver;
  TripVehicle vehicle;

  TripListModel({
    required this.id,
    required this.fromWhere,
    required this.toWhere,
    required this.fromRegionId,
    required this.toRegionId,
    required this.fromCityId,
    required this.toCityId,
    required this.fromVillageId,
    required this.toVillageId,
    required this.startTime,
    required this.endTime,
    required this.pricePerSeat,
    required this.totalSeats,
    required this.availableSeats,
    required this.startLat,
    required this.startLong,
    required this.endLat,
    required this.endLong,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.driver,
    required this.vehicle,
  });

  factory TripListModel.fromJson(Map<String, dynamic> json) => TripListModel(
    id: json["id"]??0,
    fromWhere: json["from_where"]??"",
    toWhere: json["to_where"]??"",
    fromRegionId: json["from_region_id"]??0,
    toRegionId: json["to_region_id"]??0,
    fromCityId: json["from_district_id"]??0,
    toCityId: json["to_district_id"]??0,
    fromVillageId: json["from_quarter_id"]??0,
    toVillageId: json["to_quarter_id"]??0,
    startTime: DateTime.parse(json["start_time"]),
    endTime: DateTime.parse(json["end_time"]),
    pricePerSeat: json["price_per_seat"]??"",
    totalSeats: json["total_seats"]??0,
    availableSeats: json["available_seats"]??0,
    startLat: json["start_lat"]??"",
    startLong: json["start_long"]??"",
    endLat: json["end_lat"]??"",
    endLong: json["end_long"]??"",
    status: json["status"]??"",
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    driver: Driver.fromJson(json["driver"]),
    vehicle: TripVehicle.fromJson(json["vehicle"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "from_where": fromWhere,
    "to_where": toWhere,
    "from_region_id": fromRegionId,
    "to_region_id": toRegionId,
    "from_district_id": fromCityId,
    "to_district_id": toCityId,
    "from_quarter_id": fromVillageId,
    "to_quarter_id": toVillageId,
    "start_time": startTime.toIso8601String(),
    "end_time": endTime.toIso8601String(),
    "price_per_seat": pricePerSeat,
    "total_seats": totalSeats,
    "available_seats": availableSeats,
    "start_lat": startLat,
    "start_long": startLong,
    "end_lat": endLat,
    "end_long": endLong,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "driver": driver.toJson(),
    "vehicle": vehicle.toJson(),
  };
}

class Driver {
  int id;
  String name;
  String role;

  Driver({
    required this.id,
    required this.name,
    required this.role,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json["id"]??0,
    name: json["name"]??"",
    role: json["role"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "role": role,
  };
}

class TripVehicle {
  int id;
  String model;
  int seats;
  String carNumber;
  CarColor color;

  TripVehicle({
    required this.id,
    required this.model,
    required this.seats,
    required this.carNumber,
    required this.color,
  });

  factory TripVehicle.fromJson(Map<String, dynamic> json) => TripVehicle(
    id: json["id"]??0,
    model: json["model"]??"",
    seats: json["seats"]??0,
    carNumber: json["car_number"]??"",
    color: CarColor.fromJson(json["color"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "model": model,
    "seats": seats,
    "car_number": carNumber,
    "color": color.toJson(),
  };
}

class CarColor {
  int id;
  String titleUz;
  String titleRu;
  String titleEn;
  String code;

  CarColor({
    required this.id,
    required this.titleUz,
    required this.titleRu,
    required this.titleEn,
    required this.code,
  });

  factory CarColor.fromJson(Map<String, dynamic> json) => CarColor(
    id: json["id"]??0,
    titleUz: json["title_uz"]??"",
    titleRu: json["title_ru"]??"",
    titleEn: json["title_en"]??"",
    code: json["code"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title_uz": titleUz,
    "title_ru": titleRu,
    "title_en": titleEn,
    "code": code,
  };
}