import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/defaults/defaults.dart';
import 'package:qadam/src/model/trip_model.dart';
import 'package:qadam/src/theme/app_theme.dart';
import 'package:qadam/src/ui/widgets/texts/text_12h_400w.dart';
import 'package:qadam/src/ui/widgets/texts/text_14h_500w.dart';
import 'package:qadam/src/ui/widgets/texts/text_16h_500w.dart';
import 'package:qadam/src/utils/utils.dart';

class HistoryContainer extends StatelessWidget {
  const HistoryContainer({super.key, required this.trip});
  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 100,
            spreadRadius: 0,
            color: AppTheme.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text12h400w(
                  title: Utils.historyDateFormat(trip.startTime),
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  color: AppTheme.purple,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text12h400w(
                  title: trip.status == 1
                      ? translate('history.in_progress')
                      : trip.status == 2
                          ? translate('history.completed')
                          : translate('history.canceled'),
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text12h400w(
                      title: Defaults().regions[trip.startLocation[0] - 1].text,
                      color: AppTheme.gray,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      safeSubstring(
                          Defaults()
                              .neighborhoods[trip.startLocation[2] - 1]
                              .text,
                          3),
                      style: const TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.black,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text12h400w(
                      title: Defaults().cities[trip.startLocation[1] - 1].text,
                      color: AppTheme.gray,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.dark,
                          shape: BoxShape.circle,
                        ),
                      ),
                      DottedLine(
                        direction: Axis.horizontal,
                        lineThickness: 2,
                        lineLength:
                            ((MediaQuery.of(context).size.width - 96) / 3 -
                                    40) /
                                2,
                        dashLength: 2,
                        dashColor: AppTheme.gray,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.black,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/car.svg",
                          height: 24, // Adjust size as needed
                          width: 24,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      DottedLine(
                        direction: Axis.horizontal,
                        lineThickness: 2,
                        lineLength:
                            ((MediaQuery.of(context).size.width - 96) / 3 -
                                    40) /
                                2,
                        dashLength: 2,
                        dashColor: AppTheme.gray,
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.dark,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Defaults().vehicles[trip.vehicleId].vehicleName,
                    style: const TextStyle(
                      color: AppTheme.gray,
                      fontSize: 12,
                      fontFamily: AppTheme.fontFamily,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text12h400w(
                      title: Defaults().regions[trip.endLocation[0] - 1].text,
                      color: AppTheme.gray,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      safeSubstring(
                          Defaults()
                              .neighborhoods[trip.endLocation[2] - 1]
                              .text,
                          3),
                      style: const TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.black,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text12h400w(
                      title: Defaults().cities[trip.endLocation[1] - 1].text,
                      color: AppTheme.gray,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text14h500w(
                title: translate("history.price"),
                color: AppTheme.gray,
              ),
              Text16h500w(
                title: "\$${trip.pricePerSeat}",
                color: AppTheme.black,
              ),
            ],
          )
        ],
      ),
    );
  }

  String safeSubstring(String text, int length) {
    return text.length >= length
        ? text.substring(0, length).toUpperCase()
        : text.toUpperCase();
  }
}
