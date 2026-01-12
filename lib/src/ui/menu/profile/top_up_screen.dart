import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/model/api/my_registered_cards_model.dart' as model;
import 'package:qadam/src/theme/app_theme.dart';
import 'package:qadam/src/ui/dialogs/snack_bar.dart';
import 'package:qadam/src/ui/dialogs/verify_card_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/credit_card_model.dart';
import '../../../resources/repository.dart';
import '../../../utils/text_formatters.dart';
import '../../../utils/utils.dart';
import '../../dialogs/center_dialog.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../widgets/containers/card_container.dart';
import '../../widgets/containers/leading_back.dart';
import '../../widgets/textfield/main_textfield.dart';
import '../../widgets/texts/text_14h_400w.dart';
import '../../widgets/texts/text_14h_500w.dart';
import '../../widgets/texts/text_16h_500w.dart';
import '../home/add_credit_card_screen.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  TextEditingController amountController = TextEditingController();

  bool isLoading = false;

  final Repository _repository = Repository();

  CreditCardModel? selectedCard;
  String selectedCardNumber = '';
  bool isCardSelectOpen = false;
  List<CreditCardModel> cards = [];

  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  Future<void> _fetchCards() async {
    setState(() {
      isLoading = true;
    });

    final response = await _repository.fetchCardList();

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });

    if (response.isSuccess) {
      final myCardsModel = model.MyCardsResponseModel.fromJson(response.result);
      if (myCardsModel.status == "success") {
        cards = myCardsModel.cards
            .map((e) => CreditCardModel(
                  id: e.id,
                  cardNumber: e.number,
                  expiryDate: e.expiry,
                  cardHolderName: e.label,
                  cvvCode: "",
                  isDefault: e.isDefault == 1,
                ))
            .toList();

        // Auto-select default or first card if available
        if (cards.isNotEmpty) {
          selectedCard = cards.firstWhere((element) => element.isDefault,
              orElse: () => cards.first);
          selectedCard!.isDefault = true;
          selectedCardNumber = selectedCard!.cardNumber;
        }
        setState(() {});
      }
    }
  }

  Future<void> _createPayment() async {
    if (amountController.text.isEmpty) {
      CenterDialog.showActionFailed(
        context,
        translate("profile.top_up_failed"),
        translate("profile.enter_amount_error"),
      );
      return;
    }

    if (selectedCard == null) {
      CenterDialog.showActionFailed(
        context,
        translate("home.payment_method_error"),
        translate("home.payment_method_error_msg"),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response = await _repository.fetchCreatePayment(
      Utils().stringToInt(amountController.text).toString(),
      cardId: selectedCard!.id.toString(),
    );

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });

    if (response.isSuccess) {
      final result = response.result;
      if (result['pay_id'] != null) {
        final payId = result['pay_id'].toString();
        _showConfirmDialog(
          payId,
          (message) {
            CustomSnackBar().showSnackBar(
              context,
              message,
              1,
            );
          },
        );
      } else {
        CustomSnackBar().showSnackBar(
          context,
          translate("profile.top_up_success"),
          1,
        );
        Navigator.pop(context);
      }
    } else {
      CenterDialog.showActionFailed(
        context,
        translate("profile.top_up_failed"),
        response.result is Map && response.result['message'] != null
            ? response.result['message']
            : translate("auth.something_went_wrong"),
      );
    }
  }

  void _showConfirmDialog(String payId, Function(String) onVerify) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return VerifyCardDialog(
          onVerify: (code) async {
            setState(() {
              isLoading = true;
            });

            final response = await _repository.fetchConfirmPayment(payId, code);

            setState(() {
              isLoading = false;
            });

            if (response.isSuccess) {
              final message = response.result['message'] ??
                  translate("profile.top_up_success");
              onVerify(message);
              Navigator.pop(dialogContext);
            } else {
              onVerify(
                  response.result is Map && response.result['message'] != null
                      ? response.result['message']
                      : translate("auth.something_went_wrong"));
              Navigator.pop(dialogContext);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const LeadingBack(),
        title: Text16h500w(title: translate("profile.top_up")),
        centerTitle: true,
        elevation: 0,
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
                      bottom: 100,
                    ),
                    children: [
                      MainTextField(
                        hintText: translate("profile.enter_top_up_amount"),
                        icon: Icons.currency_exchange_outlined,
                        controller: amountController,
                        phone: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          PriceInputFormatter(maxDigits: 10),
                        ],
                      ),
                      const SizedBox(height: 32),
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
                                      onTap: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return AddCreditCardScreen(
                                                onAdded: (data, msg) {
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 100),
                                                      () {
                                                    CustomSnackBar()
                                                        .showSnackBar(
                                                      context,
                                                      msg,
                                                      1,
                                                    );
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                        );

                                        if (result == true) {
                                          setState(() {
                                            _fetchCards();
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.purple,
                                          borderRadius:
                                              BorderRadius.circular(16),
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
                                              title: Utils().formatCardNumber(
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
                                                                i <
                                                                    cards
                                                                        .length;
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
                                                              selectedCardNumber =
                                                                  cards[index]
                                                                      .cardNumber;
                                                            });
                                                          }
                                                        },
                                                      ),
                                                      index != cards.length - 1
                                                          ? Container(
                                                              height: 1,
                                                              color: AppTheme
                                                                  .border,
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
                                                  onTap: () async {
                                                    final result =
                                                        await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return AddCreditCardScreen(
                                                            onAdded:
                                                                (data, msg) {
                                                              Future.delayed(
                                                                  const Duration(
                                                                      milliseconds:
                                                                          100),
                                                                  () {
                                                                CustomSnackBar()
                                                                    .showSnackBar(
                                                                  context,
                                                                  msg,
                                                                  1,
                                                                );
                                                              });
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    );

                                                    if (result == true) {
                                                      _fetchCards();
                                                    }
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
                    onTap: _createPayment,
                    child: PrimaryButton(
                      title: translate("home.confirm_payment"),
                    ),
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
}
