import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:qadam/src/bloc/qadam_bloc.dart';
import 'package:qadam/src/model/api/trip_list_model.dart';
import 'package:qadam/src/theme/app_theme.dart';
import 'package:qadam/src/ui/menu/new_qadam/create_new_qadam_screen.dart';
import 'package:qadam/src/ui/widgets/buttons/secondary_button.dart';
import 'package:qadam/src/ui/widgets/texts/text_16h_500w.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../model/api/driver_trips_list_model.dart';
import '../../../resources/repository.dart';
import '../../widgets/containers/destinations_container.dart';
import '../../widgets/texts/text_14h_400w.dart';
import 'add_docs_screen.dart';

class NewQadam extends StatefulWidget {
  const NewQadam({super.key});

  @override
  State<NewQadam> createState() => _NewQadamState();
}

class _NewQadamState extends State<NewQadam> {
  bool isDocsAdded = false;
  bool isDocsVerified = false;

  bool isLoading = false;

  final Repository _repository = Repository();

  List<DriverTripModel> myTrips = [];

  DriverTripModel myDefaultTrip = DriverTripModel.defaultTrip();

  int selectedTabIndex = 0;

  Future<void> getDriverStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String status = prefs.getString('driving_verification_status') ?? "";

    setState(() {
      isDocsAdded = prefs.getBool('isDocsAdded') ?? false;
      isDocsVerified = status == "approved";
    });

