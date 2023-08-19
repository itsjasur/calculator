// import 'package:flutter/material.dart';

// bool isOperator(String char) {
//   return ['+', '-', '*', '/'].contains(char);
// }

// List breakMe(String text) {
//   List<String> newList = [];
//   String current = "";

//   for (int i = 0; i < text.length; i++) {
//     if (isOperator(text[i])) {
//       if (current.isNotEmpty) {
//         newList.add(current);
//         current = "";
//       }
//       current += text[i];
//     } else {
//       current += text[i];
//       if (i == text.length - 1 || isOperator(text[i + 1])) {
//         newList.add(current);
//         current = "";
//       }
//     }
//   }

//   return newList;
// }

// double getStringWidth(String text, TextStyle style) {
//   final textPainter = TextPainter(
//     text: TextSpan(text: text, style: style),
//     maxLines: 1,
//     textDirection: TextDirection.ltr,
//   )..layout(minWidth: 0, maxWidth: double.infinity);

//   return textPainter.width;
// }


///
// class OperationsFormatter extends TextInputFormatter {
//   final TextStyle style;
//   final double fieldWidth;

//   OperationsFormatter({required this.style, required this.fieldWidth});

//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // final newText = newValue.text.replaceAllMapped(RegExp(r'([+\-*/])'), (match) {
    //   final operationWidth = getStringWidth(match.group(1)!, style);
    //   final currentLineWidth = getStringWidth(lastLine, style);

    //   // If the operation can fit in the remaining space on the current line, don't insert a newline
    //   if (currentLineWidth + operationWidth <= fieldWidth) {
    //     return match.group(1)!;
    //   } else {
    //     return '\n${match.group(1)}';
    //   }
    // });

//     double getStringWidth(String text, TextStyle style) {
//       final textPainter = TextPainter(
//         text: TextSpan(text: text, style: style),
//         maxLines: 1,
//         textDirection: TextDirection.ltr,
//       )..layout(minWidth: 0, maxWidth: double.infinity);

//       return textPainter.width;
//     }

//     List llist = breakMe(newValue.text);
//     print(llist);

//     String alltext = '';
//     String newline = '';

//     for (String group in llist) {
//       double newlinewidth = getStringWidth(newline, style);
//       double groupwidth = getStringWidth(group, style);

//       alltext = alltext + group;

//       // if (newlinewidth + groupwidth > fieldWidth) {
//       //   newline = newline + '\n';
//       // }
//     }

//     String newText = alltext;

//     return TextEditingValue(
//       text: newText,
//       selection: TextSelection.collapsed(offset: newText.length),
//     );
//   }
// }
