import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/model/api/add_card_model.dart';
import 'package:qadam/src/model/api/verify_card_model.dart';
import 'package:qadam/src/model/credit_card_model.dart';
import 'package:qadam/src/resources/repository.dart';
import 'package:qadam/src/ui/dialogs/center_dialog.dart';
import 'package:qadam/src/ui/dialogs/verify_card_dialog.dart';
import 'package:qadam/src/ui/widgets/buttons/primary_button.dart';
import 'package:qadam/src/ui/widgets/containers/leading_back.dart';
import 'package:qadam/src/ui/widgets/texts/text_12h_400w.dart';
import 'package:qadam/src/ui/widgets/texts/text_16h_500w.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/text_formatters.dart';
import '../../widgets/textfield/main_textfield.dart';

class AddCreditCardScreen extends StatefulWidget {
  const AddCreditCardScreen({super.key, required this.onAdded});

  final Function(CreditCardModel, String) onAdded;

  @override
  State<AddCreditCardScreen> createState() => _AddCreditCardScreenState();
}

class _AddCreditCardScreenState extends State<AddCreditCardScreen>
    with SingleTickerProviderStateMixin {
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _phoneController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _cardFadeAnimation;
  late Animation<Offset> _cardSlideAnimation;

  final Repository _repository = Repository();
  bool isLoading = false;

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
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    final user = await _repository.cacheGetMe();
    setState(() {
      _phoneController.text = user.phone;
    });
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _phoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _addCard() async {
    if (_cardNumberController.text.replaceAll(' ', '').length == 16 &&
        _cardHolderController.text.isNotEmpty &&
        _expiryDateController.text.length == 5 &&
        _phoneController.text.isNotEmpty) {
      
      setState(() {
        isLoading = true;
      });

      // 1. Send Add Card Request
      final response = await _repository.fetchAddCreditCard(
        _cardNumberController.text.replaceAll(' ', ''),
        _expiryDateController.text.replaceAll("/", ""),
        _phoneController.text,
        _cardHolderController.text,
      );

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });

      if (response.isSuccess) {
        final addCardModel = AddCardResponseModel.fromJson(response.result);
        
        if (addCardModel.status == "success") {
          final id = addCardModel.card.id;
          final cardKey = addCardModel.card.key;
          
          _showVerificationDialog(id, cardKey);
        } else {
             CenterDialog.showActionFailed(
              context,
              translate("home.card_added_error"),
              addCardModel.message.isNotEmpty 
                  ? addCardModel.message 
                  : translate("home.card_added_error_msg"),
            );
        }
      } else {
        CenterDialog.showActionFailed(
          context,
          translate("home.card_added_error"),
           response.result is Map && response.result['message'] != null ? response.result['message'] : translate("home.card_added_error_msg"),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(translate("home.fill_all_fields"))),
      );
    }
  }

  void _showVerificationDialog(int id, String cardKey) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return VerifyCardDialog(
          onVerify: (code) async {
            Navigator.pop(dialogContext); // Close dialog
            
            if (!mounted) return;
            setState(() {
              isLoading = true;
            });

            final response = await _repository.fetchVerifyCard(id, cardKey, code);

            if (!mounted) return;
            setState(() {
              isLoading = false;
            });

            if (response.isSuccess) {
                 final verifyModel = VerifyCardResponseModel.fromJson(response.result);

                 if(verifyModel.status == "success") {
                    widget.onAdded(
                       CreditCardModel(
                            id: id,
                            cardNumber: _cardNumberController.text,
                            cardHolderName: _cardHolderController.text,
                            expiryDate: _expiryDateController.text,
                            cvvCode: "", 
                        ),
                        verifyModel.message,
                    );
                    
                    // Pop back to TopUpScreen with true to trigger refresh
                    Navigator.pop(context, true);
                 } else {
                    CenterDialog.showActionFailed(
                      context,
                      translate("home.verification_failed"),
                      verifyModel.message,
                    );
                 }
            } else {
               CenterDialog.showActionFailed(
                context,
                translate("home.verification_failed"),
                response.result is Map && response.result['message'] != null ? response.result['message'] : translate("home.verification_failed_msg"),
              );
            }
          },
        );
      },
    );
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
                        phone: true,
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
                      MainTextField(
                        hintText: translate("auth.phone_number"),
                        icon: Icons.phone,
                        controller: _phoneController,
                        phone: true,
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
                              phone: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                ExpiryDateFormatter(),
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
                  onTap: _addCard,
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
             if(isLoading)
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
                      valueColor:
                      AlwaysStoppedAnimation<Color>(AppTheme.purple),
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
}
