import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/model/location_model.dart';
import 'package:qadam/src/ui/dialogs/bottom_dialog.dart';
import 'package:qadam/src/ui/dialogs/center_dialog.dart';
import 'package:qadam/src/ui/menu/home/search_result_screen.dart';
import 'package:qadam/src/utils/utils.dart';

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

  String from = "";
  String to = "";
  String departure = "";
  String returnDate = "";

  LocationModel fromRegion = LocationModel(id: 0, text: "");
  LocationModel fromCity = LocationModel(id: 0, text: "");
  LocationModel fromNeighborhood = LocationModel(id: 0, text: "");

  LocationModel toRegion = LocationModel(id: 0, text: "");
  LocationModel toCity = LocationModel(id: 0, text: "");
  LocationModel toNeighborhood = LocationModel(id: 0, text: "");

  DateTime departureDate = DateTime.now();
  DateTime returnDateTime = DateTime.now();

  int notificationNumber = 3;

  bool _isReturnToggled = true;

  @override
  void initState() {
    // departureController.text = Utils.tripDateFormat(departureDate);
    super.initState();
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
                                    if (toRegion.id != 0 &&
                                        fromRegion.id != 0 &&
                                        toCity.id != 0 &&
                                        fromCity.id != 0 &&
                                        toNeighborhood.id != 0 &&
                                        fromNeighborhood.id != 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SearchResultScreen(
                                            trip: TripModel(
                                              vehicleId: 0,
                                              startTime: departureDate,
                                              endTime: DateTime.now(),
                                              pricePerSeat: '15',
                                              availableSeats: 0,
                                              startLocation: [
                                                toRegion.id,
                                                toCity.id,
                                                toNeighborhood.id
                                              ],
                                              endLocation: [
                                                fromRegion.id,
                                                fromCity.id,
                                                fromNeighborhood.id
                                              ],
                                            ),
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
                  itemCount: Defaults().trips.length,
                  padding: const EdgeInsets.only(bottom: 92),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 48,
                          child: DestinationsContainer(
                              trip: Defaults().trips[index]),
                        ),
                        index == Defaults().trips.length - 1
                            ? Container()
                            : const SizedBox(height: 16),
                      ],
                    );
                  },
                )
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
}
