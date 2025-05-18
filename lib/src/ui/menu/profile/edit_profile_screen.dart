import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/model/color_model.dart';
import 'package:qadam/src/model/vehicle_model.dart';
import 'package:qadam/src/theme/app_theme.dart';
import 'package:qadam/src/ui/dialogs/bottom_dialog.dart';
import 'package:qadam/src/ui/widgets/buttons/secondary_button.dart';
import 'package:qadam/src/ui/widgets/containers/leading_back.dart';
import 'package:qadam/src/ui/widgets/textfield/main_textfield.dart';
import 'package:qadam/src/ui/widgets/texts/text_16h_500w.dart';
import 'package:qadam/src/ui/widgets/texts/text_18h_500w.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isLoadingImage = false;
  String avatar = "";

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController fatherController = TextEditingController();
  TextEditingController carModelController = TextEditingController();
  TextEditingController carNumberController = TextEditingController();
  TextEditingController carColorController = TextEditingController();
  TextEditingController colorController = TextEditingController();

  VehicleModel selectedVehicle = VehicleModel(
    id: 0,
    vehicleName: "",
  );
  ColorModel selectedColor = ColorModel(
    name: "",
    colorCode: Colors.transparent,
  );

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
                                    : CachedNetworkImage(
                                        imageUrl: "",
                                        placeholder: (context, url) =>
                                            Container(
                                          height: 64,
                                          width: 64,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: AppTheme.light,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          height: 64,
                                          width: 64,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: AppTheme.light,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.error,
                                              color: AppTheme.orange,
                                            ),
                                          ),
                                        ),
                                        height: 64,
                                        width: 64,
                                        fit: BoxFit.cover,
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
                                        BottomDialog.createUploadImageChat(
                                          context,
                                          () async {
                                            // final pickedFile = await picker.pickImage(
                                            //   source: ImageSource.gallery,
                                            // );
                                            // if (pickedFile != null) {
                                            //   setState(() {
                                            //     isLoadingImage = true;
                                            //   });
                                            //   var response = await Repository()
                                            //       .fetchProfileImageSend(
                                            //     pickedFile.path,
                                            //   );
                                            //   if (response.isSuccess) {
                                            //     setState(() {
                                            //       isLoadingImage = false;
                                            //     });
                                            //     var result = ProfileModel.fromJson(
                                            //         response.result);
                                            //     if (result.status == 1) {
                                            //       setState(() {
                                            //         isLoadingImage = false;
                                            //         snapshot.data!.avatar =
                                            //             result.user.avatar;
                                            //         avatar = result.user.avatar;
                                            //       });
                                            //       SharedPreferences prefs =
                                            //           await SharedPreferences
                                            //               .getInstance();
                                            //       prefs.setString(
                                            //         "avatar",
                                            //         result.user.avatar,
                                            //       );
                                            //       blocProfile.fetchMe();
                                            //     } else {
                                            //       setState(() {
                                            //         isLoadingImage = false;
                                            //       });
                                            //       if (response.status == -1) {
                                            //         BottomDialog.showAction(
                                            //           context,
                                            //           'Connection Failed',
                                            //           'You do not have internet connection, please try again',
                                            //           'assets/icons/alert.svg',
                                            //         );
                                            //       } else {
                                            //         BottomDialog.showAction(
                                            //           context,
                                            //           'Action Failed',
                                            //           'Uploading Image Failed, Please try again after sometime',
                                            //           'assets/icons/alert.svg',
                                            //         );
                                            //       }
                                            //     }
                                            //   } else {
                                            //     BottomDialog.showAction(
                                            //       context,
                                            //       'Action Failed',
                                            //       'Could not upload the image, please try again',
                                            //       'assets/icons/alert.svg',
                                            //     );
                                            //     setState(() {
                                            //       isLoadingImage = false;
                                            //     });
                                            //   }
                                            // }
                                          },
                                          () async {
                                            // final pickedFile = await picker.pickImage(
                                            //   source: ImageSource.camera,
                                            // );
                                            // if (pickedFile != null) {
                                            //   setState(() {
                                            //     isLoadingImage = true;
                                            //   });
                                            //   var response = await Repository()
                                            //       .fetchProfileImageSend(
                                            //     pickedFile.path,
                                            //   );
                                            //   if (response.isSuccess) {
                                            //     setState(() {
                                            //       isLoadingImage = false;
                                            //     });
                                            //     var result = ProfileModel.fromJson(
                                            //         response.result);
                                            //     if (result.status == 1) {
                                            //       setState(() {
                                            //         isLoadingImage = false;
                                            //         snapshot.data!.avatar =
                                            //             result.user.avatar;
                                            //         avatar = result.user.avatar;
                                            //       });
                                            //       SharedPreferences prefs =
                                            //           await SharedPreferences
                                            //               .getInstance();
                                            //       prefs.setString(
                                            //         "avatar",
                                            //         result.user.avatar,
                                            //       );
                                            //       blocProfile.fetchMe();
                                            //     } else {
                                            //       setState(() {
                                            //         isLoadingImage = false;
                                            //       });
                                            //       if (response.status == -1) {
                                            //         BottomDialog.showAction(
                                            //           context,
                                            //           'Connection Failed',
                                            //           'You do not have internet connection, please try again',
                                            //           'assets/icons/alert.svg',
                                            //         );
                                            //       } else {
                                            //         BottomDialog.showAction(
                                            //           context,
                                            //           'Action Failed',
                                            //           'Uploading Image Failed, Please try again after sometime',
                                            //           'assets/icons/alert.svg',
                                            //         );
                                            //       }
                                            //     }
                                            //   } else {
                                            //     BottomDialog.showAction(
                                            //       context,
                                            //       'Action Failed',
                                            //       'Could not upload the image, please try again',
                                            //       'assets/icons/alert.svg',
                                            //     );
                                            //   }
                                            // }
                                          },
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
                                      onTap: () {},
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
                        hintText: translate("profile.email"),
                        icon: Icons.email,
                        controller: emailController,
                      ),
                      const SizedBox(height: 16),
                      MainTextField(
                        hintText: translate("profile.phone"),
                        icon: Icons.phone,
                        controller: phoneController,
                      ),
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
                      // MainTextField(
                      //   hintText: translate("profile.phone"),
                      //   icon: Icons.phone,
                      //   controller: phoneController,
                      // ),
                      // const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.gray,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 5),
                              blurRadius: 25,
                              spreadRadius: 0,
                              color: AppTheme.shadow.withOpacity(0.2),
                            ),
                          ],
                        ),
                      ),
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
                        onTap: () {},
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
}
