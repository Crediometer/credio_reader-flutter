import 'package:credio_reader/utils/helper.dart';
import 'package:flutter/services.dart';

class AmountFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    try {
      if (oldValue == newValue) {
        return TextEditingValue(
          text: newValue.text,
          selection: TextSelection.collapsed(offset: newValue.text.length),
          composing: TextRange.empty,
        );
      }
      final amount = newValue.text != null
          ? newValue.text.replaceAll(RegExp(r'[^0-9\.]'), "")
          : "";
      final isValidNum = amount.isNotEmpty && int.tryParse(amount) != null;
      if (isValidNum) {
        final formattedText = formatCurrencyInput(amount);
        return TextEditingValue(
          text: formattedText,
          selection: TextSelection.collapsed(offset: formattedText.length),
          composing: TextRange.empty,
        );
      } else {
        return newValue;
      }
    } catch (e) {
      print(e);
      return oldValue;
    }
  }
}
