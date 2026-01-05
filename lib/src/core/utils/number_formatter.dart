import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// A TextInputFormatter that formats numbers with thousand separators (commas)
class NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If the new value is empty, return it as is
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Extract digits only from the new value
    final newDigitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // If empty after removing non-digits, return empty
    if (newDigitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Parse the number
    final number = int.tryParse(newDigitsOnly);
    if (number == null) {
      return oldValue;
    }

    // Format with thousand separators
    final formatter = NumberFormat('#,###');
    final formatted = formatter.format(number);

    // Calculate cursor position by counting digits before cursor in new value
    final newCursor = newValue.selection.baseOffset;
    int digitsBeforeNewCursor = 0;
    for (int i = 0; i < newCursor && i < newValue.text.length; i++) {
      if (RegExp(r'\d').hasMatch(newValue.text[i])) {
        digitsBeforeNewCursor++;
      }
    }
    
    // Use the digit count from new value, but ensure it's within bounds
    int targetDigitPosition = digitsBeforeNewCursor;
    if (targetDigitPosition > newDigitsOnly.length) {
      targetDigitPosition = newDigitsOnly.length;
    }
    
    // Special case: if cursor is at the end of input, place it at the end of formatted text
    final isAtEnd = newCursor >= newValue.text.length;
    
    // Find the corresponding position in the formatted string
    int formattedCursor = 0;
    if (isAtEnd) {
      formattedCursor = formatted.length;
    } else {
      int digitsCounted = 0;
      for (int i = 0; i < formatted.length; i++) {
        if (RegExp(r'\d').hasMatch(formatted[i])) {
          digitsCounted++;
          if (digitsCounted >= targetDigitPosition) {
            formattedCursor = i + 1;
            break;
          }
        }
        formattedCursor = i + 1;
      }
      
      // If we're at the end, place cursor at the end
      if (formattedCursor > formatted.length) {
        formattedCursor = formatted.length;
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formattedCursor),
    );
  }
}

