import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/model/credit_card_model.dart';
import 'package:qadam/src/model/trip_model.dart';
import 'package:qadam/src/ui/dialogs/center_dialog.dart';
import 'package:qadam/src/ui/menu/home/add_credit_card_screen.dart';
import 'package:qadam/src/ui/menu/home/payment_success_screen.dart';
import 'package:qadam/src/ui/widgets/buttons/primary_button.dart';
import 'package:qadam/src/ui/widgets/buttons/secondary_button.dart';
import 'package:qadam/src/ui/widgets/containers/card_container.dart';
import 'package:qadam/src/ui/widgets/texts/text_14h_400w.dart';
import 'package:qadam/src/ui/widgets/texts/text_14h_500w.dart';

import '../../../defaults/defaults.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/containers/leading_back.dart';
import '../../widgets/texts/text_12h_400w.dart';
import '../../widgets/texts/text_16h_500w.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.trip, this.passengersNum = 1});

  final TripModel trip;
  final int passengersNum;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String weekDay = '';
  String month = '';
  String t1 = '';
  String m1 = '';
  String h1 = '';
  String seconds = "00";
  int _timer = 720;

  CreditCardModel? selectedCard;

  String selectedCardNumber = '';

  bool isCardSelectOpen = false;

  List<CreditCardModel> cards = [];

  @override
  void initState() {
    super.initState();
    startTimer();
    initTimeState(widget.trip.startTime);
    if (cards.isNotEmpty) {
      for (int i = 0; i < cards.length; i++) {
        if (cards[i].isDefault == true) {
          selectedCard = cards[i];
          selectedCardNumber = cards[i].cardNumber;
          break;
        }
      }
    }
  }

  void startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_timer > 0) {
        setState(() {
          _timer--;
          updateTimerDisplay();
        });
        startTimer();
      } else {
        // Timer finished
        if (kDebugMode) {
          print("Timer finished!");
          // Navigator.pop(context);
        }
      }
    });
  }

  void updateTimerDisplay() {
    int remainingSeconds = _timer % 60;
    seconds = remainingSeconds.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const LeadingBack(),
        title: Text16h500w(title: translate("home.payment_details")),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
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
                    bottom: 100,
                  ),
                  children: [
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
                              Expanded(
                                child: Text14h400w(
                                  title:
                                      translate("home.complete_payment_within"),
                                  color: AppTheme.gray,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _timer < 30
                                          ? AppTheme.red
                                          : AppTheme.purple,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text14h400w(
                                      title: (_timer ~/ 60)
                                          .toString()
                                          .padLeft(2, '0'),
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.black,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _timer < 30
                                          ? AppTheme.red
                                          : AppTheme.purple,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text14h400w(
                                      title: seconds,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                "$h1:$m1 $t1",
                                style: const TextStyle(
                                  color: AppTheme.black,
                                  fontSize: 14,
                                  fontFamily: AppTheme.fontFamily,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: AppTheme.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Text(
                                "$weekDay, $month ${widget.trip.startTime.day}",
                                style: const TextStyle(
                                  color: AppTheme.gray,
                                  fontSize: 14,
                                  fontFamily: AppTheme.fontFamily,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text12h400w(
                                      title: Defaults()
                                          .regions[
                                              widget.trip.startLocation[0] - 1]
                                          .text,
                                      color: AppTheme.gray,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      safeSubstring(
                                          Defaults()
                                              .neighborhoods[
                                                  widget.trip.startLocation[2] -
                                                      1]
                                              .text,
                                          3),
                                      style: const TextStyle(
                                        fontFamily: AppTheme.fontFamily,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.black,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text12h400w(
                                      title: Defaults()
                                          .cities[
                                              widget.trip.startLocation[1] - 1]
                                          .text,
                                      color: AppTheme.gray,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: AppTheme.dark,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      DottedLine(
                                        direction: Axis.horizontal,
                                        lineThickness: 2,
                                        lineLength: ((MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        96) /
                                                    3 -
                                                40) /
                                            2,
                                        dashLength: 2,
                                        dashColor: AppTheme.gray,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppTheme.black,
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        child: SvgPicture.asset(
                                          "assets/icons/car.svg",
                                          height: 24, // Adjust size as needed
                                          width: 24,
                                          colorFilter: const ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                      DottedLine(
                                        direction: Axis.horizontal,
                                        lineThickness: 2,
                                        lineLength: ((MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        96) /
                                                    3 -
                                                40) /
                                            2,
                                        dashLength: 2,
                                        dashColor: AppTheme.gray,
                                      ),
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: AppTheme.dark,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    Defaults()
                                        .vehicles[widget.trip.vehicleId]
                                        .vehicleName,
                                    style: const TextStyle(
                                      color: AppTheme.gray,
                                      fontSize: 12,
                                      fontFamily: AppTheme.fontFamily,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text12h400w(
                                      title: Defaults()
                                          .regions[
                                              widget.trip.endLocation[0] - 1]
                                          .text,
                                      color: AppTheme.gray,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      safeSubstring(
                                          Defaults()
                                              .neighborhoods[
                                                  widget.trip.endLocation[2] -
                                                      1]
                                              .text,
                                          3),
                                      style: const TextStyle(
                                        fontFamily: AppTheme.fontFamily,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.black,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text12h400w(
                                      title: Defaults()
                                          .cities[
                                              widget.trip.endLocation[1] - 1]
                                          .text,
                                      color: AppTheme.gray,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.blue, width: 1),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outlined,
                            color: AppTheme.blue,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text14h400w(
                              title: translate("home.payment_info"),
                              color: AppTheme.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text16h500w(title: translate("home.payment")),
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
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text14h400w(
                                    title: translate("home.number_passenger"),
                                    color: AppTheme.gray,
                                  ),
                                  const SizedBox(height: 4),
                                  Text16h500w(
                                      title: "${widget.passengersNum}x"),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text14h400w(
                                    title: translate("home.price_per_seat"),
                                    color: AppTheme.gray,
                                  ),
                                  const SizedBox(height: 4),
                                  Text16h500w(
                                      title:
                                          "\$${int.parse(widget.trip.pricePerSeat) * widget.passengersNum}"),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const DottedLine(
                            dashColor: AppTheme.gray,
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 1,
                            dashLength: 4,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text16h500w(
                                title: "${translate("home.total_price")}:",
                                color: AppTheme.gray,
                              ),
                              Text(
                                "\$${(int.parse(widget.trip.pricePerSeat) * widget.passengersNum).toString()}",
                                style: const TextStyle(
                                  color: AppTheme.black,
                                  fontSize: 20,
                                  fontFamily: AppTheme.fontFamily,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 270),
                      child: Container(
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
                        child: cards.isEmpty
                            ? Row(
                                children: [
                                  Expanded(
                                    child: Text14h400w(
                                        title:
                                            translate("home.no_cards_added")),
                                  ),
                                  const SizedBox(width: 12),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return AddCreditCardScreen(
                                              onAdded: (data) {
                                                setState(() {
                                                  data.isDefault = true;
                                                  selectedCard = data;
                                                  selectedCardNumber = data.cardNumber;
                                                  cards.add(data);
                                                });
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.purple,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          Text14h400w(
                                            title: translate("home.add_card"),
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppTheme.light,
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        child: const Icon(
                                          Icons.credit_card,
                                          color: AppTheme.black,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text14h500w(
                                            title: formatCardNumber(
                                                selectedCard!.cardNumber)),
                                      ),
                                      const SizedBox(width: 12),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isCardSelectOpen =
                                                !isCardSelectOpen;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppTheme.light,
                                            borderRadius:
                                                BorderRadius.circular(24),
                                          ),
                                          child: Icon(
                                            isCardSelectOpen == false
                                                ? Icons
                                                    .keyboard_arrow_down_outlined
                                                : Icons
                                                    .keyboard_arrow_up_outlined,
                                            color: AppTheme.black,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  isCardSelectOpen == true
                                      ? Column(
                                          children: [
                                            const SizedBox(height: 16),
                                            ListView.builder(
                                              itemCount: cards.length,
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    CardContainer(
                                                      card: cards[index],
                                                      onTapped: () {
                                                        setState(() {
                                                          isCardSelectOpen =
                                                              false;
                                                        });
                                                        if (cards[index]
                                                                .isDefault ==
                                                            false) {
                                                          for (int i = 0;
                                                              i < cards.length;
                                                              i++) {
                                                            if (cards[i]
                                                                    .isDefault ==
                                                                true) {
                                                              setState(() {
                                                                cards[i].isDefault =
                                                                    false;
                                                              });
                                                            }
                                                          }
                                                          setState(() {
                                                            selectedCard =
                                                                cards[index];
                                                            cards[index]
                                                                    .isDefault =
                                                                true;
                                                            selectedCardNumber = cards[index].cardNumber;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                    index != cards.length - 1
                                                        ? Container(
                                                            height: 1,
                                                            color:
                                                                AppTheme.border,
                                                          )
                                                        : const SizedBox(),
                                                  ],
                                                );
                                              },
                                            ),
                                            const SizedBox(height: 12),
                                            SecondaryButton(
                                                title: translate(
                                                    "home.add_new_card"),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return AddCreditCardScreen(
                                                          onAdded: (data) {
                                                            setState(() {
                                                              if (cards
                                                                  .isEmpty) {
                                                                data.isDefault =
                                                                    true;
                                                                selectedCard =
                                                                    data;
                                                                selectedCardNumber = data.cardNumber;
                                                              }
                                                              cards.add(data);
                                                            });
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  );
                                                })
                                          ],
                                        )
                                      : const SizedBox(),
                                ],
                              ),
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
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 32,
                ),
                child: GestureDetector(
                  onTap: () {
                    if (selectedCardNumber.isEmpty) {
                      CenterDialog.showActionFailed(
                        context,
                        translate("home.payment_method_error"),
                        translate("home.payment_method_error_msg"),
                      );
                    } else if (selectedCard!.cardNumber.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentSuccessScreen(
                                trip: widget.trip, card: selectedCard!)),
                      );
                    }
                  },
                  child: PrimaryButton(
                    title: translate("home.confirm_payment"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  initTimeState(DateTime time) {
    m1 = time.minute < 10 ? '0${time.minute}' : time.minute.toString();
    time.weekday == 1
        ? weekDay = 'Monday'
        : time.weekday == 2
            ? weekDay = 'Tuesday'
            : time.weekday == 3
                ? weekDay = 'Wednesday'
                : time.weekday == 4
                    ? weekDay = 'Thursday'
                    : time.weekday == 5
                        ? weekDay = 'Friday'
                        : time.weekday == 6
                            ? weekDay = 'Saturday'
                            : weekDay = 'Sunday';

    time.month == 1
        ? month = 'January'
        : time.month == 2
            ? month = 'February'
            : time.month == 3
                ? month = 'March'
                : time.month == 4
                    ? month = 'April'
                    : time.month == 5
                        ? month = 'May'
                        : time.month == 6
                            ? month = 'June'
                            : time.month == 7
                                ? month = 'July'
                                : time.month == 8
                                    ? month = 'August'
                                    : time.month == 9
                                        ? month = 'September'
                                        : time.month == 10
                                            ? month = 'October'
                                            : time.month == 11
                                                ? month = 'November'
                                                : month = 'December';

    time.hour < 13 ? t1 = 'AM' : t1 = 'PM';
    h1 = time.hour < 13 ? time.hour.toString() : (time.hour - 12).toString();
  }

  String safeSubstring(String text, int length) {
    return text.length >= length
        ? text.substring(0, length).toUpperCase()
        : text.toUpperCase();
  }

  String formatCardNumber(String cardNumber) {
    if (cardNumber.length <= 4) {
      return cardNumber; // or handle as an error, card number too short
    }
    String lastFourDigits = cardNumber.substring(cardNumber.length - 4);
    return "**** **** **** $lastFourDigits";
  }
}
