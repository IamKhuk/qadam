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
    ColorModel(id: 1, titleEn: "Red", titleRu: "Красный", titleUz: "Qizil", colorCode: Color(0xFFFF0000)),
    ColorModel(id: 2, titleEn: "Green", titleRu: "Зелёный", titleUz: "Yashil", colorCode: Color(0xFF00FF00)),
    ColorModel(id: 3, titleEn: "Blue", titleRu: "Синий", titleUz: "Ko'k", colorCode: Color(0xFF0000FF)),
    ColorModel(id: 4, titleEn: "Yellow", titleRu: "Жёлтый", titleUz: "Sariq", colorCode: Color(0xFFFFFF00)),
    ColorModel(id: 5, titleEn: "Black", titleRu: "Чёрный", titleUz: "Qora", colorCode: Color(0xFF000000)),
    ColorModel(id: 6, titleEn: "White", titleRu: "Белый", titleUz: "Oq", colorCode: Color(0xFFFFFFFF)),
    ColorModel(id: 7, titleEn: "Gray", titleRu: "Серый", titleUz: "Kulrang", colorCode: Color(0xFF808080)),
    ColorModel(id: 8, titleEn: "Navy", titleRu: "Морской", titleUz: "To‘q ko‘k", colorCode: Color(0xFF000080)),
    ColorModel(id: 9, titleEn: "Brown", titleRu: "Коричневый", titleUz: "Jigarrang", colorCode: Color(0xFFA52A2A)),
    ColorModel(id: 10, titleEn: "Dark Green", titleRu: "Тёмно-зелёный", titleUz: "To‘q yashil", colorCode: Color(0xFF006400)),
    ColorModel(id: 11, titleEn: "Maroon", titleRu: "Бордовый", titleUz: "Olcha", colorCode: Color(0xFF800000)),
    ColorModel(id: 12, titleEn: "Olive", titleRu: "Оливковый", titleUz: "Zaytun", colorCode: Color(0xFF808000)),
    ColorModel(id: 13, titleEn: "Silver", titleRu: "Серебряный", titleUz: "Kumush", colorCode: Color(0xFFC0C0C0)),
    ColorModel(id: 14, titleEn: "Orange", titleRu: "Оранжевый", titleUz: "Olovrang", colorCode: Color(0xFFFFA500)),
    ColorModel(id: 15, titleEn: "Purple", titleRu: "Пурпурный", titleUz: "Siyohrang", colorCode: Color(0xFF800080)),
    ColorModel(id: 16, titleEn: "Pink", titleRu: "Розовый", titleUz: "Pushti", colorCode: Color(0xFFFFC0CB)),
    ColorModel(id: 17, titleEn: "Teal", titleRu: "Бирюзовый", titleUz: "Ko‘k-yashil", colorCode: Color(0xFF008080)),
    ColorModel(id: 18, titleEn: "Aqua", titleRu: "Аква", titleUz: "Aqua", colorCode: Color(0xFF00FFFF)),
    ColorModel(id: 19, titleEn: "Peach", titleRu: "Персиковый", titleUz: "Shaftoli", colorCode: Color(0xFFFFDAB9)),
    ColorModel(id: 20, titleEn: "Gold", titleRu: "Золотой", titleUz: "Oltin", colorCode: Color(0xFFFFD700)),
    ColorModel(id: 21, titleEn: "Beige", titleRu: "Бежевый", titleUz: "Bej", colorCode: Color(0xFFF5F5DC)),
    ColorModel(id: 22, titleEn: "Chocolate", titleRu: "Шоколадный", titleUz: "Shokolad", colorCode: Color(0xFFD2691E)),
    ColorModel(id: 23, titleEn: "Caramel", titleRu: "Карамельный", titleUz: "Karamel", colorCode: Color(0xFFAF6E4D)),
    ColorModel(id: 24, titleEn: "Sunshine", titleRu: "Солнечный", titleUz: "Quyosh", colorCode: Color(0xFFFFD300)),
    ColorModel(id: 25, titleEn: "Sea wave", titleRu: "Морская волна", titleUz: "Dengiz to‘lqini", colorCode: Color(0xFF2E8B57)),
    ColorModel(id: 26, titleEn: "Magenta", titleRu: "Фуксия", titleUz: "Pushti binafsha", colorCode: Color(0xFFFF00FF)),
    ColorModel(id: 27, titleEn: "Ivory", titleRu: "Слоновая кость", titleUz: "Qaymoqrang", colorCode: Color(0xFFFFFFF0)),
    ColorModel(id: 28, titleEn: "Indigo", titleRu: "Индиго", titleUz: "Jigar binafsha", colorCode: Color(0xFF4B0082)),
    ColorModel(id: 29, titleEn: "Sky Blue", titleRu: "Небесно-голубой", titleUz: "Zangori", colorCode: Color(0xFF87CEEB)),
    ColorModel(id: 30, titleEn: "Dark Gray", titleRu: "Тёмно-серый", titleUz: "To‘q kulrang", colorCode: Color(0xFFA9A9A9)),
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
