import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/model/api/book_model.dart';
import 'package:qadam/src/theme/app_theme.dart';
import 'package:qadam/src/ui/widgets/texts/text_12h_400w.dart';
import 'package:qadam/src/ui/widgets/texts/text_14h_500w.dart';
import 'package:qadam/src/ui/widgets/texts/text_16h_500w.dart';
import 'package:qadam/src/utils/utils.dart';

import '../../../lan_localization/load_places.dart';

class HistoryContainer extends StatelessWidget {
  const HistoryContainer({super.key, required this.booking});

  final BookModel booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            blurRadius: 25,
            spreadRadius: 0,
            color: AppTheme.dark.withOpacity(0.4),
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
                  title: Utils.historyDateFormat(booking.trip.startTime),
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  color: _statusColor(booking.status),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text12h400w(
                  title: _statusText(booking.status),
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
                      title: _findLocationText(
                        LocationData.regions,
                        booking.trip.startRegionId.toString(),
                      ),
                      color: AppTheme.gray,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      safeSubstring(
                          _findLocationText(
                            LocationData.villages,
                            booking.trip.startQuarterId.toString(),
                          ),
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
                      title: _findLocationText(
                        LocationData.cities,
                        booking.trip.startDistrictId.toString(),
                      ),
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
                          height: 24,
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
                    booking.vehicle.model,
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
                      title: _findLocationText(
                        LocationData.regions,
                        booking.trip.endRegionId.toString(),
                      ),
                      color: AppTheme.gray,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      safeSubstring(
                          _findLocationText(
                            LocationData.villages,
                            booking.trip.endQuarterId.toString(),
                          ),
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
                      title: _findLocationText(
                        LocationData.cities,
                        booking.trip.endDistrictId.toString(),
                      ),
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
                title: "${Utils.priceFormat(booking.totalPrice)} UZS",
                color: AppTheme.black,
              ),
            ],
          )
        ],
      ),
    );
  }

  String _findLocationText(List locations, String id) {
    try {
      return locations.firstWhere((item) => item.id == id).text;
    } catch (_) {
      return '---';
    }
  }

  String _statusText(String status) {
    switch (status.toLowerCase()) {
      case 'in_progress':
      case 'confirmed':
        return translate('history.in_progress');
      case 'completed':
        return translate('history.completed');
      case 'canceled':
      case 'cancelled':
        return translate('history.canceled');
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in_progress':
      case 'confirmed':
        return AppTheme.purple;
      case 'completed':
        return const Color(0xFF4CAF50);
      case 'canceled':
      case 'cancelled':
        return const Color(0xFFE53935);
      default:
        return AppTheme.purple;
    }
  }

  String safeSubstring(String text, int length) {
    return text.length >= length
        ? text.substring(0, length).toUpperCase()
        : text.toUpperCase();
  }
}
