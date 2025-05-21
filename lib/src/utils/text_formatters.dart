import 'package:flutter/services.dart';

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(' ', '');
    if (newText.length > 16) {
      newText = newText.substring(0, 16);
    }
    StringBuffer formatted = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted.write(' ');
      }
      formatted.write(newText[i]);
    }
    return TextEditingValue(
      text: formatted.toString(),
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Custom formatter for expiry date (MM/YY with auto '/')
class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll('/', '');
    if (newText.length > 4) {
      newText = newText.substring(0, 4);
    }
    StringBuffer formatted = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      if (i == 2) {
        formatted.write('/');
      }
      formatted.write(newText[i]);
    }
    return TextEditingValue(
      text: formatted.toString(),
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}