    if (isDocsVerified) {
      blocQadam.fetchDriverTripList("active");
    }
  }

  @override
  void initState() {
    getDriverStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text16h500w(title: "New Qadam"),
        centerTitle: true,
      ),
      body: isDocsAdded == false
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  "assets/lottie/add_docs.json",
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 24),
                Text16h500w(title: translate("qadam.add_docs_title")),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(width: 32),
                    Expanded(
                      child: Text(
                        translate("qadam.add_docs_msg"),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.gray,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppTheme.fontFamily,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 32),
                  ],
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: SecondaryButton(
                    title: translate("qadam.add_docs_button"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const AddDocsScreen();
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 92),
              ],
            )
          : isDocsVerified == false
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      "assets/lottie/waiting.json",
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 24),
                    Text16h500w(
                        title: translate("qadam.verification_in_progress")),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const SizedBox(width: 32),
                        Expanded(
                          child: Text(
                            translate("qadam.verification_in_progress_msg"),
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.gray,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppTheme.fontFamily,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 32),
                      ],
                    ),
                    const SizedBox(height: 92),
                  ],
                )
              : Stack(
                      children: [
                        StreamBuilder<List<DriverTripModel>>(
                          stream: blocQadam.getTrips,
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              final trips = snapshot.data ?? [];

                              if (trips.isEmpty) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Lottie.asset(
                                      "assets/lottie/empty.json",
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(height: 24),
                                    Text16h500w(title: translate("qadam.No_trip_found")),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const SizedBox(width: 32),
                                        Expanded(
                                          child: Text(
                                            translate("qadam.No_trip_found_msg"),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.gray,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: AppTheme.fontFamily,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        const SizedBox(width: 32),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 32),
                                      child: SecondaryButton(
                                        title: translate("qadam.create_new_trip"),
                                        onTap: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CreateNewQadamScreen(
                                                  driverTrip: myDefaultTrip),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 92),
                                  ],
                                );
                              }else{
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: trips.length,
                                  padding: const EdgeInsets.only(
                                    left: 24,
                                    right: 24,
                                    bottom: 96,
                                    top: 88,
                                  ),
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width -
                                              48,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateNewQadamScreen(
                                                        driverTrip: myDefaultTrip,
                                                      ),
                                                ),
                                              );
                                            },
                                            child: DestinationsContainer(
                                              trip: TripListModel(
                                                id: trips[index].id,
                                                fromWhere: "",
                                                toWhere: "",
                                                fromRegionId:
                                                trips[index].fromRegionId,
                                                toRegionId:
                                                trips[index].toRegionId,
                                                fromCityId:
                                                trips[index].fromCityId,
                                                toCityId: trips[index].toCityId,
                                                fromVillageId:
                                                trips[index].fromVillageId,
                                                toVillageId:
                                                trips[index].toVillageId,
                                                startTime: trips[index].startTime,
                                                endTime: trips[index].endTime,
                                                pricePerSeat:
                                                trips[index].pricePerSeat,
                                                totalSeats:
                                                trips[index].totalSeats,
                                                availableSeats:
                                                trips[index].availableSeats,
                                                startLat: trips[index].startLat,
                                                startLong: trips[index].startLong,
                                                endLat: trips[index].endLat,
                                                endLong: trips[index].endLong,
                                                status: trips[index].status,
                                                createdAt: trips[index].createdAt,
                                                updatedAt: trips[index].updatedAt,
                                                driver: TripDriver(
                                                  id: trips[index].driver.id,
                                                  name:
                                                  "${trips[index].driver.firstName} ${trips[index].driver.lastName}",
                                                  role: trips[index].driver.role,
                                                ),
                                                vehicle: TripVehicle(
                                                  id: trips[index].vehicle.id,
                                                  model:
                                                  trips[index].vehicle.model,
                                                  seats:
                                                  trips[index].vehicle.seats,
                                                  carNumber: trips[index]
                                                      .vehicle
                                                      .carNumber,
                                                  color: CarColor(
                                                    id: trips[index]
                                                        .vehicle
                                                        .color
                                                        .id,
                                                    titleUz: "",
                                                    titleRu: "",
                                                    titleEn: "",
                                                    code: "",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        index == trips.length - 1
                                            ? Container()
                                            : const SizedBox(height: 16),
                                      ],
                                    );
                                  },
                                );
                              }
                            }else{
                              return Shimmer.fromColors(
                                baseColor: AppTheme.baseColor,
                                highlightColor: AppTheme.highlightColor,
                                child: ListView.builder(
                                  itemCount: 10,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(
                                    left: 24,
                                    right: 24,
                                    bottom: 96,
                                    top: 88,
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
                              );
                            }
                          },
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 16),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 270),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(32),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 5),
                                      blurRadius: 100,
                                      spreadRadius: 0,
                                      color: Colors.black.withOpacity(0.15),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (selectedTabIndex == 0) {
                                          return;
                                        }
                                        setState(() {
                                          selectedTabIndex = 0;
                                        });
                                        blocQadam.fetchDriverTripList("active");
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: selectedTabIndex == 0
                                              ? AppTheme.black
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(32),
                                        ),
                                        child: Text14h400w(
                                          title:
                                              translate('history.in_progress'),
                                          color: selectedTabIndex == 0
                                              ? Colors.white
                                              : AppTheme.dark,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (selectedTabIndex == 1) {
                                          return;
                                        }
                                        setState(() {
                                          selectedTabIndex = 1;
                                        });
                                        blocQadam.fetchDriverTripList("completed");
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: selectedTabIndex == 1
                                              ? AppTheme.black
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(32),
                                        ),
                                        child: Text14h400w(
                                          title: translate('history.completed'),
                                          color: selectedTabIndex == 1
                                              ? Colors.white
                                              : AppTheme.dark,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (selectedTabIndex == 2) {
                                          return;
                                        }
                                        setState(() {
                                          selectedTabIndex = 2;
                                        });
                                        blocQadam.fetchDriverTripList("canceled");
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: selectedTabIndex == 2
                                              ? AppTheme.black
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(32),
                                        ),
                                        child: Text14h400w(
                                          title: translate('history.canceled'),
                                          color: selectedTabIndex == 2
                                              ? Colors.white
                                              : AppTheme.dark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 96,
                                bottom: 96,
                                right: 16,
                              ),
                              child: SecondaryButton(
                                title: translate("qadam.create_new_trip"),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CreateNewQadamScreen(
                                        driverTrip: myDefaultTrip,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
    );
  }
}
