import 'dart:convert';

AddTripModel addTripModelFromJson(String str) => AddTripModel.fromJson(json.decode(str));

String addTripModelToJson(AddTripModel data) => json.encode(data.toJson());

class AddTripModel {
  String status;
  String message;
  TripData data;

  AddTripModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddTripModel.fromJson(Map<String, dynamic> json) => AddTripModel(
    status: json["status"],
    message: json["message"],
    data: TripData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class TripData {
  int id;
  String fromRegionId;
  String toRegionId;
  String fromDistrictId;
  String toDistrictId;
  String fromQuarterId;
  String toQuarterId;
  DateTime startTime;
  DateTime endTime;
  String duration;
  String pricePerSeat;
  dynamic totalSeats;
  String availableSeats;
  String startLat;
  String startLong;
  String endLat;
  String endLong;
  dynamic status;
  DateTime createdAt;
  DateTime updatedAt;
  Driver driver;
  TripVehicle vehicle;
  IngPoint startingPoint;
  IngPoint endingPoint;
  List<dynamic> bookings;

  TripData({
    required this.id,
    required this.fromRegionId,
    required this.toRegionId,
    required this.fromDistrictId,
    required this.toDistrictId,
    required this.fromQuarterId,
    required this.toQuarterId,
    required this.startTime,
    required this.endTime,
    required this.duration,
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
    required this.startingPoint,
    required this.endingPoint,
    required this.bookings,
  });

  factory TripData.fromJson(Map<String, dynamic> json) => TripData(
    id: json["id"],
    fromRegionId: json["from_region_id"],
    toRegionId: json["to_region_id"],
    fromDistrictId: json["from_district_id"],
    toDistrictId: json["to_district_id"],
    fromQuarterId: json["from_quarter_id"],
    toQuarterId: json["to_quarter_id"],
    startTime: DateTime.parse(json["start_time"]),
    endTime: DateTime.parse(json["end_time"]),
    duration: json["duration"],
    pricePerSeat: json["price_per_seat"],
    totalSeats: json["total_seats"],
    availableSeats: json["available_seats"],
    startLat: json["start_lat"],
    startLong: json["start_long"],
    endLat: json["end_lat"],
    endLong: json["end_long"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    driver: Driver.fromJson(json["driver"]),
    vehicle: TripVehicle.fromJson(json["vehicle"]),
    startingPoint: IngPoint.fromJson(json["starting_point"]),
    endingPoint: IngPoint.fromJson(json["ending_point"]),
    bookings: List<dynamic>.from(json["bookings"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
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
    "driver": driver.toJson(),
    "vehicle": vehicle.toJson(),
    "starting_point": startingPoint.toJson(),
    "ending_point": endingPoint.toJson(),
    "bookings": List<dynamic>.from(bookings.map((x) => x)),
  };
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
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    phone: json["phone"],
    role: json["role"],
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
    id: json["id"],
    lat: json["lat"],
    long: json["long"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "lat": lat,
    "long": long,
  };
}

class TripVehicle {
  int id;
  String model;
  int seats;
  String carNumber;
  TripVehicleColor color;

  TripVehicle({
    required this.id,
    required this.model,
    required this.seats,
    required this.carNumber,
    required this.color,
  });

  factory TripVehicle.fromJson(Map<String, dynamic> json) => TripVehicle(
    id: json["id"],
    model: json["model"],
    seats: json["seats"],
    carNumber: json["car_number"],
    color: TripVehicleColor.fromJson(json["color"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "model": model,
    "seats": seats,
    "car_number": carNumber,
    "color": color.toJson(),
  };
}

class TripVehicleColor {
  int id;

  TripVehicleColor({
    required this.id,
  });

  factory TripVehicleColor.fromJson(Map<String, dynamic> json) => TripVehicleColor(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}