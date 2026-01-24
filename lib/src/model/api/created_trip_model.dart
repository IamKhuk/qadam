import 'dart:convert';
import 'package:qadam/src/model/api/trip_list_model.dart' as trip_list;

CreatedTripResponseModel createdTripResponseModelFromJson(String str) => CreatedTripResponseModel.fromJson(json.decode(str));

String createdTripResponseModelToJson(CreatedTripResponseModel data) => json.encode(data.toJson());

class CreatedTripResponseModel {
  int id;
  String? fromWhere;
  String? toWhere;
  int fromRegionId;
  int toRegionId;
  int fromDistrictId;
  int toDistrictId;
  int fromQuarterId;
  int toQuarterId;
  DateTime startTime;
  DateTime endTime;
  String? duration;
  int pricePerSeat;
  dynamic totalSeats;
  int availableSeats;
  String startLat;
  String startLong;
  String endLat;
  String endLong;
  dynamic status;
  DateTime createdAt;
  DateTime updatedAt;
  Driver? driver;
  trip_list.TripVehicle? vehicle;
  IngPoint? startingPoint;
  IngPoint? endingPoint;
  List<dynamic> bookings;

  CreatedTripResponseModel({
    required this.id,
    this.fromWhere,
    this.toWhere,
    required this.fromRegionId,
    required this.toRegionId,
    required this.fromDistrictId,
    required this.toDistrictId,
    required this.fromQuarterId,
    required this.toQuarterId,
    required this.startTime,
    required this.endTime,
    this.duration,
    required this.pricePerSeat,
    this.totalSeats,
    required this.availableSeats,
    required this.startLat,
    required this.startLong,
    required this.endLat,
    required this.endLong,
    this.status,
    required this.createdAt,
    required this.updatedAt,
    this.driver,
    this.vehicle,
    this.startingPoint,
    this.endingPoint,
    required this.bookings,
  });

  factory CreatedTripResponseModel.fromJson(Map<String, dynamic> json) => CreatedTripResponseModel(
    id: json["id"] ?? 0,
    fromWhere: json["from_where"],
    toWhere: json["to_where"],
    fromRegionId: _toInt(json["from_region_id"]),
    toRegionId: _toInt(json["to_region_id"]),
    fromDistrictId: _toInt(json["from_district_id"]),
    toDistrictId: _toInt(json["to_district_id"]),
    fromQuarterId: _toInt(json["from_quarter_id"]),
    toQuarterId: _toInt(json["to_quarter_id"]),
    startTime: json["start_time"] != null ? DateTime.parse(json["start_time"]) : DateTime.now(),
    endTime: json["end_time"] != null ? DateTime.parse(json["end_time"]) : DateTime.now(),
    duration: json["duration"],
    pricePerSeat: _toInt(json["price_per_seat"]),
    totalSeats: json["total_seats"],
    availableSeats: _toInt(json["available_seats"]),
    startLat: json["start_lat"]?.toString() ?? "",
    startLong: json["start_long"]?.toString() ?? "",
    endLat: json["end_lat"]?.toString() ?? "",
    endLong: json["end_long"]?.toString() ?? "",
    status: json["status"],
    createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : DateTime.now(),
    updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : DateTime.now(),
    driver: json["driver"] != null ? Driver.fromJson(json["driver"]) : null,
    vehicle: json["vehicle"] != null ? trip_list.TripVehicle.fromJson(json["vehicle"]) : null,
    startingPoint: json["starting_point"] != null ? IngPoint.fromJson(json["starting_point"]) : null,
    endingPoint: json["ending_point"] != null ? IngPoint.fromJson(json["ending_point"]) : null,
    bookings: json["bookings"] != null ? List<dynamic>.from(json["bookings"].map((x) => x)) : [],
  );

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "from_where": fromWhere,
    "to_where": toWhere,
    "from_region_id": fromRegionId,
    "to_region_id": toRegionId,
    "from_district_id": fromDistrictId,
    "to_district_id": toDistrictId,
    "from_quarter_id": fromQuarterId,
    "to_quarter_id": toQuarterId,
    "start_time": startTime.toIso8601String(),
    "end_time": endTime.toIso8601String(),
    "duration": duration,
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
    "driver": driver?.toJson(),
    "vehicle": vehicle?.toJson(),
    "starting_point": startingPoint?.toJson(),
    "ending_point": endingPoint?.toJson(),
    "bookings": List<dynamic>.from(bookings.map((x) => x)),
  };

  trip_list.TripListModel toTripListModel() {
    return trip_list.TripListModel(
      id: id,
      fromWhere: fromWhere ?? "",
      toWhere: toWhere ?? "",
      fromRegionId: fromRegionId,
      toRegionId: toRegionId,
      fromCityId: fromDistrictId,
      toCityId: toDistrictId,
      fromVillageId: fromQuarterId,
      toVillageId: toQuarterId,
      startTime: startTime,
      endTime: endTime,
      pricePerSeat: pricePerSeat.toString(),
      totalSeats: totalSeats is int ? totalSeats : (int.tryParse(totalSeats?.toString() ?? "0") ?? 0),
      availableSeats: availableSeats,
      startLat: startLat,
      startLong: startLong,
      endLat: endLat,
      endLong: endLong,
      status: status?.toString() ?? "",
      createdAt: createdAt,
      updatedAt: updatedAt,
      driver: driver != null 
          ? trip_list.TripDriver(id: driver!.id, name: "${driver!.firstName} ${driver!.lastName}", role: driver!.role)
          : trip_list.TripDriver(id: 0, name: "", role: ""),
      vehicle: vehicle ?? trip_list.TripVehicle(id: 0, model: "", seats: 0, carNumber: "", color: trip_list.CarColor(id: 0, titleUz: "", titleRu: "", titleEn: "", code: "")),
    );
  }
}

class Driver {
  int id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String role;

  Driver({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json["id"] ?? 0,
    firstName: json["first_name"] ?? "",
    lastName: json["last_name"] ?? "",
    email: json["email"] ?? "",
    phone: json["phone"] ?? "",
    role: json["role"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "phone": phone,
    "role": role,
  };
}

class IngPoint {
  int id;
  String lat;
  String long;

  IngPoint({
    required this.id,
    required this.lat,
    required this.long,
  });

  factory IngPoint.fromJson(Map<String, dynamic> json) => IngPoint(
    id: json["id"] ?? 0,
    lat: json["lat"]?.toString() ?? "",
    long: json["long"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "lat": lat,
    "long": long,
  };
}
