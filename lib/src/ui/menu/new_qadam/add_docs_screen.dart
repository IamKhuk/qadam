import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_picker/image_picker.dart';
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
import '../../../model/event_bus/http_result.dart';
import '../../../model/vehicle_model.dart';
import '../../../resources/repository.dart';
import '../../../theme/app_theme.dart';
import '../../dialogs/snack_bar.dart';
import '../../widgets/texts/text_14h_400w.dart';
import '../../widgets/texts/text_16h_500w.dart';

class AddDocsScreen extends StatefulWidget {
  const AddDocsScreen({super.key});

  @override
  State<AddDocsScreen> createState() => _AddDocsScreenState();
}

class _AddDocsScreenState extends State<AddDocsScreen> {
  final picker = ImagePicker();
  final Repository _repository = Repository();
  
  bool isLoading = false;
  int currentStep = 1;
  int totalSteps = 4;

  // Step 1 Controllers (Driver)
  TextEditingController licenseNumController = TextEditingController();
  TextEditingController licenseExpiryDateController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  
  // Step 2 Images (Driver)
  String frontImage = '';
  String backImage = '';
  String passportImage = '';

  // Step 3 Controllers (Vehicle Text)
  TextEditingController carModelController = TextEditingController();
  TextEditingController carNumberController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController techPassportController = TextEditingController();
  int seats = 1;

  // Step 4 Images (Vehicle Images)
  String techPassportFront = '';
  String techPassportBack = '';
  List<XFile> carImages = [];
  
  DateTime birthDate = DateTime.now().subtract(const Duration(days: 365 * 18));
  DateTime licenseExpiryDate = DateTime.now();
  
  VehicleModel selectedVehicle = VehicleModel(id: 0, vehicleName: "");
  ColorModel selectedColor = ColorModel(titleEn: "", colorCode: Colors.transparent, id: 0, titleRu: '', titleUz: '');

