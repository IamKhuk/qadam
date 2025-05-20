import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/model/trip_model.dart';
import 'package:qadam/src/ui/widgets/texts/text_14h_400w.dart';
import 'package:qadam/src/ui/widgets/texts/text_14h_500w.dart';

import '../../../defaults/defaults.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/containers/leading_back.dart';
import '../../widgets/texts/text_12h_400w.dart';
import '../../widgets/texts/text_16h_500w.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.trip});

  final TripModel trip;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String weekDay = '';
  String month = '';
  String t1 = '';
  String m1 = '';
  String h1 = '';
  String seconds = "00";
  int _timer = 300;

  @override
  void initState() {
    super.initState();
    startTimer();
    initTimeState(widget.trip.startTime);
  }

  void startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_timer > 0) {
        setState(() {
          _timer--;
          updateTimerDisplay();
        });
        startTimer();
      } else {
        // Timer finished
        if (kDebugMode) {
          print("Timer finished!");
          Navigator.pop(context);
        }
      }
    });
  }

  void updateTimerDisplay() {
    int minutes = _timer ~/ 60;
    int remainingSeconds = _timer % 60;
    // m1 = minutes.toString().padLeft(1, '0'); // Commented out as per instruction
    seconds = remainingSeconds.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const LeadingBack(),
        title: Text16h500w(title: translate("home.payment_details")),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(
                    top: 22,
                    left: 16,
                    right: 16,
                    bottom: 24,
                  ),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.dark.withOpacity(0.1),
                            spreadRadius: 15,
                            blurRadius: 25,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text14h400w(
                                  title:
                                      translate("home.complete_payment_within"),
                                  color: AppTheme.gray,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _timer < 30
                                          ? AppTheme.red
                                          : AppTheme.purple,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text14h400w(
                                      title: (_timer ~/ 60)
                                          .toString()
                                          .padLeft(2, '0'),
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.black,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _timer < 30
                                          ? AppTheme.red
                                          : AppTheme.purple,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text14h400w(
                                      title: seconds,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: AppTheme.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Text(
                                "$weekDay, $month ${widget.trip.startTime.day}",
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text12h400w(
                                      title: Defaults()
                                          .regions[
                                              widget.trip.startLocation[0] - 1]
                                          .text,
                                      color: AppTheme.gray,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      safeSubstring(
                                          Defaults()
                                              .neighborhoods[
                                                  widget.trip.startLocation[2] -
                                                      1]
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
                                      title: Defaults()
                                          .cities[
                                              widget.trip.startLocation[1] - 1]
                                          .text,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                        lineLength: ((MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        96) /
                                                    3 -
                                                40) /
                                            2,
                                        dashLength: 2,
                                        dashColor: AppTheme.gray,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppTheme.black,
                                          borderRadius:
                                              BorderRadius.circular(24),
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
                                        lineLength: ((MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        96) /
                                                    3 -
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
                                    Defaults()
                                        .vehicles[widget.trip.vehicleId]
                                        .vehicleName,
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
                                      title: Defaults()
                                          .regions[
                                              widget.trip.endLocation[0] - 1]
                                          .text,
                                      color: AppTheme.gray,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      safeSubstring(
                                          Defaults()
                                              .neighborhoods[
                                                  widget.trip.endLocation[2] -
                                                      1]
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
                                      title: Defaults()
                                          .cities[
                                              widget.trip.endLocation[1] - 1]
                                          .text,
                                      color: AppTheme.gray,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text16h500w(title: translate("home.payment")),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  initTimeState(DateTime time) {
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
  }

  String safeSubstring(String text, int length) {
    return text.length >= length
        ? text.substring(0, length).toUpperCase()
        : text.toUpperCase();
  }
}
