import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'helpers.dart';

String commafy(amount) {
  if (amount == null || amount < 0) {
    amount = 0;
  }

  String stringAmount = NumberFormat("#,###").format(amount).toString();

  return stringAmount;
}

// class OperationsFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
//     // Look for mathematical operations and ensure they start on a new line.
//     final newText = newValue.text.replaceAllMapped(RegExp(r'(?<!\n)([+\-*/])'), (match) {
//       return '\n${match.group(1)}';
//     });

//     return TextEditingValue(
//       text: newText,
//       selection: TextSelection.collapsed(offset: newText.length),
//     );
//   }
// }

// class OperationsFormatter extends TextInputFormatter {
//   final operators = ['+', '-', '%', '÷', '×'];

//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
//     String newText = newValue.text;

//     newText = newText.replaceAll(',', '');
//     newText = newText.replaceAll('*', '×');
//     newText = newText.replaceAll('/', '÷');

//     if (newText.length >= 2) {
//       final String last = newText[newText.length - 1];
//       final String secondlast = newText[newText.length - 2];

//       if (operators.contains(last) && operators.contains(secondlast)) {
//         newText = newText.replaceAll(secondlast + last, last);
//       }
//     }

//     for (String operator in operators) {
//       newText = newText.replaceAll(operator, '\n$operator');
//     }

//     // Handlig the case where multiple operators may have been replaced to prevent multiple newlines
//     newText = newText.replaceAll('\n\n', '\n');

//     List result = listify(newText, operators);
//     String finalText = '';
//     for (var i in result) {
//       if (operators.contains(i)) {
//         finalText = finalText + i;
//       } else {
//         String result = commafy(int.parse(i));
//         finalText = finalText + result;
//       }
//     }

//     // Calculate the change in length due to the replacements.
//     int lengthChange = finalText.length - newValue.text.length;

//     // Adjusting the cursor position accordingly.
//     int newOffset = newValue.selection.baseOffset + lengthChange;

//     // Ensuring newOffset is within valid range
//     newOffset = newOffset.clamp(0, finalText.length);

//     return TextEditingValue(
//       text: finalText,
//       selection: TextSelection.collapsed(offset: newOffset),
//     );
//   }
// }

class OperationsFormatter extends TextInputFormatter {
  final operators = ['+', '-', '%', '÷', '×'];

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    newText = newText.replaceAll(',', '');
    newText = newText.replaceAll('*', '×');
    newText = newText.replaceAll('/', '÷');

    if (newText.length >= 2) {
      final String last = newText[newText.length - 1];
      final String secondlast = newText[newText.length - 2];

      if (operators.contains(last) && operators.contains(secondlast)) {
        newText = newText.substring(0, newText.length - 1);
      }
    }

    for (String operator in operators) {
      newText = newText.replaceAll(operator, '\n$operator');
    }

    newText = newText.replaceAll('\n\n', '\n');

    List result = listify(newText, operators); // Mocking the behavior for now
    String finalText = '';
    for (var i in result) {
      if (operators.contains(i)) {
        finalText = finalText + i;
      } else {
        String result = commafy(int.parse(i)); // Mocking the behavior for now
        finalText = finalText + result;
      }
    }

    int lengthChange = finalText.length - newValue.text.length;
    int newOffset = newValue.selection.baseOffset + lengthChange;
    newOffset = newOffset.clamp(0, finalText.length);

    return TextEditingValue(
      text: finalText,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}

String customFormatter(text) {
  final operators = ['+', '-', '%', '÷', '×'];

  String newText = text;

  for (int i = 0; i <= newText.length; i++) {
    newText = newText.replaceAll(',', '');
    newText = newText.replaceAll('*', '×');
    newText = newText.replaceAll('/', '÷');
  }

  if (newText.length >= 2) {
    final String last = newText[newText.length - 1];
    final String secondlast = newText[newText.length - 2];

    if (operators.contains(last) && operators.contains(secondlast)) {
      newText = newText.replaceAll(secondlast + last, last);
    }
  }

  for (String operator in operators) {
    newText = newText.replaceAll(operator, '\n$operator');
  }

  // Handlig the case where multiple operators may have been replaced to prevent multiple newlines
  newText = newText.replaceAll('\n\n', '\n');

  List result = listify(newText, operators);
  String finalText = '';
  for (var i in result) {
    if (operators.contains(i)) {
      finalText = finalText + i;
    } else {
      String result = commafy(int.parse(i));
      finalText = finalText + result;
    }
  }

  return finalText;
}
