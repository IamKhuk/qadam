import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/bloc/home_bloc.dart';
import 'package:qadam/src/lan_localization/load_places.dart';
import 'package:qadam/src/model/api/trip_list_model.dart';
import 'package:qadam/src/model/location_model.dart';
import 'package:qadam/src/ui/dialogs/bottom_dialog.dart';
import 'package:qadam/src/ui/dialogs/center_dialog.dart';
import 'package:qadam/src/ui/menu/home/search_result_screen.dart';
import 'package:qadam/src/ui/menu/home/trip_details_screen.dart';
import 'package:qadam/src/ui/widgets/containers/active_trips_container.dart';
import 'package:qadam/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';

import '../../../bloc/profile_bloc.dart';
import '../../../defaults/defaults.dart';
import '../../../model/trip_model.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/containers/destinations_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController scrollController = ScrollController();

  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController departureController = TextEditingController();
  TextEditingController returnController = TextEditingController();

  String activeTripId = "0";
  String activeBookedId = "0";

  String from = "";
  String to = "";
  String departure = "";
  String returnDate = "";

  bool isDocsAdded = false;
  bool isDocsVerified = false;

  Future<void> getDriverStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDocsAdded = prefs.getBool('isDocsAdded') ?? false;
      isDocsVerified = prefs.getString('driving_verification_status') == "approved" ? true: false;
    });
  }

  List<TripModel> myTrips = [];

  LocationModel fromRegion = LocationModel(id: "0", text: "", parentID: '');
  LocationModel fromCity = LocationModel(id: "0", text: "", parentID: '');
  LocationModel fromNeighborhood =
      LocationModel(id: "0", text: "", parentID: '');

  LocationModel toRegion = LocationModel(id: "0", text: "", parentID: '');
  LocationModel toCity = LocationModel(id: "0", text: "", parentID: '');
  LocationModel toNeighborhood = LocationModel(id: "0", text: "", parentID: '');

  DateTime departureDate = DateTime.now();
  DateTime returnDateTime = DateTime.now();

  int notificationNumber = 3;

  bool _isReturnToggled = true;

  @override
  void initState() {
    // departureController.text = Utils.tripDateFormat(departureDate);
    getActiveTripsId();
    if(activeTripId!="0"){
      blocHome.fetchOneDriverTrip(activeTripId);
    }
    if(activeBookedId!="0"){

    }
    getDriverStatus();
    blocHome.fetchTripList();
    blocProfile.fetchMe();
    // LocationData.loadPlaces(context);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    fromController.dispose();
    toController.dispose();
    departureController.dispose();
    returnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Stack(
          children: [
            ListView(
              controller: scrollController,
              padding: EdgeInsets.zero,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                Stack(
                  children: [
                    // Map background (simulated with a Container)
                    Container(
                      height: 312,
                      decoration: BoxDecoration(
                        color: AppTheme.black,
                        image: DecorationImage(
                          image:
                              const AssetImage('assets/images/intersect.png'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.white.withOpacity(0.07),
                            BlendMode.srcIn,
                          ),
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: const SafeArea(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Morning Khusan,',
                                style: TextStyle(
                                  color: AppTheme.light,
                                  fontSize: 16,
                                  fontFamily: AppTheme.fontFamily,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Where Are You Going Today?',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Form section with white background
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 16,
                          ),
                          margin: const EdgeInsets.only(
                              top: 200, left: 24, right: 24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
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
                              // From and To fields with swap icon
                              SizedBox(
                                height: 144,
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          height: 66,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            boxShadow: [
                                              BoxShadow(
                                                offset: const Offset(0, 4),
                                                blurRadius: 100,
                                                spreadRadius: 0,
                                                color: AppTheme.black
                                                    .withOpacity(0.05),
                                              ),
                                            ],
                                          ),
                                          child: TextField(
                                            onTap: () {
                                              BottomDialog.showSelectLocation(
                                                context,
                                                fromRegion,
                                                fromCity,
                                                fromNeighborhood,
                                                (r, c, n) {
                                                  setState(() {
                                                    fromRegion = r;
                                                    fromCity = c;
                                                    fromNeighborhood = n;
                                                    fromController.text =
                                                        "${fromNeighborhood.text}, ${fromCity.text}, ${fromRegion.text}";
                                                  });
                                                },
                                              );
                                            },
                                            readOnly: true,
                                            controller: fromController,
                                            cursorColor: AppTheme.purple,
                                            style: const TextStyle(
                                              color: AppTheme.black,
                                              fontFamily: AppTheme.fontFamily,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1,
                                              height: 1.5,
                                            ),
                                            decoration: InputDecoration(
                                              labelText: translate("home.from"),
                                              labelStyle: const TextStyle(
                                                color: AppTheme.text,
                                                fontFamily: AppTheme.fontFamily,
                                              ),
                                              filled: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 20,
                                                horizontal: 16,
                                              ),
                                              border:
                                                  const OutlineInputBorder(),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: const BorderSide(
                                                    color: AppTheme.border),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: const BorderSide(
                                                  color: AppTheme.purple,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Container(
                                          height: 66,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                offset: const Offset(0, 4),
                                                blurRadius: 100,
                                                spreadRadius: 0,
                                                color: AppTheme.black
                                                    .withOpacity(0.05),
                                              ),
                                            ],
                                          ),
                                          child: TextField(
                                            onTap: () {
                                              BottomDialog.showSelectLocation(
                                                  context,
                                                  toRegion,
                                                  toCity,
                                                  toNeighborhood, (r, c, n) {
                                                setState(() {
                                                  toRegion = r;
                                                  toCity = c;
                                                  toNeighborhood = n;
                                                  toController.text =
                                                      "${toNeighborhood.text}, ${toCity.text}, ${toRegion.text}";
                                                });
                                              });
                                            },
                                            readOnly: true,
                                            controller: toController,
                                            cursorColor: AppTheme.purple,
                                            style: const TextStyle(
                                              color: AppTheme.black,
                                              fontFamily: AppTheme.fontFamily,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1,
                                              height: 1.5,
                                            ),
                                            decoration: InputDecoration(
                                              labelText: translate("home.to"),
                                              labelStyle: const TextStyle(
                                                color: AppTheme.text,
                                                fontFamily: AppTheme.fontFamily,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 20,
                                                horizontal: 16,
                                              ),
                                              filled: true,
                                              border:
                                                  const OutlineInputBorder(),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: const BorderSide(
                                                    color: AppTheme.border),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: const BorderSide(
                                                  color: AppTheme.purple,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 66,
                                      child: Row(
                                        children: [
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                /// Swap from and to fields
                                                TextEditingController temp =
                                                    fromController;
                                                fromController = toController;
                                                toController = temp;

                                                /// Swap from and to regions
                                                LocationModel tempRegion =
                                                    fromRegion;
                                                fromRegion = toRegion;
                                                toRegion = tempRegion;

                                                /// Swap from and to cities
                                                LocationModel tempCity =
                                                    fromCity;
                                                fromCity = toCity;
                                                toCity = tempCity;

                                                /// Swap from and to neighborhoods
                                                LocationModel
                                                    tempNeighbourhood =
                                                    fromNeighborhood;
                                                fromNeighborhood =
                                                    toNeighborhood;
                                                toNeighborhood =
                                                    tempNeighbourhood;
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: const BoxDecoration(
                                                color: AppTheme.purple,
                                                shape: BoxShape.circle,
                                              ),
                                              child: SvgPicture.asset(
                                                height: 20,
                                                'assets/icons/swap_vertical.svg',
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                  Colors.white,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          const Spacer(),
                                          const Spacer(),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Departure and Return fields
                              SizedBox(
                                height: 66,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 66,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              offset: const Offset(0, 4),
                                              blurRadius: 100,
                                              spreadRadius: 0,
                                              color: AppTheme.black
                                                  .withOpacity(0.05),
                                            ),
                                          ],
                                        ),
                                        child: TextField(
                                          controller: departureController,
                                          readOnly: true,
                                          cursorColor: AppTheme.purple,
                                          style: const TextStyle(
                                            color: AppTheme.black,
                                            fontFamily: AppTheme.fontFamily,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1,
                                            height: 1.5,
                                          ),
                                          onTap: () {
                                            BottomDialog.showTripDateTime(
                                              context,
                                              (date) {
                                                setState(() {
                                                  departureDate = date;
                                                  departureController.text =
                                                      Utils.tripDateFormat(
                                                          departureDate);
                                                });
                                              },
                                              departureDate,
                                            );
                                          },
                                          decoration: InputDecoration(
                                            labelText: translate(
                                                "home.departure_date"),
                                            labelStyle: const TextStyle(
                                              color: AppTheme.text,
                                              fontFamily: AppTheme.fontFamily,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              vertical: 20,
                                              horizontal: 16,
                                            ),
                                            filled: true,
                                            border: const OutlineInputBorder(),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              borderSide: const BorderSide(
                                                  color: AppTheme.border),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              borderSide: const BorderSide(
                                                color: AppTheme.purple,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    SizedBox(
                                      height: 66,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const SizedBox(height: 4),
                                          Text(
                                            translate("home.return"),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppTheme.text,
                                              fontFamily: AppTheme.fontFamily,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _isReturnToggled =
                                                    !_isReturnToggled;
                                              });
                                            },
                                            child: SizedBox(
                                              height: 32,
                                              width: 64,
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width: 64,
                                                    height: 32,
                                                    decoration: BoxDecoration(
                                                      color: AppTheme.purple
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                  ),
                                                  AnimatedPositioned(
                                                    duration: const Duration(
                                                        milliseconds: 270),
                                                    curve: Curves.easeInOut,
                                                    left: _isReturnToggled
                                                        ? 32
                                                        : 4,
                                                    top: 2,
                                                    bottom: 2,
                                                    child: Container(
                                                      width: 28,
                                                      height: 28,
                                                      decoration: BoxDecoration(
                                                        color: _isReturnToggled
                                                            ? AppTheme.purple
                                                            : Colors.white,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Return date field
                              _isReturnToggled
                                  ? Column(
                                      children: [
                                        Container(
                                          height: 66,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                offset: const Offset(0, 4),
                                                blurRadius: 100,
                                                spreadRadius: 0,
                                                color: AppTheme.black
                                                    .withOpacity(0.05),
                                              ),
                                            ],
                                          ),
                                          child: TextField(
                                            controller: returnController,
                                            cursorColor: AppTheme.purple,
                                            style: const TextStyle(
                                              color: AppTheme.black,
                                              fontFamily: AppTheme.fontFamily,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1,
                                              height: 1.5,
                                            ),
                                            onTap: () {
                                              BottomDialog.showTripDateTime(
                                                context,
                                                (date) {
                                                  setState(() {
                                                    returnDateTime = date;
                                                    returnController.text =
                                                        Utils.tripDateFormat(
                                                            returnDateTime);
                                                  });
                                                },
                                                returnDateTime,
                                              );
                                            },
                                            decoration: InputDecoration(
                                              labelText:
                                                  translate("home.return_date"),
                                              labelStyle: const TextStyle(
                                                color: AppTheme.text,
                                                fontFamily: AppTheme.fontFamily,
                                              ),
                                              filled: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 20,
                                                horizontal: 16,
                                              ),
                                              border:
                                                  const OutlineInputBorder(),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: const BorderSide(
                                                    color: AppTheme.border),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: const BorderSide(
                                                  color: AppTheme.purple,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                    )
                                  : Container(),
                              // Find Transportation button
                              SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (toRegion.id != "0" &&
                                        fromRegion.id != "0" &&
                                        toCity.id != "0" &&
                                        fromCity.id != "0" &&
                                        toNeighborhood.id != "0" &&
                                        fromNeighborhood.id != "0") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SearchResultScreen(
                                            trip: TripListModel(
                                              id: 1,
                                              fromWhere: "Cho`ja Q.F.Y, , ",
                                              toWhere: "Bodomzor MFY, , ",
                                              fromRegionId: int.parse(fromRegion.id),
                                              toRegionId: int.parse(toRegion.id),
                                              fromCityId: int.parse(fromCity.id),
                                              toCityId: int.parse(toCity.id),
                                              fromVillageId: int.parse(fromNeighborhood.id),
                                              toVillageId: int.parse(toNeighborhood.id),
                                              startTime: departureDate,
                                              endTime: returnDateTime,
                                              pricePerSeat: "",
                                              totalSeats: 0,
                                              availableSeats: 0,
                                              startLat: "",
                                              startLong: "",
                                              endLat: "",
                                              endLong: "",
                                              status: "",
                                              createdAt: DateTime.now(),
                                              updatedAt: DateTime.now(),
                                              driver: TripDriver(
                                                id: 0,
                                                name: "",
                                                role: "driver",
                                              ),
                                              vehicle: TripVehicle(
                                                id: 0,
                                                model: "",
                                                seats: 0,
                                                carNumber: "",
                                                color: CarColor(
                                                  id: 0,
                                                  titleUz: "",
                                                  titleRu: "",
                                                  titleEn: "",
                                                  code: "",
                                                ),
                                              ),
                                            ),
                                                isRoundTrip: _isReturnToggled,
                                          ),
                                        ),
                                      );
                                    } else {
                                      CenterDialog.showActionFailed(
                                        context,
                                        translate("home.missing_form"),
                                        translate("home.trip_search_error"),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.purple,
                                    minimumSize: const Size.fromHeight(56),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    translate("home.find_transportation"),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: AppTheme.fontFamily,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w500,
                                      height: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                activeBookedId!="0"
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 24),
                              Expanded(
                                child: Text(
                                  translate("home.my_active_trips"),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppTheme.fontFamily,
                                    height: 1.5,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => TripDetailsScreen(
                                //       trip: Defaults().trips[0],
                                //       isDriver: true,
                                //     ),
                                //   ),
                                // );
                              },
                              child: ActiveTripsContainer(
                                  trip: Defaults().trips[0]),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      )
                    : const SizedBox(),
                StreamBuilder(
                  stream: blocHome.getTrips,
                  builder:
                      (context, AsyncSnapshot<List<TripListModel>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: 24),
                                Expanded(
                                  child: Text(
                                    translate("home.recommended_destinations"),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: AppTheme.fontFamily,
                                      height: 1.5,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 24),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 200,
                              width: 200,
                              child: Lottie.asset(
                                "assets/lottie/empty.json",
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              translate("explore.nothing_found"), 
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: AppTheme.fontFamily,
                                color: AppTheme.gray,
                              ),
                            ),
                            const SizedBox(height: 104),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 24),
                              Expanded(
                                child: Text(
                                  translate("home.recommended_destinations"),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppTheme.fontFamily,
                                    height: 1.5,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  color: Colors.transparent,
                                  child: Text(
                                    translate("home.view_all"),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.purple,
                                      fontFamily: AppTheme.fontFamily,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            padding: const EdgeInsets.only(bottom: 92),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width - 48,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return TripDetailsScreen(
                                                  trip: snapshot.data![index]);
                                            },
                                          ),
                                        );
                                      },
                                      child: DestinationsContainer(
                                          trip: snapshot.data![index]),
                                    ),
                                  ),
                                  index == snapshot.data!.length - 1
                                      ? Container()
                                      : const SizedBox(height: 16),
                                ],
                              );
                            },
                          ),
                        ],
                      );
                    } else {
                      return Shimmer.fromColors(
                        baseColor: AppTheme.baseColor,
                        highlightColor: AppTheme.highlightColor,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: 24),
                                Container(
                                  height: 22,
                                  width: 180,
                                  decoration: BoxDecoration(
                                    color: AppTheme.baseColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                Container(
                                  height: 14,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: AppTheme.baseColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 24),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ListView.builder(
                              itemCount: 10,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(
                                left: 24,
                                right: 24,
                                bottom: 96,
                              ),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Container(
                                      height: 80,
                                      padding: const EdgeInsets.only(
                                        left: 12,
                                        top: 10,
                                        bottom: 10,
                                        right: 20,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: AppTheme.baseColor,
                                          width: 2,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(16),
                                              color: AppTheme.baseColor,
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 14,
                                                width: 120,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(4),
                                                  color: AppTheme.baseColor,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                height: 10,
                                                width: 88,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(4),
                                                  color: AppTheme.baseColor,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 8,
                                                    width: 56,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(4),
                                                      color: AppTheme.baseColor,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Container(
                                                    height: 8,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(4),
                                                      color: AppTheme.baseColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          SvgPicture.asset(
                                            'assets/icons/right.svg',
                                            height: 20,
                                            color: AppTheme.baseColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                    index == 9 ? Container() : const SizedBox(height: 12),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: AnimatedBuilder(
                    animation: scrollController,
                    builder: (context, child) {
                      bool isScrolled = scrollController.hasClients &&
                          scrollController.offset > 0;
                      return Container(
                        decoration: BoxDecoration(
                          color:
                              isScrolled ? AppTheme.black : Colors.transparent,
                          image: DecorationImage(
                            image:
                                const AssetImage('assets/images/intersect.png'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              isScrolled
                                  ? Colors.white.withOpacity(0.03)
                                  : Colors.transparent,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        child: AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          title: isScrolled
                              ? Row(
                                  children: [
                                    const SizedBox(width: 8),
                                    Text(
                                      translate("home.title"),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppTheme.fontFamily,
                                        color: Colors.white,
                                        letterSpacing: 1,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          centerTitle: false,
                          actions: [
                            scrollController.offset >= 0
                                ? Row(
                                    children: [
                                      SizedBox(
                                        height: 48,
                                        width: 48,
                                        child: Stack(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons
                                                    .notifications_none_outlined,
                                                color: Colors.white,
                                                size: 32,
                                              ),
                                            ),
                                            notificationNumber > 0
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              AppTheme.purple,
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 2),
                                                        ),
                                                        child: Text(
                                                          notificationNumber
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getActiveTripsId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      activeTripId = prefs.getString('active_trip_id') ?? "0";
      activeBookedId = prefs.getString('active_booked_id') ?? "0";
    });
  }
}
