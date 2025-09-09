import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qadam/src/ui/dialogs/bottom_dialog.dart';
import 'package:qadam/src/ui/dialogs/center_dialog.dart';
import 'package:qadam/src/ui/menu/main_screen.dart';
import 'package:qadam/src/ui/widgets/buttons/primary_button.dart';
import 'package:qadam/src/ui/widgets/containers/leading_back.dart';
import 'package:qadam/src/ui/widgets/textfield/main_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/api/apply_driver_response_model.dart';
import '../../../model/api/image_response_model.dart';
import '../../../model/color_model.dart';
import '../../../model/vehicle_model.dart';
import '../../../resources/repository.dart';
import '../../../theme/app_theme.dart';
import '../../dialogs/snack_bar.dart';
import '../../widgets/texts/text_14h_400w.dart';
import '../../widgets/texts/text_16h_500w.dart';
import '../../widgets/texts/text_18h_500w.dart';
import '../home/home_screen.dart';

class AddDocsScreen extends StatefulWidget {
  const AddDocsScreen({super.key});

  @override
  State<AddDocsScreen> createState() => _AddDocsScreenState();
}

class _AddDocsScreenState extends State<AddDocsScreen> {
  final picker = ImagePicker();

  bool isLoading = false;

  final Repository _repository = Repository();

  String frontImage = '';
  String backImage = '';

  TextEditingController birthDateController = TextEditingController();
  TextEditingController licenseNumController = TextEditingController();
  TextEditingController licenseExpiryDateController = TextEditingController();

  TextEditingController carModelController = TextEditingController();
  TextEditingController carNumberController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController techPassportController = TextEditingController();

  DateTime birthDate = DateTime.now().subtract(const Duration(days: 365 * 18));
  DateTime licenseExpiryDate = DateTime.now();

  VehicleModel selectedVehicle = VehicleModel(
    id: 0,
    vehicleName: "",
  );
  ColorModel selectedColor = ColorModel(
    name: "",
    colorCode: Colors.transparent,
  );

