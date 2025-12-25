import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/model/vehicle_model.dart';
import 'package:qadam/src/theme/app_theme.dart';
import 'package:qadam/src/ui/widgets/texts/text_12h_400w.dart';
import 'package:qadam/src/ui/widgets/texts/text_14h_400w.dart';
import 'package:qadam/src/ui/widgets/texts/text_14h_500w.dart';

class CarContainer extends StatelessWidget {
  const CarContainer({
    super.key,
    required this.car,
  });

  final VehicleModel car;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.light,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.directions_car,
                color: AppTheme.purple, size: 24),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text14h500w(title: car.vehicleName),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text12h400w(
                    title: "${translate("qadam.vehicle_capacity")}:  ",
                    color: AppTheme.gray,
                  ),
                  Text14h400w(
                      title:
                          "${car.capacity} ${translate("qadam.passengers")}"),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text12h400w(
                    title: "${translate("profile.car_color")}:  ",
                    color: AppTheme.gray,
                  ),
                  Text14h400w(title: "${car.color?.titleEn}  "),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: car.color?.colorCode,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
