import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/model/api/created_trip_model.dart';
import 'package:qadam/src/ui/widgets/buttons/primary_button.dart';
import 'package:qadam/src/ui/widgets/containers/leading_back.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/api/trip_list_model.dart';
import '../../../model/api/vehicles_list_model.dart';
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

  final Repository _repository = Repository();

  String vehicleId = "2";
  bool isLoading = false;

  LocationModel fromRegion = LocationModel(id: "0", text: "", parentID: '0');
  LocationModel fromCity = LocationModel(id: "0", text: "", parentID: '0');
  LocationModel fromNeighborhood =
      LocationModel(id: "0", text: "", parentID: '0');

  LocationModel toRegion = LocationModel(id: "0", text: "", parentID: '0');
  LocationModel toCity = LocationModel(id: "0", text: "", parentID: '0');
  LocationModel toNeighborhood =
      LocationModel(id: "0", text: "", parentID: '0');

  DateTime departureDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(hours: 3));

  VehicleModel selectedVehicle = VehicleModel(id: 0, vehicleName: '');

  bool isCarOpen = false;

  int passengersNum = 1;

  List<VehicleModel> myVehicles = [];

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    departureController.dispose();
    endController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getVehicleId();
    getVehicles();
    super.initState();
  }

  Future<void> getVehicles() async {
    var response = await _repository.fetchVehiclesList();
    if (response.isSuccess) {
      List<dynamic> data = [];
      if (response.result is List) {
        data = response.result;
      } else if (response.result is Map && response.result.containsKey('data')) {
        data = response.result['data'];
      }

      setState(() {
        myVehicles = data.map((e) {
          MyVehiclesModel m = MyVehiclesModel.fromJson(e);
          return VehicleModel(
            id: m.id,
            vehicleName: m.model,
            color: ColorModel(
              id: 0,
              titleEn: m.color.titleEn,
              titleRu: m.color.titleRu,
              titleUz: m.color.titleUz,
              colorCode: Color(
                int.parse(m.color.code.replaceFirst('#', '0xff')),
              ),
            ),
            capacity: m.seats,
          );
        }).toList();

        if (myVehicles.isNotEmpty) {
          bool found = false;
          for (var v in myVehicles) {
            if (v.id.toString() == vehicleId) {
              selectedVehicle = v;
              found = true;
              break;
            }
          }
          if (!found) {
            selectedVehicle = myVehicles.first;
          }
          passengersNum = selectedVehicle.capacity;
        }
      });
    }
  }

  Future<void> _onCreateTrip() async {
    if (fromController.text.isEmpty ||
        toController.text.isEmpty ||
        departureController.text.isEmpty ||
        endController.text.isEmpty ||
        selectedVehicle.id == 0 ||
        priceController.text.isEmpty) {
      CustomSnackBar().showSnackBar(
        context,
        translate("qadam.fill_all_fields"),
        2,
      );
      return;
    }

    if (startLat.isEmpty || startLong.isEmpty || endLat.isEmpty || endLong.isEmpty) {
      CustomSnackBar().showSnackBar(
        context,
        translate("qadam.select_location_on_map"),
        2,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var response = await _repository.fetchCreateTrip(
        selectedVehicle.id.toString(),
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

      if (response.isSuccess) {
        final dataMap = response.result is Map && response.result.containsKey('data') 
            ? response.result['data'] 
            : response.result;
        
        var result = CreatedTripResponseModel.fromJson(dataMap);

        if (result.id != 0) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("active_trip_id", result.id.toString());
          
          if (mounted) {
            CustomSnackBar().showSnackBar(
              context,
              translate("qadam.trip_created"),
              1,
            );
            widget.onCreated(result.toTripListModel());
            Navigator.pop(context);
          }
        } else {
          _showError(translate("qadam.trip_creation_failed_msg"));
        }
      } else {
        if (response.status == -1) {
          _showError(translate("auth.connection_failed_msg"));
        } else {
          String errorMessage = response.result is Map && response.result.containsKey('message')
              ? response.result['message']
              : translate("auth.failed_msg");
          _showError(errorMessage);
        }
      }
    } catch (e) {
      debugPrint("Error creating trip: $e");
      _showError(translate("auth.something_went_wrong"));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    CenterDialog.showActionFailed(
      context,
      translate("auth.something_went_wrong"),
      message,
    );
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
                            Expanded(
                              child: Container(
                                height: 66,
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
                                  );
                                } else {
                                  CustomSnackBar().showSnackBar(context, translate("qadam.select_location_first"), 2);
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
                            Expanded(
                              child: Container(
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
                                  );
                                } else {
                                  CustomSnackBar().showSnackBar(context, translate("qadam.select_location_first"), 2);
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
                    Positioned(
                      right: 68,
                      top: 48,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            /// Swap from and to fields
                            String tempText = fromController.text;
                            fromController.text = toController.text;
                            toController.text = tempText;

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
                            
                            /// Swap coordinates
                            String tempLat = startLat;
                            startLat = endLat;
                            endLat = tempLat;
                            
                            String tempLong = startLong;
                            startLong = endLong;
                            endLong = tempLong;
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
                          if (endDate.isBefore(departureDate)) {
                             endDate = departureDate.add(const Duration(hours: 3));
                             endController.text = Utils.tripDateFormat(endDate);
                          }
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
                              Utils.tripDateFormat(endDate);
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
                duration: const Duration(milliseconds: 300),
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
                    if (isCarOpen)
                      Column(
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
                                        passengersNum = selectedVehicle.capacity;
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
          Positioned(
            left: 16,
            right: 16,
            bottom: 32,
            child: PrimaryButton(
              title: translate("qadam.create_trip"),
              isLoading: isLoading,
              onTap: _onCreateTrip,
            ),
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
