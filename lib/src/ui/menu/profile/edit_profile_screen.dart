import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qadam/src/model/color_model.dart';
import 'package:qadam/src/model/vehicle_model.dart';
import 'package:qadam/src/theme/app_theme.dart';
import 'package:qadam/src/ui/dialogs/bottom_dialog.dart';
import 'package:qadam/src/ui/widgets/buttons/secondary_button.dart';
import 'package:qadam/src/ui/widgets/containers/leading_back.dart';
import 'package:qadam/src/ui/widgets/textfield/main_textfield.dart';
import 'package:qadam/src/ui/widgets/texts/text_16h_500w.dart';
import 'package:qadam/src/ui/widgets/texts/text_18h_500w.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isLoadingImage = false;
  XFile avatar = XFile("");
  List<XFile> carImages = [];
  bool isDocsAdded = false;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController fatherController = TextEditingController();
  TextEditingController carModelController = TextEditingController();
  TextEditingController carNumberController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();

  VehicleModel selectedVehicle = VehicleModel(
    id: 0,
    vehicleName: "",
  );
  ColorModel selectedColor = ColorModel(
    titleEn: "",
    colorCode: Colors.transparent, id: 0, titleRu: '', titleUz: '',
  );

  Future<void> getDriverStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDocsAdded = prefs.getBool("isDocsAdded") ?? false;
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
        leading: const LeadingBack(),
        title: Text16h500w(title: translate("profile.account_details")),
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
                    shrinkWrap: true,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.only(
                        top: 22, bottom: 92, left: 16, right: 16),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 5),
                              blurRadius: 25,
                              spreadRadius: 0,
                              color: AppTheme.dark.withOpacity(0.2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 96,
                              width: 96,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: isLoadingImage
                                    ? Container(
                                        padding: const EdgeInsets.all(16),
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    AppTheme.purple),
                                          ),
                                        ),
                                      )
                                    : avatar.path.isNotEmpty
                                        ? Container(
                                            width: 96,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              image: DecorationImage(
                                                image: FileImage(
                                                    File(avatar.path)),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            width: 96,
                                            height: 96,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              child: Image.asset(
                                                "assets/images/avatar.jpg",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text18h500w(
                                  title: translate("profile.your_image"),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // BottomDialog.showUploadImage(
                                        //   context,
                                        //   onGallery: () {
                                        //     // final pickedFile = await picker.pickImage(
                                        //     //   source: ImageSource.gallery,
                                        //     // );
                                        //     // if (pickedFile != null) {
                                        //     //   setState(() {
                                        //     //     isLoadingImage = true;
                                        //     //   });
                                        //     //   var response = await Repository()
                                        //     //       .fetchProfileImageSend(
                                        //     //     pickedFile.path,
                                        //     //   );
                                        //     //   if (response.isSuccess) {
                                        //     //     setState(() {
                                        //     //       isLoadingImage = false;
                                        //     //     });
                                        //     //     var result = ProfileModel.fromJson(
                                        //     //         response.result);
                                        //     //     if (result.status == 1) {
                                        //     //       setState(() {
                                        //     //         isLoadingImage = false;
                                        //     //         snapshot.data!.avatar =
                                        //     //             result.user.avatar;
                                        //     //         avatar = result.user.avatar;
                                        //     //       });
                                        //     //       SharedPreferences prefs =
                                        //     //           await SharedPreferences
                                        //     //               .getInstance();
                                        //     //       prefs.setString(
                                        //     //         "avatar",
                                        //     //         result.user.avatar,
                                        //     //       );
                                        //     //       blocProfile.fetchMe();
                                        //     //     } else {
                                        //     //       setState(() {
                                        //     //         isLoadingImage = false;
                                        //     //       });
                                        //     //       if (response.status == -1) {
                                        //     //         BottomDialog.showAction(
                                        //     //           context,
                                        //     //           'Connection Failed',
                                        //     //           'You do not have internet connection, please try again',
                                        //     //           'assets/icons/alert.svg',
                                        //     //         );
                                        //     //       } else {
                                        //     //         BottomDialog.showAction(
                                        //     //           context,
                                        //     //           'Action Failed',
                                        //     //           'Uploading Image Failed, Please try again after sometime',
                                        //     //           'assets/icons/alert.svg',
                                        //     //         );
                                        //     //       }
                                        //     //     }
                                        //     //   } else {
                                        //     //     BottomDialog.showAction(
                                        //     //       context,
                                        //     //       'Action Failed',
                                        //     //       'Could not upload the image, please try again',
                                        //     //       'assets/icons/alert.svg',
                                        //     //     );
                                        //     //     setState(() {
                                        //     //       isLoadingImage = false;
                                        //     //     });
                                        //     //   }
                                        //     // }
                                        //   },
                                        //   onCamera: () {
                                        //     // final pickedFile = await picker.pickImage(
                                        //     //   source: ImageSource.camera,
                                        //     // );
                                        //     // if (pickedFile != null) {
                                        //     //   setState(() {
                                        //     //     isLoadingImage = true;
                                        //     //   });
                                        //     //   var response = await Repository()
                                        //     //       .fetchProfileImageSend(
                                        //     //     pickedFile.path,
                                        //     //   );
                                        //     //   if (response.isSuccess) {
                                        //     //     setState(() {
                                        //     //       isLoadingImage = false;
                                        //     //     });
                                        //     //     var result = ProfileModel.fromJson(
                                        //     //         response.result);
                                        //     //     if (result.status == 1) {
                                        //     //       setState(() {
                                        //     //         isLoadingImage = false;
                                        //     //         snapshot.data!.avatar =
                                        //     //             result.user.avatar;
                                        //     //         avatar = result.user.avatar;
                                        //     //       });
                                        //     //       SharedPreferences prefs =
                                        //     //           await SharedPreferences
                                        //     //               .getInstance();
                                        //     //       prefs.setString(
                                        //     //         "avatar",
                                        //     //         result.user.avatar,
                                        //     //       );
                                        //     //       blocProfile.fetchMe();
                                        //     //     } else {
                                        //     //       setState(() {
                                        //     //         isLoadingImage = false;
                                        //     //       });
                                        //     //       if (response.status == -1) {
                                        //     //         BottomDialog.showAction(
                                        //     //           context,
                                        //     //           'Connection Failed',
                                        //     //           'You do not have internet connection, please try again',
                                        //     //           'assets/icons/alert.svg',
                                        //     //         );
                                        //     //       } else {
                                        //     //         BottomDialog.showAction(
                                        //     //           context,
                                        //     //           'Action Failed',
                                        //     //           'Uploading Image Failed, Please try again after sometime',
                                        //     //           'assets/icons/alert.svg',
                                        //     //         );
                                        //     //       }
                                        //     //     }
                                        //     //   } else {
                                        //     //     BottomDialog.showAction(
                                        //     //       context,
                                        //     //       'Action Failed',
                                        //     //       'Could not upload the image, please try again',
                                        //     //       'assets/icons/alert.svg',
                                        //     //     );
                                        //     //   }
                                        //     // }
                                        //   },
                                        // );
                                        BottomDialog.showUploadImage(
                                          context,
                                          onGallery: () =>
                                              _pickImage(ImageSource.gallery),
                                          onCamera: () =>
                                              _pickImage(ImageSource.camera),
                                        );
                                      },
                                      child: Container(
                                        height: 32,
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                    192) /
                                                2,
                                        decoration: BoxDecoration(
                                          color: AppTheme.light,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: const Offset(0, 5),
                                              blurRadius: 25,
                                              spreadRadius: 0,
                                              color: AppTheme.shadow
                                                  .withOpacity(0.2),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            translate("edit"),
                                            style: const TextStyle(
                                              fontFamily: AppTheme.fontFamily,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              height: 1.375,
                                              color: AppTheme.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _deleteImage();
                                      },
                                      child: Container(
                                        height: 32,
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                    192) /
                                                2,
                                        decoration: BoxDecoration(
                                          color: AppTheme.orange,
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: const Offset(0, 10),
                                              blurRadius: 75,
                                              spreadRadius: 0,
                                              color: const Color(0xFF939393)
                                                  .withOpacity(0.07),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            translate("delete"),
                                            style: const TextStyle(
                                              fontFamily: AppTheme.fontFamily,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              height: 1.375,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      MainTextField(
                        hintText: translate("profile.first_name"),
                        icon: Icons.person,
                        controller: firstNameController,
                      ),
                      const SizedBox(height: 16),
                      MainTextField(
                        hintText: translate("profile.father_name"),
                        icon: Icons.person,
                        controller: fatherController,
                      ),
                      const SizedBox(height: 16),
                      MainTextField(
                        hintText: translate("profile.last_name"),
                        icon: Icons.person,
                        controller: lastNameController,
                      ),
                      const SizedBox(height: 16),
                      MainTextField(
                        hintText: translate("profile.email_address"),
                        icon: Icons.email,
                        controller: emailController,
                      ),
                      const SizedBox(height: 16),
                      MainTextField(
                        hintText: translate("profile.phone_number"),
                        icon: Icons.phone,
                        controller: phoneController,
                      ),
                      isDocsAdded == true? Column(
                        children: [
                          const SizedBox(height: 16),
                          Text16h500w(
                            title: translate("profile.driver_details"),
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
                                    if (value.titleEn.isNotEmpty) {
                                      if (selectedColor != value) {
                                        setState(() {
                                          selectedColor = value;
                                          colorController.text = value.titleEn;
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
                                                  _pickCarImage(ImageSource.gallery),
                                              onCamera: () =>
                                                  _pickCarImage(ImageSource.camera),
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
                                              onTap: () => _deleteCarImage(index - 1),
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
                          ),
                        ],
                      ): const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: SecondaryButton(
                        title: translate("profile.save_changes"),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
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
          avatar = image;
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

  void _deleteImage() {
    if (mounted) {
      setState(() {
        avatar = XFile("");
      });
    }
  }

  Future<void> _pickCarImage(ImageSource source) async {
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

  void _deleteCarImage(int index) {
    if (mounted) {
      setState(() {
        carImages.removeAt(index);
      });
    }
  }
}
