import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/model/credit_card_model.dart';
import 'package:qadam/src/model/trip_model.dart';
import 'package:qadam/src/theme/app_theme.dart';
import 'package:qadam/src/ui/widgets/buttons/primary_button.dart';
import 'package:qadam/src/ui/widgets/texts/text_12h_400w.dart';
import 'package:qadam/src/ui/widgets/texts/text_14h_500w.dart';
import 'package:qadam/src/ui/widgets/texts/text_18h_500w.dart';
import 'package:qadam/src/utils/utils.dart';

import '../../widgets/texts/text_14h_400w.dart';
import '../../widgets/texts/text_16h_500w.dart';
import '../main_screen.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({
    super.key,
    required this.trip,
    required this.card,
  });

  final TripModel trip;
  final CreditCardModel card;

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  String orderId = "#7654345678970";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            const SizedBox(width: 12),
            InkWell(
              borderRadius: BorderRadius.circular(40),
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.close_outlined,
                  size: 24,
                  color: AppTheme.black,
                ),
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 22, left: 16, bottom: 184, right: 16),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 16, bottom: 32, top: 8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.dark.withOpacity(0.1),
                                spreadRadius: 15,
                                blurRadius: 25,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: SvgPicture.asset(
                              "assets/images/payment_success.svg",
                              width: 100,
                              height: 100,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text18h500w(
                          title: translate("home.payment_success"),
                          color: AppTheme.green,
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.check_circle_outline,
                          size: 24,
                          color: AppTheme.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "\$${widget.trip.pricePerSeat}.00",
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppTheme.fontFamily,
                            color: AppTheme.black,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
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
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.light,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.shield_moon_outlined,
                                  size: 24,
                                  color: AppTheme.purple,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text16h500w(title: "Qadam"),
                                    SizedBox(height: 4),
                                    Text12h400w(
                                      title: "Mobile Transportation Service",
                                      color: AppTheme.gray,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const DottedLine(
                            direction: Axis.horizontal,
                            lineThickness: 2,
                            lineLength: double.infinity,
                            dashLength: 6,
                            dashColor: AppTheme.gray,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text16h500w(title: translate("home.transaction_details")),
                              const Icon(
                                Icons.keyboard_arrow_up_outlined,
                                size: 24,
                                color: AppTheme.black,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text14h400w(
                                title: translate("home.order_id"),
                                color: AppTheme.gray,
                              ),
                              const Text14h500w(title: "#7654345678970"),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text14h400w(
                                title: translate("home.card_holder_name"),
                                color: AppTheme.gray,
                              ),
                              Text14h500w(title: widget.card.cardHolderName),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text14h400w(
                                title: translate("home.card_number_hint"),
                                color: AppTheme.gray,
                              ),
                              Text14h500w(
                                  title: formatCardNumber(widget.card.cardNumber)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text14h400w(
                                title: translate("home.payment_date"),
                                color: AppTheme.gray,
                              ),
                              Text14h500w(
                                  title: Utils.scheduleDateFormat(widget.trip.startTime)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text14h400w(
                                title: translate("home.time_of_payment"),
                                color: AppTheme.gray,
                              ),
                              Text14h500w(
                                  title:
                                      "${widget.trip.startTime.hour}:${widget.trip.startTime.minute} ${widget.trip.startTime.hour > 12 ? "PM" : "AM"}"),
                            ],
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
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 56,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.purple, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.dark.withOpacity(0.1),
                        spreadRadius: 15,
                        blurRadius: 25,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text16h500w(
                      title: translate("home.get_a_receipt"),
                      color: AppTheme.purple,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
                child: GestureDetector(
                  onTap: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainScreen()),
                    );
                  },
                  child: PrimaryButton(title: translate("home.done")),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  String formatCardNumber(String cardNumber) {
    if (cardNumber.length <= 4) {
      return cardNumber; // or handle as an error, card number too short
    }
    String lastFourDigits = cardNumber.substring(cardNumber.length - 4);
    return "**** **** **** $lastFourDigits";
  }
}
