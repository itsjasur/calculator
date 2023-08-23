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
      return input.substring(0, input.length - operator.length);
    }
  }
  return input;
}

String removeDoublePercentage(String input) {
  if (input.endsWith('%')) {
    return input.substring(0, input.length - 1);
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

String? calculate(String expression) {
  String? finalResult;

  expression = expression.replaceAll('×', '*');
  expression = expression.replaceAll('÷', '/');
  expression = expression.replaceAll('%', '/100');

  double? result;
  try {
    Parser p = Parser();
    Expression exp = p.parse(expression);

    ContextModel cm = ContextModel();
    result = exp.evaluate(EvaluationType.REAL, cm);

    // return result;
    if (result != null) {
      finalResult = customFormatNumber(result);
    } else {
      finalResult = null;
    }
  } catch (e) {
    // print(e);
  }

  return finalResult;
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

String commafy(String amount, BuildContext context) {
  double value = 0;
  String stringAmount = "";

  amount = amount.replaceAll(',', ''); //removing all commas

  try {
    if (amount.endsWith('.')) {
      value = double.parse(amount.substring(0, amount.length - 1));
      stringAmount = intl.NumberFormat("#,###.##########").format(value).toString();
      stringAmount = stringAmount + '.';
    } else {
      value = double.parse(amount);
      stringAmount = intl.NumberFormat("#,###.##########").format(value).toString();
    }
  } catch (e) {
    const snackBar = SnackBar(content: Text("Invalid format"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  return stringAmount;
}

String commafyList({
  required String calculations,
  required BuildContext context,
  required List operators,
  required TextStyle calculationsStyle,
  required screenWidth,
  required horPadding,
}) {
  double value = 0;
  String listedString = "";

  List listedCalculations = listify(calculations, operators);
  String stringAmount = "";
  for (String i in listedCalculations) {
    if (!operators.contains(i)) {
      String amount = i.replaceAll(',', ''); //removing all commas

      try {
        if (amount.endsWith('.')) {
          value = double.parse(amount.substring(0, amount.length - 1));
          stringAmount = intl.NumberFormat("#,###.##########").format(value).toString();
          stringAmount = stringAmount + '.';
        } else {
          value = double.parse(amount);
          stringAmount = intl.NumberFormat("#,###.##########").format(value).toString();
        }
      } catch (e) {
        // ScaffoldMessenger.of(context).hideCurrentSnackBar();
        // const snackBar = SnackBar(content: Text("Invalid format"));
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      stringAmount = i;
    }
  }

  List newListed = listify(listedString, operators);

  listedString = breakIntoLines(
    calculationStyle: calculationsStyle,
    newlisted: newListed,
    screenWidth: screenWidth,
    horPadding: horPadding,
  );

  listedString = listedString + stringAmount;
  return listedString;
}

bool isValidString(String input, BuildContext context) {
  // Check the total length
  if (input.length > 15) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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

String breakIntoLines({required List newlisted, required double screenWidth, required horPadding, required TextStyle calculationStyle}) {
  double maxWidth = (screenWidth - (horPadding * 2)) * 0.9;
  String newText = "";
  String line = "";
  for (String i in newlisted) {
    double iWidth = measureTextWidth(i, calculationStyle);
    double lineWidth = measureTextWidth(line, calculationStyle);

    if (lineWidth + iWidth <= maxWidth) {
      line = line + i;
    } else {
      newText = newText + line + '\n';
      line = i;
    }
  }

  return newText + line;
}
