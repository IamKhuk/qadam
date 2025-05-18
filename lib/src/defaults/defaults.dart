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

  List<LocationModel> locations = [
    LocationModel(id: 1, text: "Samarkand"),
    LocationModel(id: 2, text: "Samarkand city"),
    LocationModel(id: 3, text: "Urgut"),
    LocationModel(id: 4, text: "Tashkent"),
    LocationModel(id: 5, text: "Tashkent city"),
    LocationModel(id: 6, text: "Yunusobod"),
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

  List<LocationModel> regions = [
    LocationModel(id: 1, text: "Tashkent"),
    LocationModel(id: 2, text: "Samarkand"),
    LocationModel(id: 3, text: "Andijon"),
    LocationModel(id: 4, text: "Farg'ona"),
    LocationModel(id: 5, text: "Namangan"),
    LocationModel(id: 6, text: "Jizzax"),
    LocationModel(id: 7, text: "Sirdaryo"),
    LocationModel(id: 8, text: "Surxondaryo"),
    LocationModel(id: 9, text: "Qashqadaryo"),
    LocationModel(id: 10, text: "Buxoro"),
    LocationModel(id: 11, text: "Xorazm"),
    LocationModel(id: 12, text: "Navoiy"),
  ];

  List<LocationModel> cities = [
    LocationModel(id: 1, text: "Tashkent"),
    LocationModel(id: 2, text: "Samarkand"),
    LocationModel(id: 3, text: "Andijon"),
    LocationModel(id: 4, text: "Farg'ona"),
    LocationModel(id: 5, text: "Namangan"),
    LocationModel(id: 6, text: "Jizzax"),
    LocationModel(id: 7, text: "Sirdaryo"),
    LocationModel(id: 8, text: "Urgut"),
    LocationModel(id: 9, text: "Kattaq\'o\'rg\'on"),
    LocationModel(id: 10, text: "Angren"),
    LocationModel(id: 11, text: "Qarshi"),
    LocationModel(id: 12, text: "Navoiy"),
    LocationModel(id: 13, text: "Bukhara"),
    LocationModel(id: 14, text: "Oltinbozor"),
    LocationModel(id: 15, text: "Urganch"),
    LocationModel(id: 16, text: "Nukus"),
    LocationModel(id: 17, text: "Termiz"),
  ];

  List<LocationModel> neighborhoods = [
    LocationModel(id: 1, text: "Magnitobod"),
    LocationModel(id: 2, text: "Yunusobod"),
    LocationModel(id: 3, text: "Shayxontohur"),
    LocationModel(id: 4, text: "Olmazor"),
    LocationModel(id: 5, text: "Chilonzor"),
    LocationModel(id: 6, text: "Qorasuv"),
    LocationModel(id: 7, text: "Magnitobod"),
    LocationModel(id: 8, text: "Yunusobod"),
    LocationModel(id: 9, text: "Shayxontohur"),
    LocationModel(id: 10, text: "Olmazor"),
    LocationModel(id: 11, text: "Chilonzor"),
    LocationModel(id: 12, text: "Qorasuv"),
    LocationModel(id: 13, text: "Magnitobod"),
    LocationModel(id: 14, text: "Yunusobod"),
    LocationModel(id: 15, text: "Shayxontohur"),
    LocationModel(id: 16, text: "Olmazor"),
    LocationModel(id: 17, text: "Chilonzor"),
    LocationModel(id: 18, text: "Qorasuv"),
  ];
}
