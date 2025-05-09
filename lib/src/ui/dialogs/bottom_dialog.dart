import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/defaults/defaults.dart';
import 'package:qadam/src/model/location_model.dart';
import 'package:qadam/src/ui/widgets/texts/text_14h_500w.dart';
import 'package:qadam/src/ui/widgets/texts/text_16h_500w.dart';
import 'package:qadam/src/ui/widgets/texts/text_18h_500w.dart';

import '../../theme/app_theme.dart';
import '../widgets/picker/custom_date_picker.dart';

class BottomDialog {
  static void showSelectLocation(
    BuildContext context,
    LocationModel region,
    LocationModel city,
    LocationModel neighbourhood,
    Function(
      LocationModel region,
      LocationModel city,
      LocationModel neighbourhood,
    ) onChanged,
  ) {
    bool onCh = false;
    LocationModel selectedLocation = LocationModel(id: 0, text: "");
    LocationModel selectedRegion = LocationModel(id: 0, text: "");
    LocationModel selectedCity = LocationModel(id: 0, text: "");
    LocationModel selectedNeighbourhood = LocationModel(id: 0, text: "");

    showModalBottomSheet(
      barrierColor: AppTheme.black.withOpacity(0.45),
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        if (region.id != 0) {
          selectedLocation = region;
        }
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: selectedLocation.text == "" ? 524 : 256,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24),
                  topLeft: Radius.circular(24),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 5,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppTheme.gray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text18h500w(
                        title: selectedRegion.id == 0
                            ? translate("home.select_region")
                            : selectedCity.id == 0
                                ? translate("home.select_city")
                                : translate("home.select_neighborhood"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 270),
                    curve: Curves.easeInOut,
                    child: selectedLocation.text == ""
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: selectedRegion.id == 0
                                  ? Defaults().regions.length
                                  : selectedCity.id == 0
                                      ? Defaults().cities.length
                                      : Defaults().neighborhoods.length,
                              padding: const EdgeInsets.only(
                                  top: 4, bottom: 0, left: 16, right: 16),
                              itemBuilder: (context, index) {
                                LocationModel location = selectedRegion.id == 0
                                    ? Defaults().regions[index]
                                    : selectedCity.id == 0
                                        ? Defaults().cities[index]
                                        : Defaults().neighborhoods[index];
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedLocation = location;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        color: AppTheme.light,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text14h500w(
                                                title: location.text,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 1,
                                      color: AppTheme.blue,
                                      margin: const EdgeInsets.only(
                                          left: 8, right: 8),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        : Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedLocation.text = '';
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(
                                  top: 4,
                                  bottom: 12,
                                  left: 16,
                                  right: 16,
                                ),
                                decoration: BoxDecoration(
                                    color: AppTheme.light,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: AppTheme.purple)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text16h500w(
                                          title: selectedLocation.text),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 12,
                      left: 16,
                      right: 16,
                      bottom: 32,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              // Step 1: Clear neighborhood if selected (not confirmed by Apply)
                              if (selectedLocation.text.isNotEmpty) {
                                selectedLocation = LocationModel(id: 0, text: '');
                                return; // Stay in neighborhood selection
                              }

                              // Step 2: Clear city and go back to region selection
                              if (selectedCity.id != 0) {
                                selectedCity = LocationModel(id: 0, text: '');
                                return; // Stay in city selection
                              }

                              // Step 3: Clear region and close dialog
                              if (selectedRegion.id != 0) {
                                selectedRegion = LocationModel(id: 0, text: '');
                              }
                            });

                            // Close dialog if no region is selected
                            if (selectedRegion.id == 0) {
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            height: 56,
                            width: 72,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppTheme.purple.withOpacity(0.1),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                height: 24,
                                width: 24,
                                'assets/icons/left.svg',
                                colorFilter: const ColorFilter.mode(
                                  AppTheme.purple,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (selectedLocation.text != '') {
                                if (selectedRegion.id == 0) {
                                  setState(() {
                                    selectedRegion = selectedLocation;
                                    selectedLocation = LocationModel(id: 0, text: "");
                                  });
                                  print("Region Selected: ${selectedRegion.text}");
                                } else if (selectedCity.id == 0) {
                                  setState(() {
                                    selectedCity = selectedLocation;
                                    selectedLocation = LocationModel(id: 0, text: "");
                                  });
                                  print("City Selected: ${selectedCity.text}");
                                } else {
                                  setState(() {
                                    selectedNeighbourhood = selectedLocation;
                                    selectedLocation = LocationModel(id: 0, text: "");
                                  });
                                  print(
                                      "Neighbourhood Selected: ${selectedNeighbourhood.text}");

                                  onChanged(
                                    selectedRegion,
                                    selectedCity,
                                    selectedNeighbourhood,
                                  );
                                  Navigator.pop(context);
                                }
                              }
                            },
                            child: Container(
                              height: 56,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: AppTheme.purple,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                  child: Text16h500w(
                                title: translate("home.apply"),
                                color: Colors.white,
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static void showTripDateTime(
    BuildContext context,
    Function(DateTime data) onChoose,
    DateTime initDate,
  ) {
    DateTime chooseDate = initDate;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 400,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(24),
              topLeft: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                height: 4,
                width: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppTheme.gray,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                translate("home.select_trip_date"),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  fontFamily: AppTheme.fontFamily,
                  height: 1.5,
                  color: AppTheme.black,
                ),
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: DatePicker(
                  maximumDate: DateTime.now(),
                  minimumDate: DateTime(1900, 02, 16),
                  initialDateTime: initDate,
                  onDateTimeChanged: (date) {
                    chooseDate = date;
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  onChoose(chooseDate);
                },
                child: Container(
                  height: 56,
                  margin: const EdgeInsets.only(
                    left: 36,
                    right: 36,
                    bottom: 24,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppTheme.purple,
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(5, 9),
                        blurRadius: 15,
                        spreadRadius: 0,
                        color: AppTheme.gray,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      translate("home.apply"),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        fontFamily: AppTheme.fontFamily,
                        height: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
