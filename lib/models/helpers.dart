import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:math_expressions/math_expressions.dart';

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
      print('AAA');
      return input.substring(0, input.length - operator.length);
    }
  }
  return input;
}

String removeStartingOperator(String input, List operators) {
  for (String operator in operators) {
    if (input.startsWith(operator)) {
      print('BBB');
      return input.substring(operator.length);
    }
  }
  return input;
}

String bracketFixer(String input, List operators) {
  String last = input[input.length - 1];

  if (!operators.contains(last)) {
    input = '$input×';
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

double? calculate(String expression) {
  expression = expression.replaceAll('×', '*');
  expression = expression.replaceAll('÷', '/');
  expression = expression.replaceAll('%', '/100');

  double? result;
  try {
    Parser p = Parser();
    Expression exp = p.parse(expression);

    ContextModel cm = ContextModel();
    result = exp.evaluate(EvaluationType.REAL, cm);
  } catch (e) {
    // print(e);
  }

  return result;
}

String formatNumber(double value) {
  if (value == value.toInt()) {
    return value.toInt().toString();
  } else {
    return value.toString();
  }
}

String customFormatNumber(double number) {
  String formatted = number.toStringAsFixed(9);
  double value = double.parse(formatted);

  if (value == value.toInt()) {
    return value.toInt().toString();
  } else {
    return value.toString();
  }
}

String commafy(String amount) {
  double value = 0;
  String stringAmount = "";

  if (amount.endsWith('.')) {
    value = double.parse(amount.substring(0, amount.length - 1));
    stringAmount = intl.NumberFormat("#,###.##########").format(value).toString();
    stringAmount = stringAmount + '.';
  } else {
    value = double.parse(amount);
    stringAmount = intl.NumberFormat("#,###.##########").format(value).toString();
  }
  return stringAmount;
}

bool isValidString(String input, BuildContext context) {
  // Check the total length
  if (input.length > 15) {
    const snackBar = SnackBar(content: Text("Can't enter more than 15 digits"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return false;
  }

  // If there's a '.' in the string, validate its position
  if (input.contains('.')) {
    int dotPosition = input.indexOf('.');

    // Check if characters after '.' are more than 10
    if (input.length - dotPosition - 1 > 10) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      const snackBar = SnackBar(content: Text("Can't enter more than 10 digits after decimal point"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
  }

  return true;
}
