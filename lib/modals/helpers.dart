//
//
//
//
//
//
//

import 'package:flutter/cupertino.dart';

List listify(input, operators) {
  List<String> result = [];
  String currentNumber = '';

  for (int i = 0; i < input.length; i++) {
    String currentChar = input[i];

    if (operators.contains(currentChar)) {
      if (currentNumber.isNotEmpty) {
        result.add(currentNumber);
        currentNumber = '';
      }
      result.add(currentChar);
    } else {
      currentNumber += currentChar;
    }
  }

  if (currentNumber.isNotEmpty) {
    result.add(currentNumber);
  }

  return result;
}

String removeEndingOperator(String input, List operators) {
  for (String operator in operators) {
    if (input.endsWith(operator)) {
      return input.substring(0, input.length - operator.length);
    }
  }
  return input;
}

String removeStartingOperator(String input, List operators) {
  for (String operator in operators) {
    if (input.startsWith(operator)) {
      return input.substring(operator.length);
    }
  }
  return input;
}

String checkDecimal(String input) {
  List<String> parts = input.split('.');

  if (parts.length > 1) {
    String result = parts[0] + "." + parts.sublist(1).join('');
    return result;
  } else {
    return input;
  }
}

double measureTextWidth(String text, TextStyle style) {
  final textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr, // Use appropriate direction if necessary
  )..layout();

  return textPainter.width;
}

String breakString(String input, List<String> operators, double maxLength) {
  double currentLength = 0;
  StringBuffer result = StringBuffer();

  for (int i = 0; i < input.length; i++) {
    String currentChar = input[i];

    // If the character is an operator and the current length is close to the max length
    if (operators.contains(currentChar) && currentLength >= maxLength - 1) {
      result.write('\n');
      currentLength = 0;
    }

    result.write(currentChar);
    currentLength++;

    // If the next character isn't an operator and adding it exceeds the max length, add a newline.
    if (i + 1 < input.length && !operators.contains(input[i + 1]) && currentLength >= maxLength) {
      result.write('\n');
      currentLength = 0;
    }
  }

  return result.toString();
}