  String vehicleId = "";

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    await Permission.camera.request();
    await Permission.photos.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            if (currentStep > 1) {
              setState(() {
                currentStep--;
              });
            } else {
              Navigator.pop(context);
            }
          },
          child: Row(
            children: [
              const SizedBox(width: 12),
              InkWell(
                borderRadius: BorderRadius.circular(40),
                onTap: () {
                  setState(() {
                    currentStep==1 ? Navigator.pop(context) : currentStep--;
                  });
                },
                child: Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/arrow_left.svg',
                      height: 24,
                      width: 24,
                      colorFilter: const ColorFilter.mode(
                        AppTheme.black,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text16h500w(title: _getAppBarTitle()),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(totalSteps, (index) {
                    return Row(
                      children: [
                        _buildStepIndicator(index + 1),
                        if (index < totalSteps - 1) const SizedBox(width: 4),
                      ],
                    );
                  }),
                ),
              ],
            ),
            SizedBox(width: 52),
          ],
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                    children: [
                      if (currentStep == 1) _buildStep1(),
                      if (currentStep == 2) _buildStep2(),
                      if (currentStep == 3) _buildStep3(),
                      if (currentStep == 4) _buildStep4(),
                      const SizedBox(height: 96),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 32,
              child: _buildBottomButton(),
            ),
            if (isLoading)
              Container(
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
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.purple),
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  String _getAppBarTitle() {
    if (currentStep == 1) return translate("qadam.driver_license_details");
    if (currentStep == 2) return translate("qadam.document_upload");
    if (currentStep == 3) return translate("qadam.vehicle_details");
    return translate("qadam.vehicle_photos"); // Needs translation key
  }
  
  Widget _buildStepIndicator(int step) {
    bool isActive = step <= currentStep;
    double width = (MediaQuery.of(context).size.width - 152) / totalSteps;
    return Container(
      width: width,
      height: 4,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.purple : AppTheme.gray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  // --- Step 1 UI (Driver Details) ---
  Widget _buildStep1() {
    return Column(
      children: [
        MainTextField(
          hintText: translate("qadam.driver_license_number"),
          icon: Icons.numbers_outlined,
          controller: licenseNumController,
        ),
        const SizedBox(height: 16),
        _buildDateField(
          controller: licenseExpiryDateController,
          label: translate("qadam.driver_license_expiry_date"),
          onTap: () {
            BottomDialog.showBirthDate(
              context,
              (data) {
                setState(() {
                  licenseExpiryDate = data;
                  licenseExpiryDateController.text =
                      '${data.day}/${data.month}/${data.year}';
                });
              },
              licenseExpiryDate,
              false,
              translate("qadam.driver_license_expiry_date"),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildDateField(
          controller: birthDateController,
          label: translate("profile.birth_date"),
          onTap: () {
            BottomDialog.showBirthDate(
              context,
              (data) {
                setState(() {
                  birthDate = data;
                  birthDateController.text =
                      '${data.day}/${data.month}/${data.year}';
                });
              },
              birthDate,
              true,
              translate("profile.birth_date"),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
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
          onTap();
        },
        readOnly: true,
        controller: controller,
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
          labelText: label,
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
            borderSide: const BorderSide(color: AppTheme.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppTheme.purple),
          ),
        ),
      ),
    );
  }

  // --- Step 2 UI (Driver Docs) ---
  Widget _buildStep2() {
    return Column(
      children: [
        _buildImageUpload(
          title: translate("qadam.upload_driving_licence_front"), // "License Front"
          imagePath: frontImage,
          onUpload: (path) {
            setState(() {
              frontImage = path;
            });
            _saveToPrefs("driving_front_image", path);
          },
          uploadType: 'front',
        ),
        const SizedBox(height: 16),
        _buildImageUpload(
          title: translate("qadam.upload_driving_licence_back"), // "License Back"
          imagePath: backImage,
          onUpload: (path) {
            setState(() {
              backImage = path;
            });
            _saveToPrefs("driving_back_image", path);
          },
          uploadType: 'back',
        ),
        const SizedBox(height: 16),
        _buildImageUpload(
          title: translate("qadam.upload_passport"), // "Passport"
          imagePath: passportImage,
          onUpload: (path) {
            setState(() {
              passportImage = path;
            });
            _saveToPrefs("passport_image", path);
          },
          uploadType: 'passport',
        ),
      ],
    );
  }

  Widget _buildImageUpload({
    required String title,
    required String imagePath,
    required Function(String) onUpload,
    required String uploadType,
    bool isSimpleUpload = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text16h500w(title: title),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            if (imagePath.isEmpty) {
              BottomDialog.showUploadImage(
                context,
                onGallery: () => _handleImageSelection(ImageSource.gallery, onUpload, uploadType, isSimpleUpload),
                onCamera: () => _handleImageSelection(ImageSource.camera, onUpload, uploadType, isSimpleUpload),
              );
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.purple, width: 2),
            ),
            child: imagePath.isEmpty
                ? Column(
              children: [
                const Icon(Icons.cloud_upload_outlined, size: 48, color: AppTheme.purple),
                const SizedBox(height: 8),
                Text14h400w(title: translate("qadam.tap_to_upload")),
              ],
            )
                : Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(imagePath),
                    height: 164,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        // Reset the corresponding image path based on uploadType
                        if (uploadType == 'front') {
                          frontImage = '';
                        } else if (uploadType == 'back') {
                          backImage = '';
                        } else if (uploadType == 'passport') {
                          passportImage = '';
                        } else if (uploadType == 'tech_front') {
                          techPassportFront = '';
                        } else if (uploadType == 'tech_back') {
                          techPassportBack = '';
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        color: AppTheme.red,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleImageSelection(
    ImageSource source,
    Function(String) onUpdate,
    String type,
    bool isSimpleUpload,
  ) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      if (isSimpleUpload) {
        // Just update local path, upload happens in batch later
        onUpdate(pickedFile.path);
        return;
      }
      
      setState(() => isLoading = true);
      
      HttpResult response;
      if (type == 'front') {
        response = await _repository.fetchDrivingFrontUpload(pickedFile.path);
      } else if (type == 'back') {
        response = await _repository.fetchDrivingBackUpload(pickedFile.path);
      }else if (type == 'tech_front') {
        response = await _repository.fetchUploadCarImages(vehicleId, pickedFile.path, '', []);
      } else if (type == 'tech_back') {
         response = await _repository.fetchUploadCarImages(vehicleId, '', pickedFile.path, []);
      } else {
        response = await _repository.fetchPassportUpload(pickedFile.path);
      }

      setState(() => isLoading = false);

      if (response.isSuccess) {
        // Different response models might require different handling, 
        // but ImageUploadResponseModel is generic enough for success status check usually.
        // If fetchUploadCarImages returns the same structure, this is fine.
        // Based on ApiProvider, it returns a generic map, so we check "status".
        
        bool success = false;
        if(type == 'tech_front' || type == 'tech_back') {
             if(response.result is Map && (response.result['status'] == 'success' || response.result['status'] == 200)) {
                 success = true;
             }
        } else {
             var result = ImageUploadResponseModel.fromJson(response.result);
             if (result.status == "success") success = true;
        }

        if (success) {
          onUpdate(pickedFile.path);
        } else {
          _showError(translate("qadam.upload_failed"));
        }
      } else {
        _showError(translate("auth.connection_failed"));
      }
    }
  }


  // --- Step 3 UI (Vehicle Text) ---
  Widget _buildStep3() {
    return Column(
      children: [
        _buildDropdownField(
          label: translate("profile.car_model"),
          controller: carModelController,
          onTap: () {
            BottomDialog.showSelectCar(context, (value) {
              if (value.id != 0 && selectedVehicle.id != value.id) {
                setState(() {
                  selectedVehicle = value;
                  carModelController.text = selectedVehicle.vehicleName;
                });
              }
            }, selectedVehicle);
          },
          icon: Icons.directions_car,
        ),
        const SizedBox(height: 16),
        MainTextField(
          hintText: translate("profile.car_number"),
          icon: Icons.numbers,
          controller: carNumberController,
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: translate("profile.car_color"),
          controller: colorController,
          onTap: () {
            BottomDialog.showSelectColor(context, (value) {
              if (value.titleEn.isNotEmpty && selectedColor != value) {
                setState(() {
                  selectedColor = value;
                  colorController.text = value.titleEn;
                });
              }
            }, selectedColor);
          },
          icon: Icons.color_lens,
          suffix: Container(
            height: 24, width: 24,
            decoration: BoxDecoration(
              color: selectedColor.colorCode,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.purple),
            ),
          ),
        ),
         const SizedBox(height: 16),
        MainTextField(
          hintText: translate("profile.car_tech_passport"),
          icon: Icons.numbers,
          controller: techPassportController,
        ),
        const SizedBox(height: 16),
        _buildSeatCounter(),
      ],
    );
  }

  Widget _buildSeatCounter() {
    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white, // or AppTheme.bg if available
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 100,
            spreadRadius: 0,
            color: AppTheme.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.people_outline, color: AppTheme.black),
              const SizedBox(width: 12),
              Text16h500w(title: translate("profile.seats") ?? "Number of seats"),
            ],
          ),
          Row(
            children: [
              _buildCounterButton(
                icon: Icons.remove,
                onTap: () {
                  if (seats > 1) {
                    setState(() {
                      seats--;
                    });
                  }
                },
              ),
              SizedBox(
                width: 40,
                child: Center(
                  child: Text(
                    seats.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black,
                    ),
                  ),
                ),
              ),
              _buildCounterButton(
                icon: Icons.add,
                onTap: () {
                  if (seats < 8) {
                    setState(() {
                      seats++;
                    });
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCounterButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: AppTheme.purple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppTheme.purple,
          size: 20,
        ),
      ),
    );
  }


  Widget _buildDropdownField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
    required IconData icon,
    Widget? suffix,
  }) {
    return Container(
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
          onTap();
        },
        readOnly: true,
        controller: controller,
        cursorColor: AppTheme.purple,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          prefixIcon: Icon(icon, color: AppTheme.black),
          suffix: suffix,
           contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
           border: const OutlineInputBorder(),
           enabledBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(16),
             borderSide: const BorderSide(color: AppTheme.border),
           ),
           focusedBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(16),
             borderSide: const BorderSide(color: AppTheme.purple),
           ),
        ),
      ),
    );
  }

  // --- Step 4 UI (Vehicle Images) ---
  Widget _buildStep4() {
    return Column(
      children: [
        _buildImageUpload(
          title: "Tech Passport Front",
          imagePath: techPassportFront,
          onUpload: (path) {
            setState(() {
              techPassportFront = path;
            });
          },
          uploadType: 'tech_front',
          isSimpleUpload: false,
        ),
         const SizedBox(height: 16),
        _buildImageUpload(
          title: "Tech Passport Back",
          imagePath: techPassportBack,
          onUpload: (path) {
            setState(() {
              techPassportBack = path;
            });
          },
          uploadType: 'tech_back',
          isSimpleUpload: false,
        ),
        const SizedBox(height: 24),
        _buildCarImagesSection(),
      ],
    );
  }

  Widget _buildCarImagesSection() {
    return Column(
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
                      onGallery: () => _pickCarImage(ImageSource.gallery),
                      onCamera: () => _pickCarImage(ImageSource.camera),
                    );
                  },
                  child: Container(
                    width: 112,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.light,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.purple, width: 2),
                    ),
                    child: const Center(
                      child: Icon(Icons.add, size: 40, color: AppTheme.purple),
                    ),
                  ),
                );
              }
              return Stack(
                children: [
                  Container(
                    width: 112,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: FileImage(File(carImages[index - 1].path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0, right: 12,
                    child: GestureDetector(
                      onTap: () => setState(() => carImages.removeAt(index - 1)),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        child: const Icon(Icons.delete, color: Colors.red, size: 20),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _pickCarImage(ImageSource source) async {
    try {
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        setState(() => isLoading = true);
        
        // Upload immediately
        var response = await _repository.fetchUploadCarImages(
            vehicleId, '', '', [image.path]);

        setState(() => isLoading = false);

        if (response.isSuccess) {
             if(response.result is Map && (response.result['status'] == 'success' || response.result['status'] == 200)) {
                  setState(() {
                    carImages.add(image);
                  });
             } else {
                 _showError(translate("qadam.upload_failed"));
             }
        } else {
            _showError(translate("auth.connection_failed"));
        }
      }
    } catch (e) {
      debugPrint("Error picking car image: $e");
      setState(() => isLoading = false);
    }
  }

  // --- Navigation & Submit ---
  Widget _buildBottomButton() {
    return GestureDetector(
      onTap: () {
        if (!_validateStep()) return;

        if (currentStep == 1) {
          _submitStep1();
        } else if (currentStep == 2) {
           setState(() {
            currentStep++;
          });
        } else if (currentStep == 3) {
          _submitStep3();
        } else if (currentStep == 4) {
          _submitStep4();
        }
      },
      child: PrimaryButton(
        title: currentStep == 4 
            ? translate("qadam.submit") 
            : translate("next"),
      ),
    );
  }

  bool _validateStep() {
    if (currentStep == 1) {
      if (licenseNumController.text.isEmpty || licenseExpiryDateController.text.isEmpty) {
        _showError(translate("fill_all_fields"));
        return false;
      }
    }
    if (currentStep == 2) {
      if (frontImage.isEmpty || backImage.isEmpty || passportImage.isEmpty) {
        _showError(translate("qadam.upload_all_docs"));
        return false;
      }
    }
    if (currentStep == 3) {
      if (carModelController.text.isEmpty || 
          carNumberController.text.isEmpty || 
          techPassportController.text.isEmpty) {
        _showError(translate("qadam.missing_docs"));
        return false;
      }
    }
    if (currentStep == 4) {
      if (techPassportFront.isEmpty || techPassportBack.isEmpty || carImages.isEmpty) {
        _showError(translate("qadam.upload_all_docs"));
        return false;
      }
    }
    return true;
  }

  void _showError(String message) {
    CenterDialog.showActionFailed(context, translate("qadam.error"), message);
  }

  // Step 1 Submit: Apply Driver
  Future<void> _submitStep1() async {
    setState(() => isLoading = true);
    
    var response = await _repository.fetchApplyDriver(
      licenseNumController.text,
      licenseExpiryDate,
      birthDate,
    );

    setState(() => isLoading = false);

    if (response.isSuccess) {
      var result = ApplyDriverResponseModel.fromJson(response.result);
      if (result.status == "success") {
        setState(() {
           currentStep++;
        });
      } else {
         _showError(result.message);
      }
    } else {
      _showError(translate("auth.connection_failed"));
    }
  }

  // Step 3 Submit: Vehicle Info
  Future<void> _submitStep3() async {
    setState(() => isLoading = true);

    var response = await _repository.fetchAddVehicleInfo(
      carNumberController.text,
      selectedVehicle.vehicleName,
      selectedColor.id,
      techPassportController.text,
      seats,
    );

    setState(() => isLoading = false);

    if (response.isSuccess) {
      if (response.result['status'] == 'success' && response.result['data'] != null) {
        final newVehicleId = response.result['data']['id']?.toString();

        if (newVehicleId != null && newVehicleId.isNotEmpty) {
          vehicleId = newVehicleId;
          setState(() {
            currentStep++;
          });
        } else {
          _showError(translate("qadam.vehicle_id_missing"));
        }
      } else {
        final errorMessage = response.result['message']?.toString() ?? translate("qadam.error");
        _showError(errorMessage);
      }
    } else {
      _showError(translate("auth.connection_failed"));
    }
  }

  // Step 4 Submit: Vehicle Images (Final)
  Future<void> _submitStep4() async {
    if (vehicleId.isEmpty) {
       _showError("Vehicle ID missing");
       return;
    }

    // Images are already uploaded one by one. Check if they exist locally to confirm flow.
    // If we wanted to be stricter, we'd verify with the backend, but local check is fine for now.
    
    // Finalize / Navigate
    CustomSnackBar().showSnackBar(context, translate("qadam.documents_uploaded"), 1);
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDocsAdded', true);
    prefs.setBool('isDocsVerified', false);
    prefs.setString("vehicle_id", vehicleId);

    setState(() {
      selectedIndex = 0;
    });

    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  void _saveToPrefs(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
}
