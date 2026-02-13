import 'dart:async';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/model/api/book_model.dart';
import 'package:qadam/src/model/passenger_model.dart';
import 'package:qadam/src/ui/dialogs/center_dialog.dart';
import 'package:qadam/src/ui/menu/home/home_screen.dart';
import 'package:qadam/src/ui/menu/main_screen.dart';
import 'package:qadam/src/ui/menu/profile/top_up_screen.dart';
import 'package:qadam/src/ui/widgets/buttons/primary_button.dart';
import 'package:qadam/src/ui/widgets/texts/text_14h_400w.dart';
import 'package:qadam/src/ui/widgets/texts/text_18h_500w.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../lan_localization/load_places.dart';
import '../../../model/api/trip_list_model.dart';
import '../../../model/location_model.dart';
import '../../../resources/repository.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/utils.dart';
import '../../dialogs/snack_bar.dart';
import '../../widgets/containers/leading_back.dart';
import '../../widgets/texts/text_12h_400w.dart';
import '../../widgets/texts/text_16h_500w.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.trip,
    this.passengersNum = 1,
    required this.passengers,
  });

  final TripListModel trip;
  final int passengersNum;
  final List<PassengerModel> passengers;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const int _paymentTimeoutSeconds = 720;

  String weekDay = '';
  String month = '';
  String t1 = '';
  String m1 = '';
  String h1 = '';
  String seconds = "00";
  int _remainingSeconds = _paymentTimeoutSeconds;
  Timer? _countdownTimer;
  String pricePerSeat = "";
  String balance = "";

  String fromRegion = "";
  String fromCity = "";
  String fromNeighborhood = "";
  String toRegion = "";
  String toCity = "";
  String toNeighborhood = "";
  String from = "";
  String to = "";

  bool isLoading = false;

  final Repository _repository = Repository();

  @override
  void initState() {
    super.initState();
    if (widget.trip.pricePerSeat.contains(".")) {
      pricePerSeat = widget.trip.pricePerSeat.split(".")[0];
    } else {
      pricePerSeat = widget.trip.pricePerSeat;
    }
    _startTimer();
    initTimeState(widget.trip.startTime);
    getBalance();
    setLocations();
  }

  static final _unknownLocation = LocationModel(id: "0", text: "—", parentID: "0");

  void setLocations() {
    fromRegion = LocationData.regions
        .firstWhere((r) => r.id == widget.trip.fromRegionId.toString(),
            orElse: () => _unknownLocation)
        .text;
    fromCity = LocationData.cities
        .firstWhere((c) => c.id == widget.trip.fromCityId.toString(),
            orElse: () => _unknownLocation)
        .text;
    fromNeighborhood = LocationData.villages
        .firstWhere((n) => n.id == widget.trip.fromVillageId.toString(),
            orElse: () => _unknownLocation)
        .text;

    toRegion = LocationData.regions
        .firstWhere((r) => r.id == widget.trip.toRegionId.toString(),
            orElse: () => _unknownLocation)
        .text;
    toCity = LocationData.cities
        .firstWhere((c) => c.id == widget.trip.toCityId.toString(),
            orElse: () => _unknownLocation)
        .text;
    toNeighborhood = LocationData.villages
        .firstWhere((n) => n.id == widget.trip.toVillageId.toString(),
            orElse: () => _unknownLocation)
        .text;

    from = "$fromNeighborhood, $fromCity, $fromRegion";
    to = "$toNeighborhood, $toCity, $toRegion";
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        if (mounted) {
          setState(() {
            _remainingSeconds--;
            seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
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
                    bottom: 100,
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
                                      color: _remainingSeconds < 30
                                          ? AppTheme.red
                                          : AppTheme.purple,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text14h400w(
                                      title: (_remainingSeconds ~/ 60)
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
                                      color: _remainingSeconds < 30
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
                                      title: fromRegion,
                                      color: AppTheme.gray,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      safeSubstring(fromNeighborhood, 3),
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
                                      title: fromCity,
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
                                    widget.trip.vehicle.model,
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
                                    Text(
                                      toRegion,
                                      style: const TextStyle(
                                        fontFamily: AppTheme.fontFamily,
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        height: 1.5,
                                        color: AppTheme.gray,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      safeSubstring(toNeighborhood, 3),
                                      style: const TextStyle(
                                        fontFamily: AppTheme.fontFamily,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.black,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      toCity,
                                      style: const TextStyle(
                                        fontFamily: AppTheme.fontFamily,
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        height: 1.5,
                                        color: AppTheme.gray,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.blue, width: 1),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outlined,
                            color: AppTheme.blue,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text14h400w(
                              title: translate("home.payment_info"),
                              color: AppTheme.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text16h500w(
                                    title: translate("profile.my_balance")),
                                const SizedBox(height: 16),
                                Text18h500w(
                                    title:
                                        "${Utils.priceFormat(balance)} ${translate("currency")}")
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TopUpScreen(),
                                ),
                              ).then((_) {
                                getBalance();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.purple,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Text14h400w(
                                    title: translate("profile.top_up"),
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.monetization_on_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text16h500w(title: translate("home.payment")),
                    const SizedBox(height: 16),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text14h400w(
                                    title: translate("home.number_passenger"),
                                    color: AppTheme.gray,
                                  ),
                                  const SizedBox(height: 4),
                                  Text16h500w(
                                      title: "${widget.passengersNum}x"),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text14h400w(
                                    title: translate("home.price_per_seat"),
                                    color: AppTheme.gray,
                                  ),
                                  const SizedBox(height: 4),
                                  Text16h500w(
                                    title:
                                        "${Utils.priceFormat(pricePerSeat)} ${translate("currency")}",
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const DottedLine(
                            dashColor: AppTheme.gray,
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 1,
                            dashLength: 4,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text16h500w(
                                title: "${translate("home.total_price")}:",
                                color: AppTheme.gray,
                              ),
                              Text(
                                "${Utils.priceFormat((int.parse(pricePerSeat) * widget.passengersNum).toString())} ${translate("currency")}",
                                style: const TextStyle(
                                  color: AppTheme.black,
                                  fontSize: 20,
                                  fontFamily: AppTheme.fontFamily,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 32,
                ),
                child: GestureDetector(
                  onTap: () async {
                    if (_remainingSeconds > 0) {
                      if (Utils().stringToInt(balance) >
                          Utils().stringToInt(Utils.priceFormat(
                              (int.parse(pricePerSeat) * widget.passengersNum)
                                  .toString()))) {
                        if (!mounted) return;
                        setState(() {
                          isLoading = true;
                        });
                        var response = await _repository.fetchBookTrip(
                            widget.trip.id.toString(), widget.passengers);

                        if (!mounted) return;

                        if (response.isSuccess) {
                          var result = BookModel.fromJson(response.result);
                          setState(() {
                            isLoading = false;
                          });
                          if (result.status == "confirmed") {
                            CustomSnackBar().showSnackBar(
                              context,
                              translate("qadam.booking_success"),
                              1,
                            );
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString("active_booked_id",
                                result.bookingId.toString());
                            if (!mounted) return;
                            Navigator.of(context).popUntil(
                              (route) => route.isFirst,
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const MainScreen();
                                },
                              ),
                            );
                          } else {
                            CenterDialog.showActionFailed(
                              context,
                              translate("qadam.booking_failed"),
                              translate("qadam.booking_failed_msg"),
                            );
                          }
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          if (response.status == -1) {
                            CenterDialog.showActionFailed(
                              context,
                              translate("auth.connection_failed"),
                              translate("auth.connection_failed_msg"),
                            );
                          } else {
                            CenterDialog.showActionFailed(
                              context,
                              translate("auth.something_went_wrong"),
                              translate("auth.failed_msg"),
                            );
                          }
                        }
                      } else {
                        CenterDialog.showActionFailed(
                          context,
                          translate("qadam.not_enough_balance"),
                          translate("qadam.not_enough_balance_msg"),
                        );
                      }
                    } else {
                      CenterDialog.showActionFailed(
                        context,
                        translate("qadam.time_is_up"),
                        translate("qadam.time_is_up_msg"),
                      );
                    }
                  },
                  child: PrimaryButton(
                    title: translate("home.confirm_payment"),
                  ),
                ),
              ),
            ],
          ),
          isLoading == true
              ? Container(
                  color: AppTheme.black.withOpacity(0.45),
                  child: Center(
                    child: Container(
                      height: 96,
                      width: 96,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
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
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppTheme.purple),
                        ),
                      ),
                    ),
                  ),
                )
              : Container()
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

  Future<void> getBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        balance = prefs.getString('balance') ?? "0";
      });
    }
  }
}
