import 'package:flutter/material.dart';
import 'package:qadam/src/model/color_model.dart';
import 'package:qadam/src/model/vehicle_model.dart';
import 'package:qadam/src/theme/app_theme.dart';

import '../model/location_model.dart';
import '../model/trip_model.dart';

class Defaults {
  List<VehicleModel> vehicles = [
    VehicleModel(id: 1, vehicleName: "Lacetti"),
    VehicleModel(id: 2, vehicleName: "Malibu"),
    VehicleModel(id: 3, vehicleName: "Nexia 3"),
    VehicleModel(id: 4, vehicleName: "Damas"),
    VehicleModel(id: 5, vehicleName: "Cobalt"),
    VehicleModel(id: 6, vehicleName: "Captiva"),
    VehicleModel(id: 7, vehicleName: "Spark"),
    VehicleModel(id: 8, vehicleName: "Corolla"),
    VehicleModel(id: 9, vehicleName: "Camry"),
    VehicleModel(id: 10, vehicleName: "Rav4"),
  ];

  List<ColorModel> colors = [
    ColorModel(name: "Red", colorCode: AppTheme.red),
    ColorModel(name: "Green", colorCode: AppTheme.green),
    ColorModel(name: "Blue", colorCode: AppTheme.blue),
    ColorModel(name: "Yellow", colorCode: AppTheme.yellow),
    ColorModel(name: "Purple", colorCode: AppTheme.purple),
    ColorModel(name: "Orange", colorCode: AppTheme.orange),
    ColorModel(name: "Black", colorCode: AppTheme.black),
    ColorModel(name: "White", colorCode: Colors.white),
    ColorModel(name: "Gray", colorCode: AppTheme.gray),
  ];

  List<TripModel> trips = [
    TripModel(
      vehicleId: 2,
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 3, minutes: 30)),
      pricePerSeat: "15",
      availableSeats: 3,
    ),
    TripModel(
      vehicleId: 5,
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 3, minutes: 55)),
      pricePerSeat: "12",
      availableSeats: 4,
    ),
    TripModel(
      vehicleId: 4,
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 4, minutes: 25)),
      pricePerSeat: "18",
      availableSeats: 6,
    ),
    TripModel(
      vehicleId: 8,
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 3, minutes: 15)),
      pricePerSeat: "23",
      availableSeats: 1,
    ),
    TripModel(
      vehicleId: 7,
      startTime: DateTime.now().add(const Duration(days: 1)),
      endTime:
          DateTime.now().add(const Duration(days: 1, hours: 4, minutes: 30)),
      pricePerSeat: "14",
      availableSeats: 2,
    ),
    TripModel(
      vehicleId: 6,
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 3, minutes: 40)),
      pricePerSeat: "19",
      availableSeats: 5,
    ),
  ];
}
