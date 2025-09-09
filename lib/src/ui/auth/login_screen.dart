import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/ui/auth/verification_screen.dart';
import 'package:qadam/src/ui/widgets/texts/text_16h_500w.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/api/login_model.dart';
import '../../model/api/register_model.dart';
import '../../resources/repository.dart';
import '../../theme/app_theme.dart';
import '../../utils/validators.dart';
import '../dialogs/center_dialog.dart';
import '../menu/main_screen.dart';
import '../widgets/buttons/secondary_button.dart';
import '../widgets/textfield/main_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool isLogin = true;

  Repository _repository = Repository();

  /// Login
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();

  /// Register
  TextEditingController phoneRegController = TextEditingController();
  TextEditingController passRegController = TextEditingController();
  TextEditingController passAgainController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                Container(
                  color: AppTheme.black,
                  child: Container(
                    padding:
                        const EdgeInsets.only(top: 98, left: 16, right: 16),
                    height: MediaQuery.sizeOf(context).height / 2.2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/images/intersect.png'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.05),
                          BlendMode.srcIn,
                        ),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.centerLeft,
                        colors: [
                          AppTheme.purple.withOpacity(0.4),
                          AppTheme.purple.withOpacity(0.01),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${translate("auth.hello")},\n${translate("auth.welcome_back")}",
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppTheme.fontFamily,
                                height: 1.4,
                                letterSpacing: 1,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text16h500w(
                                title: translate("auth.please_enter"),
                                color: AppTheme.light,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 470),
                    margin: EdgeInsets.only(top: isLogin ? 340 : 0),
                    // Ensure full width
                    padding: EdgeInsets.only(
                      left: 16.0 * MediaQuery.textScalerOf(context).scale(1),
                      right: 16.0 * MediaQuery.textScalerOf(context).scale(1),
                      top: 0,
                      bottom: 24.0,
                    ),
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(isLogin ? 32 : 0),
                        topLeft: Radius.circular(isLogin ? 32 : 0),
                      ),
                    ),
                  ),
                  Container(
                    height: isLogin
                        ? MediaQuery.of(context).size.height - 340
                        : MediaQuery.of(context).size.height - 22,
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: isLogin ? 0 : 98),
                      physics: isLogin
                          ? const NeverScrollableScrollPhysics()
                          : const AlwaysScrollableScrollPhysics(),
                      children: [
                        Container(
                          height: 56,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.light,
                            borderRadius: BorderRadius.circular(56),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (!isLogin) {
                                      setState(() {
                                        isLogin = true;
                                      });
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 280),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: isLogin
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(40),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, 5),
                                          blurRadius: 8,
                                          color: isLogin
                                              ? AppTheme.dark.withOpacity(0.2)
                                              : Colors.transparent,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        translate("auth.login"),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: AppTheme.fontFamily,
                                          height: 1.5,
                                          letterSpacing: 0.5,
                                          color: isLogin
                                              ? AppTheme.black
                                              : AppTheme.dark,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (isLogin) {
                                      setState(() {
                                        isLogin = false;
                                      });
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 280),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: isLogin
                                          ? Colors.transparent
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(40),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, 8),
                                          blurRadius: 8,
                                          color: isLogin
                                              ? Colors.transparent
                                              : AppTheme.dark.withOpacity(0.2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        translate("auth.sign_up"),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: AppTheme.fontFamily,
                                          height: 1.5,
                                          letterSpacing: 0.5,
                                          color: isLogin
                                              ? AppTheme.dark
                                              : AppTheme.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        isLogin
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  MainTextField(
                                    hintText: translate("auth.phone_number"),
                                    icon: Icons.phone_outlined,
                                    controller: phoneController,
                                    phone: true,
                                  ),
                                  const SizedBox(height: 16),
                                  MainTextField(
                                    hintText: translate("auth.password"),
                                    icon: Icons.lock_outline_rounded,
                                    controller: passController,
                                    pass: true,
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  MainTextField(
                                    hintText: translate("auth.first_name"),
                                    icon: Icons.person_outline_rounded,
                                    controller: firstNameController,
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    height: 66,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          offset:
                                          const Offset(0, 4),
                                          blurRadius: 100,
                                          spreadRadius: 0,
                                          color: AppTheme.black
                                              .withOpacity(0.05),
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: lastNameController,
                                      textAlignVertical: TextAlignVertical.center,
                                      cursorColor: AppTheme.purple,
                                      enableInteractiveSelection: true,
                                      obscureText: false,
                                      style: const TextStyle(
                                        fontFamily: AppTheme.fontFamily,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        height: 1.5,
                                        color: AppTheme.black,
                                      ),
                                      keyboardType: TextInputType.text,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        border:
                                        const OutlineInputBorder(),
                                        enabledBorder:
                                        OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(16),
                                          borderSide:
                                          const BorderSide(
                                              color: AppTheme
                                                  .border),
                                        ),
                                        focusedBorder:
                                        OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(16),
                                          borderSide:
                                          const BorderSide(
                                            color:
                                            AppTheme.purple,
                                          ),
                                        ),
                                        contentPadding:
                                        const EdgeInsets
                                            .symmetric(
                                          vertical: 20,
                                          horizontal: 16,
                                        ),
                                        labelText: translate("auth.last_name"),
                                        labelStyle: TextStyle(
                                          fontFamily: AppTheme.fontFamily,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: AppTheme.dark.withOpacity(0.6),
                                        ),
                                        prefixIcon: const Icon(Icons.person_outline_rounded),
                                        prefixIconColor: MaterialStateColor.resolveWith(
                                              (Set<MaterialState> states) {
                                            if (states.contains(MaterialState.focused)) {
                                              return AppTheme.black;
                                            }
                                            return AppTheme.dark;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  MainTextField(
                                    hintText: translate("auth.father_name"),
                                    icon: Icons.person_outline_rounded,
                                    controller: fatherNameController,
                                  ),
                                  const SizedBox(height: 16),
                                  MainTextField(
                                    hintText: translate("auth.phone_number"),
                                    icon: Icons.phone_outlined,
                                    controller: phoneRegController,
                                    phone: true,
                                  ),
                                  const SizedBox(height: 16),
                                  MainTextField(
                                    hintText: translate("auth.email"),
                                    icon: Icons.email_outlined,
                                    controller: emailController,
                                  ),
                                  const SizedBox(height: 16),
                                  MainTextField(
                                    hintText: translate("auth.password"),
                                    icon: Icons.lock_outline_rounded,
                                    controller: passRegController,
                                    pass: true,
                                  ),
                                  const SizedBox(height: 16),
                                  MainTextField(
                                    hintText:
                                        translate("auth.confirm_password"),
                                    icon: Icons.lock_outline_rounded,
                                    controller: passAgainController,
                                    pass: true,
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 24,
                  ),
                  child: SecondaryButton(
                    title: isLogin
                        ? translate("auth.login")
                        : translate("auth.register"),
                    onTap: () async {
                      if (isLogin == true) {
                        setState(() {
                          isLoading = true;
                        });
                        var response = await _repository.fetchLogin(
                          phoneController.text,
                          passController.text,
                        );

                        var result = LoginModel.fromJson(response.result);

                        if (response.isSuccess) {
                          setState(() {
                            isLoading = false;
                          });
                          if (result.status == "success") {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString(
                                "token", result.authorisation.token);
                            prefs.setBool("isFirst", false);
                            prefs.setString(
                              "token_date",
                              "${result.user.createdAt.day}-${result.user.createdAt.month}-${result.user.createdAt.year}",
                            );
                            await _repository.cacheLoginUser(result.user);
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
                              translate("auth.login_failed"),
                              result.message,
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
                      } else {
                        String phone = phoneRegController.text;

                        setState(() {
                          phone = phone.replaceAll(' ', '');
                          phone = phone.replaceAll('-', '');
                          if (phone.contains("+") == false) {
                            phone = "+$phone";
                          }
                        });

                        if (firstNameController.text.isNotEmpty &&
                            lastNameController.text.isNotEmpty &&
                            fatherNameController.text.isNotEmpty &&
                            emailController.text.isNotEmpty &&
                            phoneRegController.text.isNotEmpty &&
                            passRegController.text.isNotEmpty &&
                            Validators.phoneNumberValidator(phone) == true &&
                            Validators.passwordValidator(
                                    passRegController.text) ==
                                true &&
                            passAgainController.text ==
                                passRegController.text) {
                          setState(() {
                            isLoading = true;
                          });
                          var response = await _repository.fetchRegister(
                            firstNameController.text,
                            lastNameController.text,
                            fatherNameController.text,
                            emailController.text,
                            phone,
                            passRegController.text,
                            passAgainController.text,
                          );
                          var result = RegisterModel.fromJson(
                            response.result,
                          );
                          if (response.isSuccess) {
                            setState(() {
                              isLoading = false;
                            });
                            if (result.status == "success") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return VerificationScreen(
                                      phone: phone,
                                      code: result.code.toString(),
                                    );
                                  },
                                ),
                              );
                            } else {
                              CenterDialog.showActionFailed(
                                context,
                                translate("auth.register_failed"),
                                result.message,
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
                        } else if (firstNameController.text.isEmpty ||
                            lastNameController.text.isEmpty ||
                            fatherNameController.text.isEmpty ||
                            emailController.text.isEmpty ||
                            phoneRegController.text.isEmpty ||
                            passRegController.text.isEmpty ||
                            passAgainController.text.isEmpty) {
                          CenterDialog.showActionFailed(
                            context,
                            'Error',
                            'Please fill the forms to sign up',
                          );
                        } else if (Validators.phoneNumberValidator(
                                phoneRegController.text) ==
                            false) {
                          CenterDialog.showActionFailed(
                            context,
                            'Error',
                            'Please enter valid phone number',
                          );
                        } else if (Validators.passwordValidator(
                                passRegController.text) ==
                            false) {
                          CenterDialog.showActionFailed(
                            context,
                            'Password Error',
                            'Your password must contain at least one:\n- Uppercase letter\n- Special character\n- Number (0,...,9)',
                          );
                        } else if (passAgainController.text !=
                            passRegController.text) {
                          CenterDialog.showActionFailed(
                            context,
                            'Password Error',
                            'Confirming password must be the same as previously entered password',
                          );
                        } else {
                          resetValues();
                          CenterDialog.showActionFailed(
                            context,
                            'Error',
                            'Something went wrong\nPlease try again',
                          );
                        }
                      }
                    },
                  ),
                )
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

  void resetValues() {
    phoneController.clear();
    passController.clear();
    firstNameController.clear();
    lastNameController.clear();
    fatherNameController.clear();
    phoneRegController.clear();
    passRegController.clear();
    passAgainController.clear();
  }
}
