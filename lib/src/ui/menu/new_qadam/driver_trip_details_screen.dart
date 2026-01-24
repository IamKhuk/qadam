import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:qadam/src/model/api/driver_trips_list_model.dart';
import 'package:qadam/src/model/passenger_info_model.dart';
import 'package:qadam/src/ui/dialogs/bottom_dialog.dart';
import 'package:qadam/src/ui/dialogs/center_dialog.dart';
import 'package:qadam/src/ui/menu/home/map_single_screen.dart';
import 'package:qadam/src/ui/widgets/buttons/secondary_button.dart';
import 'package:qadam/src/ui/widgets/containers/leading_back.dart';
import 'package:qadam/src/ui/widgets/containers/passengers_container.dart';
import 'package:qadam/src/ui/widgets/texts/text_14h_400w.dart';
import 'package:qadam/src/ui/widgets/texts/text_16h_500w.dart';
import 'package:qadam/src/utils/utils.dart';
import '../../../lan_localization/load_places.dart';
import '../../../model/passenger_model.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/texts/text_12h_400w.dart';
import '../home/map_route_screen.dart';

class DriverTripDetailsScreen extends StatefulWidget {
  const DriverTripDetailsScreen({
    super.key,
    required this.trip,
  });

  final DriverTripModel trip;

  @override
  State<DriverTripDetailsScreen> createState() =>
      _DriverTripDetailsScreenState();
}

class _DriverTripDetailsScreenState extends State<DriverTripDetailsScreen> {
  String pricePerSeat = "";
  int passengersNum = 1;

  String weekDay = '';
  String month = '';
  String t1 = '';
  String m1 = '';
  String h1 = '';

  String from = '';
  String to = '';

  String fromRegion = "";
  String fromCity = "";
  String fromNeighborhood = "";
  String toRegion = "";
  String toCity = "";
  String toNeighborhood = "";

  @override
  void initState() {
    if (widget.trip.pricePerSeat.contains(".")) {
      pricePerSeat = widget.trip.pricePerSeat.split(".")[0];
    } else {
      pricePerSeat = widget.trip.pricePerSeat;
    }
    initTimeState(widget.trip.startTime);
    setLocations();
    super.initState();
  }

  void setLocations() {
    fromRegion = LocationData.regions
        .firstWhere((r) => r.id == widget.trip.fromRegionId.toString())
        .text;
    fromCity = LocationData.cities
        .firstWhere((c) => c.id == widget.trip.fromCityId.toString())
        .text;
    fromNeighborhood = LocationData.villages
        .firstWhere((n) => n.id == widget.trip.fromVillageId.toString())
        .text;

    toRegion = LocationData.regions
        .firstWhere((r) => r.id == widget.trip.toRegionId.toString())
        .text;
    toCity = LocationData.cities
        .firstWhere((c) => c.id == widget.trip.toCityId.toString())
        .text;
    toNeighborhood = LocationData.villages
        .firstWhere((n) => n.id == widget.trip.toVillageId.toString())
        .text;

    from = "$fromNeighborhood, $fromCity, $fromRegion";
    to = "$toNeighborhood, $toCity, $toRegion";
  }

  List<PassengerInfoModel> passengersList = [
    PassengerInfoModel(fullName: "John Smith", phone: "998970010707"),
    PassengerInfoModel(
      fullName: "Bob Johnson",
      phone: "998931234567",
      numberOfSeats: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const LeadingBack(),
        title: Text16h500w(title: translate("home.trip_details")),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
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
                                        ((MediaQuery.of(context).size.width -
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
                                        ((MediaQuery.of(context).size.width -
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
                const SizedBox(height: 24),
                Text16h500w(title: translate("home.details")),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text14h400w(
                                  title: translate("home.travelling_from"),
                                  color: AppTheme.gray,
                                ),
                                const SizedBox(height: 4),
                                Text16h500w(
                                  title: from,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapSingleScreen(
                                    location: LatLng(
                                      double.parse(widget.trip.startLat),
                                      double.parse(widget.trip.startLong),
                                    ),
                                    place: from,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.light,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/map_pin.svg",
                                height: 24,
                                width: 24,
                                colorFilter: const ColorFilter.mode(
                                  AppTheme.black,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text14h400w(
                                  title: translate("home.where_to"),
                                  color: AppTheme.gray,
                                ),
                                const SizedBox(height: 4),
                                Text16h500w(
                                  title: to,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapSingleScreen(
                                    location: LatLng(
                                      double.parse(widget.trip.endLat),
                                      double.parse(widget.trip.endLong),
                                    ),
                                    place: to,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.light,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/map_pin.svg",
                                height: 24,
                                width: 24,
                                colorFilter: const ColorFilter.mode(
                                  AppTheme.black,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text14h400w(
                            title: translate("home.departure_date"),
                            color: AppTheme.gray,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text14h400w(
                                title: Utils.scheduleDateFormat(
                                    widget.trip.startTime),
                                color: AppTheme.gray,
                              ),
                              const SizedBox(height: 4),
                              Text16h500w(
                                title:
                                    "${widget.trip.startTime.hour}:${widget.trip.startTime.minute} ${widget.trip.startTime.hour < 13 ? 'AM' : 'PM'}",
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text14h400w(
                            title: translate("home.arrival_date"),
                            color: AppTheme.gray,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text14h400w(
                                title: Utils.scheduleDateFormat(
                                    widget.trip.startTime),
                                color: AppTheme.gray,
                              ),
                              const SizedBox(height: 4),
                              Text16h500w(
                                title:
                                    "${widget.trip.endTime.hour}:${widget.trip.endTime.minute} ${widget.trip.endTime.hour < 13 ? 'AM' : 'PM'}",
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text14h400w(
                                title: translate("home.available_seats"),
                                color: AppTheme.gray,
                              ),
                              const SizedBox(height: 4),
                              Text16h500w(
                                  title: "${widget.trip.availableSeats}x"),
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
                                      "${Utils.priceFormat(pricePerSeat)} ${translate("currency")}"),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      SecondaryButton(
                        title: translate("home.view_route_map"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MapRouteScreen(
                                  start: LatLng(
                                      double.parse(widget.trip.startLat),
                                      double.parse(widget.trip.startLong)),
                                  end: LatLng(double.parse(widget.trip.endLat),
                                      double.parse(widget.trip.endLong)),
                                  startText: from,
                                  endText: to,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text16h500w(title: translate("home.passenger_info")),
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
                        children: [
                          Expanded(
                            child: Text14h400w(
                              title: translate("home.number_passenger"),
                              color: AppTheme.gray,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text16h500w(title: passengersNum.toString()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: passengersList.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      size: 24,
                                      color: AppTheme.black,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text14h400w(
                                        title: passengersList[index].fullName,
                                        color: AppTheme.black,
                                      ),
                                      const SizedBox(height: 4),
                                      Text14h400w(
                                        title: passengersList[index].phone,
                                        color: AppTheme.gray,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              index == passengersList.length - 1? const SizedBox(): const Divider(),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              bottom: 32,
              top: 24,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
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
                  children: [
                    Text16h500w(
                      title: "${translate("home.total_price")}:",
                      color: AppTheme.gray,
                    ),
                    Text(
                      "${Utils.priceFormat((int.parse(pricePerSeat) * passengersNum).toString())} ${translate("currency")}",
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
                const SizedBox(height: 16),
                SecondaryButton(
                  title: translate("qadam.edit_trip"),
                  onTap: () {},
                ),
              ],
            ),
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
