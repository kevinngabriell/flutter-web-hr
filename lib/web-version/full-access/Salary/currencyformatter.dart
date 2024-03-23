import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove non-digits and "Rp" prefix
    final cleanedText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanedText.isEmpty) {
      return newValue;
    }

    final number = int.parse(cleanedText);
    final formattedValue = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0)
        .format(number);

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.fromPosition(TextPosition(offset: formattedValue.length)),
    );
  }
}
