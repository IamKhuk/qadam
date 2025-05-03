import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pinput/pinput.dart';
import 'package:qadam/src/ui/widgets/buttons/secondary_button.dart';
import 'package:qadam/src/ui/widgets/texts/text_14h_500w.dart';
import 'package:qadam/src/ui/widgets/texts/text_16h_500w.dart';
import 'dart:io';
import '../../theme/app_theme.dart';
import '../widgets/containers/leading_back.dart';
import 'login_screen.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _pinPutFocusNode = FocusNode();
  final _pinPutController = TextEditingController();
  bool _isLoading = false;
  int timer = 90;
  Timer? _timer;

  // void codeUpdated() {
  //   setState(() {
  //     _pinPutController.text = code!;
  //   });
  // }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: AppTheme.purple),
    borderRadius: BorderRadius.circular(16),
  );

  final defaultPinTheme = PinTheme(
    width: 68,
    height: 72,
    textStyle: const TextStyle(
      fontSize: 22,
      fontFamily: AppTheme.fontFamily,
      color: Colors.black,
      fontWeight: FontWeight.normal,
    ),
    decoration: BoxDecoration(
      border: Border.all(
        color: AppTheme.gray.withOpacity(0.6),
        width: 2,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 60,
        leading: const LeadingBack(),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ListView(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 22,
                bottom: 32,
              ),
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: Text14h500w(
                        title:
                            'Enter the Verification Code Sent to Your Email to complete the Registration process',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                timer > 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$timer s.',
                            style: const TextStyle(
                              fontFamily: AppTheme.fontFamily,
                              fontSize: 22,
                              fontWeight: FontWeight.normal,
                              height: 1.8,
                              color: AppTheme.gray,
                            ),
                          ),
                        ],
                      )
                    : Container(),
                const SizedBox(height: 40),
                Pinput(
                  controller: _pinPutController,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyDecorationWith(
                    border: Border.all(
                      color: AppTheme.purple,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  submittedPinTheme: defaultPinTheme,
                  validator: (s) {
                    return s == '2222' ? null : translate("auth.pin_incorrect");
                  },
                  onSubmitted: (String pin) {
                    _initPinPut(pin);
                  },
                  focusNode: _pinPutFocusNode,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onCompleted: (pin) => print(pin),
                ),
                timer == 0
                    ? Column(
                        children: [
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text16h500w(
                                title: translate("auth.no_code"),
                                color: AppTheme.black,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    timer = 120;
                                  });
                                  _startTimer();
                                },
                                child: Text16h500w(
                                  title: translate("auth.send_again"),
                                  color: AppTheme.purple,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
          Column(
            children: [
              const Spacer(),
              Row(
                children: [
                  const SizedBox(width: 24),
                  Expanded(
                    child: SecondaryButton(
                      title: translate("auth.send_code"),
                      onTap: () {
                        Navigator.of(context).popUntil(
                          (route) => route.isFirst,
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const LoginScreen();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
              SizedBox(height: Platform.isIOS ? 24 : 32),
            ],
          ),
        ],
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (t) {
        timer--;
        if (timer == 0) {
          _timer!.cancel();
        }
        setState(() {});
      },
    );
  }

  Future<void> _initPinPut(String pin) async {
    setState(() {
      _isLoading = true;
    });
    setState(() {
      _isLoading = false;
    });
  }
}
