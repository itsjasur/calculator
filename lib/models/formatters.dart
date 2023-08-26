import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

String decimalChecker(String input) {
  List<String> parts = input.split('.');
  if (parts.length > 1) {
    String result = parts[0] + "." + parts.sublist(1).join('');
    return result;
  } else {
    return input;
  }
}

//used for measuring text width in terms of pixels
double measureTextWidth(String text, TextStyle style) {
  final textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr, // Use appropriate direction if necessary
  )..layout();

  return textPainter.width;
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

bool isValidString(String input, BuildContext context) {
  // Check the total length
  if (input.length > 15) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    const snackBar = SnackBar(content: Center(child: Text("Can't enter more than 15 digits")));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return false;
  }

  // If there's a '.' in the string, validate its position
  if (input.contains('.')) {
    int dotPosition = input.indexOf('.');

    // Check if characters after '.' are more than 10
    if (input.length - dotPosition - 1 > 10) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      const snackBar = SnackBar(content: Center(child: Text("Can't enter more than 10 digits after decimal point")));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
  }

  return true;
}

double? calculate(String expression) {
  expression = expression.replaceAll('×', '*');
  expression = expression.replaceAll('÷', '/');
  expression = expression.replaceAll('%', '/100');

  double? result;
  try {
    Parser p = Parser();
    Expression exp = p.parse(expression);
    // print(exp);

    ContextModel cm = ContextModel();
    result = exp.evaluate(EvaluationType.REAL, cm);
  } catch (e) {
    // print(e);
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