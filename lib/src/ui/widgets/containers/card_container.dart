import 'package:flutter/material.dart';
import 'package:qadam/src/ui/widgets/texts/text_14h_500w.dart';

import '../../../model/credit_card_model.dart';
import '../../../theme/app_theme.dart';

class CardContainer extends StatefulWidget {
  const CardContainer({super.key, required this.card, required this.onTapped});

  final CreditCardModel card;
  final Function() onTapped;

  @override
  State<CardContainer> createState() => _CardContainerState();
}

class _CardContainerState extends State<CardContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTapped,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: AppTheme.light,
        child: Row(
          children: [
            Expanded(
              child: Text14h500w(
                title: formatCardNumber(widget.card.cardNumber), color: AppTheme.dark,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: widget.card.isDefault == true ? AppTheme.purple : AppTheme.light,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.black,
                  width: 1,
                ),
              ),
            )
          ],
        ),
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
