import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qadam/src/model/trip_model.dart';

import '../../../defaults/defaults.dart';
import '../../../lan_localization/load_places.dart';
import '../../../theme/app_theme.dart';

class ActiveTripsContainer extends StatefulWidget {
  const ActiveTripsContainer({super.key, required this.trip});

  final TripModel trip;

  @override
  State<ActiveTripsContainer> createState() => _ActiveTripsContainerState();
}

class _ActiveTripsContainerState extends State<ActiveTripsContainer> {
  String weekDay1 = '';
  String month1 = '';
  String month2 = '';
  String weedDay2 = '';

  String t1 = '';
  String m1 = '';
  String h1 = '';
  String t2 = '';
  String m2 = '';
  String h2 = '';

  String from = '';
  String to = '';

  void init(DateTime time1, DateTime time2) {
    m1 = time1.minute < 10 ? '0${time1.minute}' : time1.minute.toString();
    m2 = time2.minute < 10 ? '0${time2.minute}' : time2.minute.toString();
    time1.weekday == 1
        ? weekDay1 = 'Monday'
        : time1.weekday == 2
            ? weekDay1 = 'Tuesday'
            : time1.weekday == 3
                ? weekDay1 = 'Wednesday'
                : time1.weekday == 4
                    ? weekDay1 = 'Thursday'
                    : time1.weekday == 5
                        ? weekDay1 = 'Friday'
                        : time1.weekday == 6
                            ? weekDay1 = 'Saturday'
                            : weekDay1 = 'Sunday';

    time2.weekday == 1
        ? weedDay2 = 'Monday'
        : time2.weekday == 2
            ? weedDay2 = 'Tuesday'
            : time2.weekday == 3
                ? weedDay2 = 'Wednesday'
                : time2.weekday == 4
                    ? weedDay2 = 'Thursday'
                    : time2.weekday == 5
                        ? weedDay2 = 'Friday'
                        : time2.weekday == 6
                            ? weedDay2 = 'Saturday'
                            : weedDay2 = 'Sunday';

    time1.month == 1
        ? month1 = 'January'
        : time1.month == 2
            ? month1 = 'February'
            : time1.month == 3
                ? month1 = 'March'
                : time1.month == 4
                    ? month1 = 'April'
                    : time1.month == 5
                        ? month1 = 'May'
                        : time1.month == 6
                            ? month1 = 'June'
                            : time1.month == 7
                                ? month1 = 'July'
                                : time1.month == 8
                                    ? month1 = 'August'
                                    : time1.month == 9
                                        ? month1 = 'September'
                                        : time1.month == 10
                                            ? month1 = 'October'
                                            : time1.month == 11
                                                ? month1 = 'November'
                                                : month1 = 'December';

    time2.month == 1
        ? month2 = 'January'
        : time2.month == 2
            ? month2 = 'February'
            : time2.month == 3
                ? month2 = 'March'
                : time2.month == 4
                    ? month2 = 'April'
                    : time2.month == 5
                        ? month2 = 'May'
                        : time2.month == 6
                            ? month2 = 'June'
                            : time2.month == 7
                                ? month2 = 'July'
                                : time2.month == 8
                                    ? month2 = 'August'
                                    : time2.month == 9
                                        ? month2 = 'September'
                                        : time2.month == 10
                                            ? month2 = 'October'
                                            : time2.month == 11
                                                ? month2 = 'November'
                                                : month2 = 'December';

    time1.hour < 13 ? t1 = 'AM' : t1 = 'PM';
    time2.hour < 13 ? t2 = 'AM' : t2 = 'PM';
    h1 = time1.hour < 13 ? time1.hour.toString() : (time1.hour - 12).toString();
    h2 = time2.hour < 13 ? time2.hour.toString() : (time2.hour - 12).toString();
  }

  @override
  void initState() {
    init(widget.trip.startTime, widget.trip.endTime);
    from =
    "${LocationData.villages.firstWhere((n) => n.id == widget.trip.startLocation[2].toString()).text}, ${LocationData.cities.firstWhere((c) => c.id == widget.trip.startLocation[1].toString()).text}, ${LocationData.regions.firstWhere((r) => r.id == widget.trip.startLocation[0].toString()).text}";
    to =
    "${LocationData.villages.firstWhere((n) => n.id == widget.trip.endLocation[2].toString()).text}, ${LocationData.cities.firstWhere((c) => c.id == widget.trip.endLocation[1].toString()).text}, ${LocationData.regions.firstWhere((r) => r.id == widget.trip.endLocation[0].toString()).text}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.purple,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            blurRadius: 25,
            spreadRadius: 0,
            color: AppTheme.purple.withOpacity(0.45),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Text(
              "$h1:$m1 $t1 - $h2:$m2 $t2",
              style: const TextStyle(
                color: Colors.white,
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
                color: AppTheme.light,
                shape: BoxShape.circle,
              ),
            ),
            Text(
              "$weekDay1, $month1 ${widget.trip.startTime.day}",
              style: const TextStyle(
                color: AppTheme.light,
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
                    color: AppTheme.light,
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
                        color: AppTheme.light,
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
                    Colors.white,
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
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: AppTheme.fontFamily,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    to,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
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
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      height: 24,
                      "assets/icons/car.svg",
                      colorFilter: const ColorFilter.mode(
                        AppTheme.purple,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  Defaults().vehicles[widget.trip.vehicleId].vehicleName,
                  style: const TextStyle(
                    color: AppTheme.light,
                    fontSize: 12,
                    fontFamily: AppTheme.fontFamily,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
