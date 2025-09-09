import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/model/api/created_trip_model.dart';
import 'package:qadam/src/ui/widgets/buttons/primary_button.dart';
import 'package:qadam/src/ui/widgets/containers/leading_back.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/api/trip_list_model.dart';
import '../../../model/color_model.dart';
import '../../../model/location_model.dart';
import '../../../model/vehicle_model.dart';
import '../../../resources/repository.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/text_formatters.dart';
import '../../../utils/utils.dart';
import '../../dialogs/bottom_dialog.dart';
import '../../dialogs/center_dialog.dart';
import '../../dialogs/snack_bar.dart';
import '../../widgets/containers/car_container.dart';
import '../../widgets/textfield/main_textfield.dart';
import '../../widgets/texts/text_14h_400w.dart';
import '../../widgets/texts/text_16h_500w.dart';
import 'map_select_screen.dart';

class CreateNewQadamScreen extends StatefulWidget {
  const CreateNewQadamScreen({
    super.key,
    required this.onCreated,
  });

  final Function(TripListModel data) onCreated;

  @override
  State<CreateNewQadamScreen> createState() => _CreateNewQadamScreenState();
}

class _CreateNewQadamScreenState extends State<CreateNewQadamScreen> {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController departureController = TextEditingController();
  TextEditingController endController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  String startLat = "";
  String startLong = "";
  String endLat = "";
  String endLong = "";

  late TripListModel currentTrip;

  final Repository _repository = Repository();

  String vehicleId = "2";
  bool isLoading = false;

  String from = "";
  String to = "";
  String departure = "";
  String end = "";

  LocationModel fromRegion = LocationModel(id: "0", text: "", parentID: '0');
  LocationModel fromCity = LocationModel(id: "0", text: "", parentID: '0');
  LocationModel fromNeighborhood =
      LocationModel(id: "0", text: "", parentID: '0');

  LocationModel toRegion = LocationModel(id: "0", text: "", parentID: '0');
  LocationModel toCity = LocationModel(id: "0", text: "", parentID: '0');
  LocationModel toNeighborhood =
      LocationModel(id: "0", text: "", parentID: '0');

  DateTime departureDate = DateTime.now();
  DateTime endDate = DateTime.now();

  VehicleModel selectedVehicle = VehicleModel(id: 0, vehicleName: '');

  bool isCarOpen = false;

  int passengersNum = 1;

