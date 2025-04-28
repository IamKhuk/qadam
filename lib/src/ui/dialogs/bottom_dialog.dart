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
    LocationModel initLocation,
    int regionId,
    int cityId,
    Function(LocationModel location) onChanged,
  ) {
    bool onCh = false;
    LocationModel selectedLocation = LocationModel(id: 0, text: "");

    showModalBottomSheet(
      barrierColor: AppTheme.black.withOpacity(0.45),
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        if (initLocation.id != 0) {
          selectedLocation = initLocation;
        }
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 524,
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
                        title: regionId == 0
                            ? translate("home.select_region")
                            : cityId == 0
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
                              itemCount: regionId == 0
                                  ? Defaults().regions.length
                                  : cityId == 0
                                      ? Defaults().cities.length
                                      : Defaults().neighborhoods.length,
                              padding: const EdgeInsets.only(top: 4, bottom: 0),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (regionId == 0) {
                                          setState(() {
                                            selectedLocation =
                                                Defaults().regions[index];
                                          });
                                        }else if (cityId == 0) {
                                          setState(() {
                                            selectedLocation =
                                                Defaults().cities[index];
                                          });
                                        }else {
                                          setState(() {
                                            selectedLocation =
                                                Defaults().neighborhoods[index];
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        color: AppTheme.light,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text14h500w(
                                                title: regionId == 0
                                                    ? Defaults()
                                                        .regions[index]
                                                        .text
                                                    : cityId == 0
                                                        ? Defaults()
                                                            .cities[index]
                                                            .text
                                                        : Defaults()
                                                            .neighborhoods[index]
                                                            .text,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height:
                                          index == Defaults().regions.length - 1
                                              ? 0
                                              : 1,
                                      color: AppTheme.blue,
                                      margin: const EdgeInsets.only(
                                          left: 8, right: 8),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: AppTheme.light,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 4),
                                  blurRadius: 100,
                                  spreadRadius: 0,
                                  color: AppTheme.black.withOpacity(0.05),
                                ),
                              ],
                            ),
                            child: Text16h500w(title: selectedLocation.text),
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 12,
                      left: 16,
                      right: 16,
                      bottom: 24,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (selectedLocation.text != '') {
                              setState(() {
                                selectedLocation.text = '';
                              });
                            }
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 4),
                                  blurRadius: 100,
                                  spreadRadius: 0,
                                  color: AppTheme.black.withOpacity(0.05),
                                ),
                              ],
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                height: 24,
                                width: 24,
                                'assets/icons/left.svg',
                                colorFilter: const ColorFilter.mode(
                                  AppTheme.black,
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
                                onChanged(selectedLocation);
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: AppTheme.light,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text16h500w(title: translate("home.apply")),
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

  static void showDateTime(
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
                translate("profile.birth_date"),
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
                  child: const Center(
                    child: Text(
                      'Choose',
                      style: TextStyle(
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
