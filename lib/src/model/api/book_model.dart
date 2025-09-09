import 'dart:convert';

BookModel bookModelFromJson(String str) => BookModel.fromJson(json.decode(str));

String bookModelToJson(BookModel data) => json.encode(data.toJson());

class BookModel {
  int bookingId;
  int seatsBooked;
  String totalPrice;
  String status;
  DateTime createdAt;
  BookedTrip trip;
  List<Passenger> passengers;
  BookDriver driver;
  BookVehicle vehicle;

  BookModel({
    required this.bookingId,
    required this.seatsBooked,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.trip,
    required this.passengers,
    required this.driver,
    required this.vehicle,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) => BookModel(
    bookingId: json["booking_id"]??0,
    seatsBooked: json["seats_booked"]??0,
    totalPrice: json["total_price"]??"",
    status: json["status"]??"",
    createdAt: DateTime.parse(json["created_at"]),
    trip: BookedTrip.fromJson(json["trip"]),
    passengers: List<Passenger>.from(json["passengers"].map((x) => Passenger.fromJson(x))),
    driver: BookDriver.fromJson(json["driver"]),
    vehicle: BookVehicle.fromJson(json["vehicle"]),
  );

  Map<String, dynamic> toJson() => {
    "booking_id": bookingId,
    "seats_booked": seatsBooked,
    "total_price": totalPrice,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "trip": trip.toJson(),
    "passengers": List<dynamic>.from(passengers.map((x) => x.toJson())),
    "driver": driver.toJson(),
    "vehicle": vehicle.toJson(),
  };
}

class BookDriver {
  int id;
  String firstName;
  String lastName;
  String email;
  String role;
  String phone;

  BookDriver({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.phone,
  });

  factory BookDriver.fromJson(Map<String, dynamic> json) => BookDriver(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    role: json["role"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "role": role,
    "phone": phone,
  };
}

class Passenger {
  int id;
  String name;
  String phone;

  Passenger({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) => Passenger(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
  };
}

class BookedTrip {
  int id;
  int startRegionId;
  int endRegionId;
  int startDistrictId;
  int endDistrictId;
  int startQuarterId;
  int endQuarterId;
  DateTime startTime;
  DateTime endTime;
  String pricePerSeat;
  int availableSeats;
  String status;
  String fromLatitude;
  String fromLongitude;
  String toLatitude;
  String toLongitude;

  BookedTrip({
    required this.id,
    required this.startRegionId,
    required this.endRegionId,
    required this.startDistrictId,
    required this.endDistrictId,
    required this.startQuarterId,
    required this.endQuarterId,
    required this.startTime,
    required this.endTime,
    required this.pricePerSeat,
    required this.availableSeats,
    required this.status,
    required this.fromLatitude,
    required this.fromLongitude,
    required this.toLatitude,
    required this.toLongitude,
  });

  factory BookedTrip.fromJson(Map<String, dynamic> json) => BookedTrip(
    id: json["id"],
    startRegionId: json["start_region_id"],
    endRegionId: json["end_region_id"],
    startDistrictId: json["start_district_id"],
    endDistrictId: json["end_district_id"],
    startQuarterId: json["start_quarter_id"],
    endQuarterId: json["end_quarter_id"],
    startTime: DateTime.parse(json["start_time"]),
    endTime: DateTime.parse(json["end_time"]),
    pricePerSeat: json["price_per_seat"],
    availableSeats: json["available_seats"],
    status: json["status"],
    fromLatitude: json["from_latitude"],
    fromLongitude: json["from_longitude"],
    toLatitude: json["to_latitude"],
    toLongitude: json["to_longitude"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "start_region_id": startRegionId,
    "end_region_id": endRegionId,
    "start_district_id": startDistrictId,
    "end_district_id": endDistrictId,
    "start_quarter_id": startQuarterId,
    "end_quarter_id": endQuarterId,
    "start_time": startTime.toIso8601String(),
    "end_time": endTime.toIso8601String(),
    "price_per_seat": pricePerSeat,
    "available_seats": availableSeats,
    "status": status,
    "from_latitude": fromLatitude,
    "from_longitude": fromLongitude,
    "to_latitude": toLatitude,
    "to_longitude": toLongitude,
  };
}

class BookVehicle {
  int id;
  String model;
  String carNumber;
  int totalSeats;
  BookCarColor color;

  BookVehicle({
    required this.id,
    required this.model,
    required this.carNumber,
    required this.totalSeats,
    required this.color,
  });

  factory BookVehicle.fromJson(Map<String, dynamic> json) => BookVehicle(
    id: json["id"],
    model: json["model"],
    carNumber: json["car_number"],
    totalSeats: json["total_seats"],
    color: BookCarColor.fromJson(json["color"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "model": model,
    "car_number": carNumber,
    "total_seats": totalSeats,
    "color": color.toJson(),
  };
}

class BookCarColor {
  String titleUz;
  String titleRu;
  String titleEn;
  String colorCode;

  BookCarColor({
    required this.titleUz,
    required this.titleRu,
    required this.titleEn,
    required this.colorCode,
  });

  factory BookCarColor.fromJson(Map<String, dynamic> json) => BookCarColor(
    titleUz: json["title_uz"],
    titleRu: json["title_ru"],
    titleEn: json["title_en"],
    colorCode: json["color_code"],
  );

  Map<String, dynamic> toJson() => {
    "title_uz": titleUz,
    "title_ru": titleRu,
    "title_en": titleEn,
    "color_code": colorCode,
  };
}
