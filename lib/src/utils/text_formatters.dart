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

class PriceInputFormatter extends TextInputFormatter {
  final int maxDigits;

  PriceInputFormatter({this.maxDigits = 10});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String cleaned = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (cleaned.length > maxDigits) {
      cleaned = cleaned.substring(0, maxDigits);
    }

    if (cleaned.startsWith(RegExp(r'^0+')) && cleaned.length > 1) {
      cleaned = cleaned.replaceFirst(RegExp(r'^0+'), '');
    }
    if (cleaned.isEmpty) {
      cleaned = '0';
    }

    String formatted = _addThousandSeparators(cleaned);

    int newCursorPosition = newValue.selection.baseOffset +
        (formatted.length - newValue.text.length);
    newCursorPosition = newCursorPosition.clamp(0, formatted.length);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }

  String _addThousandSeparators(String number) {
    String reversed = number.split('').reversed.join();
    List<String> groups = [];
    for (int i = 0; i < reversed.length; i += 3) {
      int end = (i + 3 < reversed.length) ? i + 3 : reversed.length;
      groups.add(reversed.substring(i, end));
    }
    return groups.join(',').split('').reversed.join();
  }
}