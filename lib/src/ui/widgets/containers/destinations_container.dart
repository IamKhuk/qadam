import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/model/trip_model.dart';

import '../../../defaults/defaults.dart';
import '../../../lan_localization/load_places.dart';
import '../../../theme/app_theme.dart';

class DestinationsContainer extends StatelessWidget {
  DestinationsContainer({super.key, required this.trip});

  TripModel trip;
  String weekDay = '';
  String month = '';
  String t1 = '';
  String m1 = '';
  String h1 = '';

  String from = '';
  String to = '';

  initState(DateTime time) {
    m1 = time.minute < 10 ? '0${time.minute}' : time.minute.toString();
    time.weekday == 1
        ? weekDay = 'Monday'
        : time.weekday == 2
            ? weekDay = 'Tuesday'
            : time.weekday == 3
                ? weekDay = 'Wednesday'
                : time.weekday == 4
                    ? weekDay = 'Thursday'
                    : time.weekday == 5
                        ? weekDay = 'Friday'
                        : time.weekday == 6
                            ? weekDay = 'Saturday'
                            : weekDay = 'Sunday';

    time.month == 1
        ? month = 'January'
        : time.month == 2
            ? month = 'February'
            : time.month == 3
                ? month = 'March'
                : time.month == 4
                    ? month = 'April'
                    : time.month == 5
                        ? month = 'May'
                        : time.month == 6
                            ? month = 'June'
                            : time.month == 7
                                ? month = 'July'
                                : time.month == 8
                                    ? month = 'August'
                                    : time.month == 9
                                        ? month = 'September'
                                        : time.month == 10
                                            ? month = 'October'
                                            : time.month == 11
                                                ? month = 'November'
                                                : month = 'December';

    time.hour < 13 ? t1 = 'AM' : t1 = 'PM';
    h1 = time.hour < 13 ? time.hour.toString() : (time.hour - 12).toString();

    from =
        "${LocationData.villages.firstWhere((n) => n.id == trip.startLocation[2].toString()).text}, ${LocationData.cities.firstWhere((c) => c.id == trip.startLocation[1].toString()).text}, ${LocationData.regions.firstWhere((r) => r.id == trip.startLocation[0].toString()).text}";
    to =
        "${LocationData.villages.firstWhere((n) => n.id == trip.endLocation[2].toString()).text}, ${LocationData.cities.firstWhere((c) => c.id == trip.endLocation[1].toString()).text}, ${LocationData.regions.firstWhere((r) => r.id == trip.endLocation[0].toString()).text}";
  }

  @override
  Widget build(BuildContext context) {
    initState(trip.startTime);
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
            color: AppTheme.dark.withOpacity(0.2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.light,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "${trip.availableSeats} ${translate("home.seats_available")}",
                      style: TextStyle(
                        color: trip.availableSeats == 1
                            ? AppTheme.red
                            : trip.availableSeats <= 3
                                ? AppTheme.yellow
                                : AppTheme.green,
                        fontSize: 12,
                        fontFamily: AppTheme.fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                "${trip.pricePerSeat} \$",
                style: const TextStyle(
                  color: AppTheme.black,
                  fontSize: 20,
                  fontFamily: AppTheme.fontFamily,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                "$h1:$m1 $t1",
                style: const TextStyle(
                  color: AppTheme.black,
                  fontSize: 14,
                  fontFamily: AppTheme.fontFamily,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppTheme.black,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                "$weekDay, $month ${trip.startTime.day}",
                style: const TextStyle(
                  color: AppTheme.gray,
                  fontSize: 14,
                  fontFamily: AppTheme.fontFamily,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  // "From" - Circular dot
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppTheme.dark,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // 3 Vertical Lines (Stacked)
                  Column(
                    children: List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Container(
                          width: 2,
                          height: 8, // Adjust height for each line
                          color: AppTheme.gray,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2), // Spacing

                  // "To" - SVG Map Pin
                  SvgPicture.asset(
                    "assets/icons/map_pin.svg",
                    height: 24, // Adjust size as needed
                    width: 24,
                    colorFilter: const ColorFilter.mode(
                      AppTheme.purple,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      from,
                      style: const TextStyle(
                        color: AppTheme.black,
                        fontSize: 16,
                        fontFamily: AppTheme.fontFamily,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      to,
                      style: const TextStyle(
                        color: AppTheme.black,
                        fontSize: 16,
                        fontFamily: AppTheme.fontFamily,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      color: AppTheme.black,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        height: 24,
                        "assets/icons/car.svg",
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Defaults().vehicles[trip.vehicleId].vehicleName,
                    style: const TextStyle(
                      color: AppTheme.black,
                      fontSize: 12,
                      fontFamily: AppTheme.fontFamily,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
