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

String validateInput(String input, List operators, BuildContext context) {
  if (operators.contains(input)) {
    return input;
  } else {
    List<String> parts = input.split('.');
    String leftSide = parts[0];
    String rightSide = parts.length > 1 ? parts[1] : ""; // Handling the case if there's no decimal point

    if (leftSide.length > 15) {
      leftSide = leftSide.substring(0, leftSide.length - 1);

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      const snackBar = SnackBar(content: Center(child: Text("Can't enter more than 15 digits")));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    if (rightSide.length >= 9) {
      rightSide = rightSide.substring(0, rightSide.length - 1);
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      const snackBar = SnackBar(content: Center(child: Text("Can't enter more than 9 digits after decimal point")));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    input = leftSide + (parts.length > 1 ? '.$rightSide' : '');

    return input;
  }
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
  } catch (e) {}

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
