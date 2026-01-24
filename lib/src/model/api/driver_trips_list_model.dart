import 'dart:convert';

DriverTripsListModel driverTripsListModelFromJson(String str) => DriverTripsListModel.fromJson(json.decode(str));

String driverTripsListModelToJson(DriverTripsListModel data) => json.encode(data.toJson());

class DriverTripsListModel {
  String status;
  String message;
  List<DriverTripModel> data;
  Meta meta;

  DriverTripsListModel({
    required this.status,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory DriverTripsListModel.fromJson(Map<String, dynamic> json) => DriverTripsListModel(
    status: json["status"],
    message: json["message"],
    data: List<DriverTripModel>.from(json["data"].map((x) => DriverTripModel.fromJson(x))),
    meta: Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "meta": meta.toJson(),
  };
}

class DriverTripModel {
  int id;
  int fromRegionId;
  int toRegionId;
  int fromCityId;
  int toCityId;
  int fromVillageId;
  int toVillageId;
  DateTime startTime;
  DateTime endTime;
  String duration;
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
  Vehicle vehicle;
  IngPoint startingPoint;
  IngPoint endingPoint;
  List<dynamic> bookings;

  DriverTripModel({
    required this.id,
    required this.fromRegionId,
    required this.toRegionId,
    required this.fromCityId,
    required this.toCityId,
    required this.fromVillageId,
    required this.toVillageId,
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

  factory DriverTripModel.fromJson(Map<String, dynamic> json) => DriverTripModel(
    id: json["id"],
    fromRegionId: json["from_region_id"],
    toRegionId: json["to_region_id"],
    fromCityId: json["from_district_id"],
    toCityId: json["to_district_id"],
    fromVillageId: json["from_quarter_id"],
    toVillageId: json["to_quarter_id"],
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
    vehicle: Vehicle.fromJson(json["vehicle"]),
    startingPoint: IngPoint.fromJson(json["starting_point"]),
    endingPoint: IngPoint.fromJson(json["ending_point"]),
    bookings: List<dynamic>.from(json["bookings"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "from_region_id": fromRegionId,
    "to_region_id": toRegionId,
    "from_district_id": fromCityId,
    "to_district_id": toCityId,
    "from_quarter_id": fromVillageId,
    "to_quarter_id": toVillageId,
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

  factory DriverTripModel.defaultTrip() => DriverTripModel(
    id: 0,
    fromRegionId: 0,
    toRegionId: 0,
    fromCityId: 0,
    toCityId: 0,
    fromVillageId: 0,
    toVillageId: 0,
    startTime: DateTime.now(),
    endTime: DateTime.now(),
    duration: "",
    pricePerSeat: "0",
    totalSeats: 0,
    availableSeats: 0,
    startLat: "0.0",
    startLong: "0.0",
    endLat: "0.0",
    endLong: "0.0",
    status: "pending",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    driver: Driver(
      id: 0,
      firstName: "",
      lastName: "",
      email: "",
      phone: "",
      role: "",
    ),
    vehicle: Vehicle(
      id: 0,
      model: "",
      seats: 0,
      carNumber: "",
      color: VehicleColor(id: 0),
    ),
    startingPoint: IngPoint(id: 0, lat: "0.0", long: "0.0"),
    endingPoint: IngPoint(id: 0, lat: "0.0", long: "0.0"),
    bookings: [],
  );
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

class Vehicle {
  int id;
  String model;
  int seats;
  String carNumber;
  VehicleColor color;

  Vehicle({
    required this.id,
    required this.model,
    required this.seats,
    required this.carNumber,
    required this.color,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    id: json["id"],
    model: json["model"],
    seats: json["seats"],
    carNumber: json["car_number"],
    color: VehicleColor.fromJson(json["color"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "model": model,
    "seats": seats,
    "car_number": carNumber,
    "color": color.toJson(),
  };
}

class VehicleColor {
  int id;

  VehicleColor({
    required this.id,
  });

  factory VehicleColor.fromJson(Map<String, dynamic> json) => VehicleColor(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}

class Meta {
  int currentPage;
  int lastPage;
  int perPage;
  int total;

  Meta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    perPage: json["per_page"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "last_page": lastPage,
    "per_page": perPage,
    "total": total,
  };
}