  List<XFile> carImages = [];

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final photosStatus = await Permission.photos.request();
    if (mounted) {
      print(
          'Initial permissions - Camera: $cameraStatus, Photos: $photosStatus');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const LeadingBack(),
        elevation: 0,
        title: Text16h500w(title: translate("qadam.add_docs")),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Stack(
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
                      bottom: 96,
                    ),
                    children: [
                      Text16h500w(
                          title: translate("qadam.upload_driving_licence")),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          BottomDialog.showUploadImage(
                            context,
                            onGallery: () async {
                              final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (pickedFile != null) {
                                setState(() {
                                  isLoading = true;
                                });
                                var response =
                                    await Repository().fetchDrivingBackUpload(
                                  pickedFile.path,
                                );
                                if (response.isSuccess) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  var result =
                                      ImageUploadResponseModel.fromJson(
                                          response.result);
                                  if (result.status == "success") {
                                    setState(() {
                                      isLoading = false;
                                      frontImage = pickedFile.path;
                                    });
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString(
                                      "driving_front_image",
                                      pickedFile.path,
                                    );
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (response.status == -1) {
                                      CenterDialog.showActionFailed(
                                        context,
                                        'Connection Failed',
                                        'You do not have internet connection, please try again',
                                      );
                                    } else {
                                      CenterDialog.showActionFailed(
                                        context,
                                        'Action Failed',
                                        'Uploading Image Failed, Please try again after sometime',
                                      );
                                    }
                                  }
                                } else {
                                  CenterDialog.showActionFailed(
                                    context,
                                    'Action Failed',
                                    'Could not upload the image, please try again',
                                  );
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                            onCamera: () async {
                              final pickedFile = await picker.pickImage(
                                source: ImageSource.camera,
                              );
                              if (pickedFile != null) {
                                setState(() {
                                  isLoading = true;
                                });
                                var response =
                                    await Repository().fetchDrivingFrontUpload(
                                  pickedFile.path,
                                );
                                if (response.isSuccess) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  var result =
                                      ImageUploadResponseModel.fromJson(
                                          response.result);
                                  if (result.status == "success") {
                                    setState(() {
                                      isLoading = false;
                                      frontImage = pickedFile.path;
                                    });
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString(
                                      "driving_front_image",
                                      pickedFile.path,
                                    );
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (response.status == -1) {
                                      CenterDialog.showActionFailed(
                                        context,
                                        'Connection Failed',
                                        'You do not have internet connection, please try again',
                                      );
                                    } else {
                                      CenterDialog.showActionFailed(
                                        context,
                                        'Action Failed',
                                        'Uploading Image Failed, Please try again after sometime',
                                      );
                                    }
                                  }
                                } else {
                                  CenterDialog.showActionFailed(
                                    context,
                                    'Action Failed',
                                    'Could not upload the image, please try again',
                                  );
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border:
                                Border.all(color: AppTheme.purple, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.purple.withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 0,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: frontImage.isEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(width: 50),
                                        Lottie.asset(
                                          "assets/lottie/upload_driving_licence.json",
                                          width: 160,
                                          height: 160,
                                          fit: BoxFit.cover,
                                        ),
                                      ],
                                    ),
                                    Text18h500w(
                                      title: translate("qadam.tap_to_upload"),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      translate("qadam.supported_formats"),
                                      style: const TextStyle(
                                        fontFamily: AppTheme.fontFamily,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        height: 1.5,
                                        color: AppTheme.gray,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: AppTheme.purple,
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                          child: Row(
                                            children: [
                                              Text14h400w(
                                                title: translate(
                                                    "qadam.select_file"),
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(
                                                Icons.file_upload_outlined,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : SizedBox(
                                  height: 164,
                                  width: MediaQuery.of(context).size.width - 64,
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: 164,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                64,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Image.file(
                                            frontImage.isEmpty
                                                ? File(frontImage)
                                                : File(frontImage),
                                            height: 164,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                64,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 12,
                                        right: 12,
                                        child: GestureDetector(
                                          onTap: () {
                                            BottomDialog.showUploadImage(
                                              context,
                                              onGallery: () async {
                                                final pickedFile = await picker.pickImage(
                                                  source: ImageSource.gallery,
                                                );
                                                if (pickedFile != null) {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  var response =
                                                  await Repository().fetchDrivingBackUpload(
                                                    pickedFile.path,
                                                  );
                                                  if (response.isSuccess) {
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                    var result =
                                                    ImageUploadResponseModel.fromJson(
                                                        response.result);
                                                    if (result.status == "success") {
                                                      setState(() {
                                                        isLoading = false;
                                                        frontImage = pickedFile.path;
                                                      });
                                                      SharedPreferences prefs =
                                                      await SharedPreferences.getInstance();
                                                      prefs.setString(
                                                        "driving_front_image",
                                                        pickedFile.path,
                                                      );
                                                    } else {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      if (response.status == -1) {
                                                        CenterDialog.showActionFailed(
                                                          context,
                                                          'Connection Failed',
                                                          'You do not have internet connection, please try again',
                                                        );
                                                      } else {
                                                        CenterDialog.showActionFailed(
                                                          context,
                                                          'Action Failed',
                                                          'Uploading Image Failed, Please try again after sometime',
                                                        );
                                                      }
                                                    }
                                                  } else {
                                                    CenterDialog.showActionFailed(
                                                      context,
                                                      'Action Failed',
                                                      'Could not upload the image, please try again',
                                                    );
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                  }
                                                }
                                              },
                                              onCamera: () async {
                                                final pickedFile = await picker.pickImage(
                                                  source: ImageSource.camera,
                                                );
                                                if (pickedFile != null) {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  var response =
                                                  await Repository().fetchDrivingFrontUpload(
                                                    pickedFile.path,
                                                  );
                                                  if (response.isSuccess) {
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                    var result =
                                                    ImageUploadResponseModel.fromJson(
                                                        response.result);
                                                    if (result.status == "success") {
                                                      setState(() {
                                                        isLoading = false;
                                                        frontImage = pickedFile.path;
                                                      });
                                                      SharedPreferences prefs =
                                                      await SharedPreferences.getInstance();
                                                      prefs.setString(
                                                        "driving_front_image",
                                                        pickedFile.path,
                                                      );
                                                    } else {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      if (response.status == -1) {
                                                        CenterDialog.showActionFailed(
                                                          context,
                                                          'Connection Failed',
                                                          'You do not have internet connection, please try again',
                                                        );
                                                      } else {
                                                        CenterDialog.showActionFailed(
                                                          context,
                                                          'Action Failed',
                                                          'Uploading Image Failed, Please try again after sometime',
                                                        );
                                                      }
                                                    }
                                                  } else {
                                                    CenterDialog.showActionFailed(
                                                      context,
                                                      'Action Failed',
                                                      'Could not upload the image, please try again',
                                                    );
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                  }
                                                }
                                              },
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            child: Text14h400w(
                                              title: translate("qadam.replace"),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      MainTextField(
                        hintText: translate("qadam.driver_license_number"),
                        icon: Icons.numbers_outlined,
                        controller: licenseNumController,
                      ),
                      const SizedBox(height: 16),
                      Container(
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
                            FocusScope.of(context).unfocus();
                            BottomDialog.showBirthDate(
                              context,
                              (data) {
                                setState(() {
                                  licenseExpiryDate = data;
                                  licenseExpiryDateController.text =
                                      '${data.day.toString().length == 1 ? '0${data.day}' : data.day.toString()}/${data.month.toString().length == 1 ? '0${data.month}' : data.month.toString()}/${data.year}';
                                });
                              },
                              licenseExpiryDate,
                              false,
                              translate("qadam.driver_license_expiry_date"),
                            );
                          },
                          readOnly: true,
                          controller: licenseExpiryDateController,
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
                            labelText:
                                translate("qadam.driver_license_expiry_date"),
                            labelStyle: const TextStyle(
                              color: AppTheme.text,
                              fontFamily: AppTheme.fontFamily,
                            ),
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.date_range_outlined,
                              color: AppTheme.black,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 16,
                            ),
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  const BorderSide(color: AppTheme.border),
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
                            FocusScope.of(context).unfocus();
                            BottomDialog.showBirthDate(
                              context,
                              (data) {
                                setState(() {
                                  birthDate = data;
                                  birthDateController.text =
                                      '${data.day.toString().length == 1 ? '0${data.day}' : data.day.toString()}/${data.month.toString().length == 1 ? '0${data.month}' : data.month.toString()}/${data.year}';
                                });
                              },
                              birthDate,
                              true,
                              translate("profile.birth_date"),
                            );
                          },
                          readOnly: true,
                          controller: birthDateController,
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
                            labelText: translate("profile.birth_date"),
                            labelStyle: const TextStyle(
                              color: AppTheme.text,
                              fontFamily: AppTheme.fontFamily,
                            ),
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.date_range_outlined,
                              color: AppTheme.black,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 16,
                            ),
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  const BorderSide(color: AppTheme.border),
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
                            FocusScope.of(context).unfocus();
                            BottomDialog.showSelectCar(
                              context,
                              (value) {
                                if (value.id == 0) {
                                  return;
                                }

                                if (selectedVehicle.id == value.id) {
                                  return;
                                }

                                setState(() {
                                  selectedVehicle = value;
                                  carModelController.text =
                                      selectedVehicle.vehicleName;
                                });
                              },
                              selectedVehicle,
                            );
                          },
                          readOnly: true,
                          controller: carModelController,
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
                            labelText: translate("profile.car_model"),
                            labelStyle: const TextStyle(
                              color: AppTheme.text,
                              fontFamily: AppTheme.fontFamily,
                            ),
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.directions_car,
                              color: AppTheme.black,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 16,
                            ),
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  const BorderSide(color: AppTheme.border),
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
                      MainTextField(
                        hintText: translate("profile.car_number"),
                        icon: Icons.numbers,
                        controller: carNumberController,
                      ),
                      const SizedBox(height: 16),
                      Container(
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
                            FocusScope.of(context).unfocus();
                            BottomDialog.showSelectColor(
                              context,
                              (value) {
                                if (value.name.isNotEmpty) {
                                  if (selectedColor != value) {
                                    setState(() {
                                      selectedColor = value;
                                      colorController.text = value.name;
                                    });
                                  }
                                }
                              },
                              selectedColor,
                            );
                          },
                          readOnly: true,
                          controller: colorController,
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
                            labelText: translate("profile.car_color"),
                            labelStyle: const TextStyle(
                              color: AppTheme.text,
                              fontFamily: AppTheme.fontFamily,
                            ),
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.color_lens,
                              color: AppTheme.black,
                            ),
                            suffix: Container(
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                color: selectedColor.colorCode,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: selectedColor.colorCode ==
                                          Colors.transparent
                                      ? Colors.transparent
                                      : AppTheme.purple,
                                  width: 1,
                                ),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 16,
                            ),
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  const BorderSide(color: AppTheme.border),
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
                      MainTextField(
                        hintText: translate("profile.car_tech_passport"),
                        icon: Icons.numbers,
                        controller: techPassportController,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text16h500w(title: translate("profile.car_images")),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 112,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: carImages.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return GestureDetector(
                                      onTap: () {
                                        BottomDialog.showUploadImage(
                                          context,
                                          onGallery: () =>
                                              _pickImage(ImageSource.gallery),
                                          onCamera: () =>
                                              _pickImage(ImageSource.camera),
                                        );
                                      },
                                      child: Container(
                                        width: 112,
                                        margin:
                                            const EdgeInsets.only(right: 12),
                                        decoration: BoxDecoration(
                                          color: AppTheme.light,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: AppTheme.purple,
                                            width: 2,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.add,
                                              size: 40, color: AppTheme.purple
                                              // semanticLabel: 'Add image',
                                              ),
                                        ),
                                      ),
                                    );
                                  }
                                  return Stack(
                                    children: [
                                      Container(
                                        width: 112,
                                        margin:
                                            const EdgeInsets.only(right: 12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          image: DecorationImage(
                                            image: FileImage(File(
                                                carImages[index - 1].path)),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 12,
                                        child: GestureDetector(
                                          onTap: () => _deleteImage(index - 1),
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  Colors.white.withOpacity(0.3),
                                              border: Border.all(
                                                  color: AppTheme.red),
                                            ),
                                            child: const Icon(
                                              Icons.delete_outline_outlined,
                                              size: 20,
                                              color: AppTheme.red,
                                              semanticLabel: 'Delete image',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 32),
                  child: GestureDetector(
                    onTap: () async {
                      if (licenseNumController.text.isEmpty ||
                          licenseExpiryDateController.text.isEmpty ||
                          birthDateController.text.isEmpty ||
                          carModelController.text.isEmpty ||
                          carNumberController.text.isEmpty ||
                          colorController.text.isEmpty ||
                          techPassportController.text.isEmpty ||
                          carImages.isEmpty) {
                        CenterDialog.showActionFailed(
                          context,
                          translate("qadam.missing_docs"),
                          translate("qadam.missing_docs_msg"),
                        );
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                        var response = await _repository.fetchApplyDriver(
                          licenseNumController.text,
                          licenseExpiryDate,
                          birthDate,
                          carNumberController.text,
                          selectedVehicle.vehicleName,
                          selectedColor.id.toString(),
                          "4",
                          techPassportController.text,
                        );

                        var result =
                            ApplyDriverResponseModel.fromJson(response.result);

                        if (response.isSuccess) {
                          setState(() {
                            isLoading = false;
                          });
                          if (result.status == "success") {
                            CustomSnackBar().showSnackBar(
                              context,
                              translate("qadam.documents_uploaded"),
                              1,
                            );

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setBool('isDocsAdded', true);
                            prefs.setBool('isDocsVerified', false);
                            prefs.setString("vehicle_id", result.vehicleId.toString());

                            setState(() {
                              selectedIndex = 0;
                            });

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
                      }
                    },
                    child: PrimaryButton(title: translate("qadam.submit")),
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
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: source).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image picker timed out.')),
            );
          }
          return null;
        },
      );
      if (image != null && mounted) {
        setState(() {
          carImages.add(image);
        });
      } else if (mounted) {
        final Permission permission = source == ImageSource.camera
            ? Permission.camera
            : Permission.photos;
        final PermissionStatus status = await permission.status;
        print('Permission status: $status');
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permission Required'),
            content: Text(
              'This app needs ${source == ImageSource.camera ? "camera" : "photo library"} access to upload car images.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final bool opened = await openAppSettings();
                  if (!opened && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Unable to open Settings.')),
                    );
                  } else if (mounted) {
                    await Future.delayed(const Duration(seconds: 1));
                    final status = await permission.status;
                    print('Updated permission status: $status');
                    if (status.isGranted || status.isLimited) {
                      await _pickImage(source);
                    }
                  }
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        print('Error picking image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error accessing $source: $e')),
        );
      }
    }
  }

  void _deleteImage(int index) {
    if (mounted) {
      setState(() {
        carImages.removeAt(index);
      });
    }
  }
}
