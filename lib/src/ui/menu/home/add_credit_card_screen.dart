import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/model/credit_card_model.dart';
import 'package:qadam/src/ui/widgets/buttons/primary_button.dart';
import 'package:qadam/src/ui/widgets/containers/leading_back.dart';
import 'package:qadam/src/ui/widgets/texts/text_12h_400w.dart';
import 'package:qadam/src/ui/widgets/texts/text_16h_500w.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/text_formatters.dart';
import '../../widgets/textfield/main_textfield.dart';

class AddCreditCardScreen extends StatefulWidget {
  const AddCreditCardScreen({super.key, required this.onAdded});

  final Function(CreditCardModel) onAdded;

  @override
  State<AddCreditCardScreen> createState() => _AddCreditCardScreenState();
}

class _AddCreditCardScreenState extends State<AddCreditCardScreen>
    with SingleTickerProviderStateMixin {
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _cardFadeAnimation;
  late Animation<Offset> _cardSlideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _cardFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _cardSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text16h500w(title: translate("home.add_credit_card_title")),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const LeadingBack(),
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
                    padding: const EdgeInsets.only(
                      top: 22,
                      left: 16,
                      right: 16,
                      bottom: 88,
                    ),
                    children: [
                      FadeTransition(
                        opacity: _cardFadeAnimation,
                        child: SlideTransition(
                          position: _cardSlideAnimation,
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.purple,
                                  AppTheme.purple.withOpacity(0.8)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _cardNumberController.text.isEmpty
                                      ? translate(
                                          "home.card_number_placeholder")
                                      : _cardNumberController.text,
                                  style: const TextStyle(
                                    fontFamily: AppTheme.fontFamily,
                                    fontSize: 24,
                                    color: Colors.white,
                                    letterSpacing: 2,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text12h400w(
                                          title: translate(
                                              "home.card_holder_label"),
                                          color: Colors.white70,
                                        ),
                                        Text16h500w(
                                          title: _cardHolderController
                                                  .text.isEmpty
                                              ? translate(
                                                  "home.card_holder_placeholder")
                                              : _cardHolderController.text,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text12h400w(
                                          title:
                                              translate("home.expires_label"),
                                          color: Colors.white70,
                                        ),
                                        Text16h500w(
                                          title: _expiryDateController
                                                  .text.isEmpty
                                              ? translate(
                                                  "home.expiry_date_placeholder")
                                              : _expiryDateController.text,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Input Fields
                      MainTextField(
                        hintText: translate("home.card_number_hint"),
                        icon: Icons.credit_card,
                        controller: _cardNumberController,
                        phone: false,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CardNumberFormatter(),
                        ],
                      ),
                      const SizedBox(height: 16),
                      MainTextField(
                        hintText: translate("home.cardholder_name_hint"),
                        icon: Icons.person,
                        controller: _cardHolderController,
                        phone: false,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: MainTextField(
                              hintText:
                                  translate("home.expiry_date_placeholder"),
                              icon: Icons.calendar_today,
                              controller: _expiryDateController,
                              phone: false,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                ExpiryDateFormatter(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: MainTextField(
                              hintText: translate("home.cvv_hint"),
                              icon: Icons.lock,
                              controller: _cvvController,
                              phone: false,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                            ),
                          ),
                        ],
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
                  onTap: () {
                    if (_cardNumberController.text.replaceAll(' ', '').length ==
                            16 &&
                        _cardHolderController.text.isNotEmpty &&
                        _expiryDateController.text.length == 5 &&
                        _cvvController.text.length == 3) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text(translate("home.card_added_success"))),
                      );
                      widget.onAdded(
                        CreditCardModel(
                          cardNumber: _cardNumberController.text,
                          cardHolderName: _cardHolderController.text,
                          expiryDate: _expiryDateController.text,
                          cvvCode: _cvvController.text,
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(translate("home.fill_all_fields"))),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: PrimaryButton(
                      title: translate("home.add_card_button"),
                    ),
                  ),
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