  List<VehicleModel> myVehicles = [
    VehicleModel(
      id: 1,
      vehicleName: "Toyota Corolla",
      color: ColorModel(
        name: "Navy Blue",
        colorCode: AppTheme.blue.withOpacity(0.6),
      ),
      capacity: 4,
    ),
    VehicleModel(
      id: 1,
      vehicleName: "Malibu",
      color: ColorModel(
        name: "Black",
        colorCode: AppTheme.black,
      ),
      capacity: 4,
    ),
    VehicleModel(
      id: 1,
      vehicleName: "Toyota Arius",
      color: ColorModel(
        name: "Rosy Red",
        colorCode: AppTheme.red.withOpacity(0.6),
      ),
      capacity: 6,
    ),
  ];

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    departureController.dispose();
    endController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getVehicleId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const LeadingBack(),
        title: const Text16h500w(title: "New Qadam"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(
              top: 22,
              left: 16,
              right: 16,
              bottom: 92,
            ),
            children: [
              SizedBox(
                height: 144,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 66,
                              width: MediaQuery.of(context).size.width - 84,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 4),
                                    blurRadius: 100,
                                    spreadRadius: 0,
                                    color: AppTheme.black.withOpacity(0.05),
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
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 16,
                                  ),
                                  border: const OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                        color: AppTheme.border),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppTheme.purple,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                if (fromController.text.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapSelectScreen(
                                        place: fromController.text,
                                        onSelected: (data) {
                                          debugPrint(
                                              "${data.latitude} ${data.longitude}");
                                          setState(() {
                                            startLat = data.latitude.toString();
                                            startLong =
                                                data.longitude.toString();
                                          });
                                        },
                                      ),
                                    ),
                                  ).then((value) {
                                    if (value != null) {
                                      print(
                                          'Selected coordinates: $value'); // LatLng object
                                    }
                                  });
                                }
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
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              height: 66,
                              width: MediaQuery.of(context).size.width - 84,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 4),
                                    blurRadius: 100,
                                    spreadRadius: 0,
                                    color: AppTheme.black.withOpacity(0.05),
                                  ),
                                ],
                              ),
                              child: TextField(
                                onTap: () {
                                  BottomDialog.showSelectLocation(
                                      context, toRegion, toCity, toNeighborhood,
                                      (r, c, n) {
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
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 16,
                                  ),
                                  filled: true,
                                  border: const OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                        color: AppTheme.border),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppTheme.purple,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                if (toController.text.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapSelectScreen(
                                        place: toController.text,
                                        onSelected: (data) {
                                          debugPrint(
                                              "${data.latitude} ${data.longitude}");
                                          setState(() {
                                            endLat = data.latitude.toString();
                                            endLong = data.longitude.toString();
                                          });
                                        },
                                      ),
                                    ),
                                  ).then((value) {
                                    if (value != null) {
                                      print(
                                          'Selected coordinates: $value'); // LatLng object
                                    }
                                  });
                                }
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
                                TextEditingController temp = fromController;
                                fromController = toController;
                                toController = temp;

                                /// Swap from and to regions
                                LocationModel tempRegion = fromRegion;
                                fromRegion = toRegion;
                                toRegion = tempRegion;

                                /// Swap from and to cities
                                LocationModel tempCity = fromCity;
                                fromCity = toCity;
                                toCity = tempCity;

                                /// Swap from and to neighborhoods
                                LocationModel tempNeighbourhood =
                                    fromNeighborhood;
                                fromNeighborhood = toNeighborhood;
                                toNeighborhood = tempNeighbourhood;
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
                                colorFilter: const ColorFilter.mode(
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
              const SizedBox(height: 16),
              Container(
                height: 66,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 4),
                      blurRadius: 100,
                      spreadRadius: 0,
                      color: AppTheme.black.withOpacity(0.05),
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
                              Utils.tripDateFormat(departureDate);
                        });
                      },
                      departureDate,
                    );
                  },
                  decoration: InputDecoration(
                    labelText: translate("home.departure_date"),
                    labelStyle: const TextStyle(
                      color: AppTheme.text,
                      fontFamily: AppTheme.fontFamily,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    filled: true,
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppTheme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppTheme.purple,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 66,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 4),
                      blurRadius: 100,
                      spreadRadius: 0,
                      color: AppTheme.black.withOpacity(0.05),
                    ),
                  ],
                ),
                child: TextField(
                  controller: endController,
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
                          endDate = date;
                          endController.text =
                              Utils.tripDateFormat(departureDate);
                        });
                      },
                      endDate,
                    );
                  },
                  decoration: InputDecoration(
                    labelText: translate("qadam.end_date"),
                    labelStyle: const TextStyle(
                      color: AppTheme.text,
                      fontFamily: AppTheme.fontFamily,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    filled: true,
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppTheme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppTheme.purple,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text16h500w(title: translate("qadam.select_car_title")),
              const SizedBox(height: 16),
              AnimatedContainer(
                duration: const Duration(milliseconds: 1070),
                curve: Curves.easeInOut,
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
                      children: [
                        selectedVehicle.vehicleName.isEmpty
                            ? Text14h400w(
                                title: translate("qadam.select_car"),
                                color: AppTheme.gray,
                              )
                            : Text16h500w(
                                title: selectedVehicle.vehicleName,
                              ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isCarOpen = !isCarOpen;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.light,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Icon(
                              isCarOpen
                                  ? Icons.keyboard_arrow_up_outlined
                                  : Icons.keyboard_arrow_down_outlined,
                              color: AppTheme.black,
                              size: 24,
                            ),
                          ),
                        )
                      ],
                    ),
                    isCarOpen
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: myVehicles.length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedVehicle = myVehicles[index];
                                            isCarOpen = false;
                                          });
                                        },
                                        child: CarContainer(
                                            car: myVehicles[index]),
                                      ),
                                      index == myVehicles.length - 1
                                          ? const SizedBox()
                                          : const Divider(),
                                    ],
                                  );
                                },
                              ),
                            ],
                          )
                        : const SizedBox(),
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
                child: Row(
                  children: [
                    Expanded(
                      child: Text14h400w(
                        title: translate("home.number_passenger"),
                        color: AppTheme.gray,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (passengersNum > 1) {
                          setState(() {
                            passengersNum--;
                          });
                        } else {
                          CenterDialog.showActionFailed(
                            context,
                            translate("qadam.min_passengers_reached"),
                            translate("qadam.min_passengers_reached_msg"),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.light,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: AppTheme.black,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text16h500w(title: passengersNum.toString()),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        if (passengersNum < selectedVehicle.capacity) {
                          setState(() {
                            passengersNum++;
                          });
                        } else {
                          CenterDialog.showActionFailed(
                            context,
                            translate("qadam.max_passengers_reached"),
                            translate("qadam.max_passengers_reached_msg"),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.light,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: AppTheme.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              MainTextField(
                hintText: translate("qadam.price_per_seat"),
                icon: Icons.currency_exchange_outlined,
                controller: priceController,
                phone: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  PriceInputFormatter(maxDigits: 10),
                ],
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
                    if (fromController.text.isNotEmpty &&
                        toController.text.isNotEmpty &&
                        departureController.text.isNotEmpty &&
                        selectedVehicle.vehicleName.isNotEmpty &&
                        priceController.text.isNotEmpty &&
                        startLat.isNotEmpty &&
                        startLong.isNotEmpty &&
                        endLat.isNotEmpty &&
                        endLong.isNotEmpty) {
                      // setState(() {
                      //   currentTrip = TripModel(
                      //     vehicleId: selectedVehicle.id,
                      //     startTime: departureDate,
                      //     endTime: endDate,
                      //     pricePerSeat: priceController.text,
                      //     availableSeats: passengersNum,
                      //   );
                      // });
                      setState(() {
                        isLoading = true;
                      });
                      var response = await _repository.fetchCreateTrip(
                        vehicleId,
                        departureDate,
                        endDate,
                        Utils().stringToInt(priceController.text).toString(),
                        passengersNum.toString(),
                        startLat,
                        startLong,
                        endLat,
                        endLong,
                        fromRegion.id,
                        fromCity.id,
                        fromNeighborhood.id,
                        toRegion.id,
                        toCity.id,
                        toNeighborhood.id,
                      );

                      var result =
                          CreatedTripResponseModel.fromJson(response.result);

                      if (response.isSuccess) {
                        setState(() {
                          isLoading = false;
                        });
                        if (result.id.toString().isNotEmpty && result.id != 0) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString(
                              "active_trip_id", result.id.toString());
                          CustomSnackBar().showSnackBar(
                            context,
                            translate("qadam.trip_created"),
                            1,
                          );
                          Navigator.pop(context);
                        } else {
                          CenterDialog.showActionFailed(
                            context,
                            translate("qadam.trip_creation_failed"),
                            translate("qadam.trip_creation_failed_msg"),
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
                    }
                  },
                  child: PrimaryButton(title: translate("qadam.create_trip")),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> getVehicleId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      vehicleId = prefs.getString('vehicle_id') ?? "0";
    });
  }
}
