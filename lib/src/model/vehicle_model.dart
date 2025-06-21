import 'dart:ui';
import 'package:qadam/src/theme/app_theme.dart';

import 'color_model.dart';

class VehicleModel{
  int id;
  String vehicleName;
  ColorModel? color;
  int capacity;

  VehicleModel({
    required this.id,
    required this.vehicleName,
    this.color,
    this.capacity = 4,
  });
}