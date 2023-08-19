import 'package:calculator/widgets/mytap_widget.dart';
import 'package:calculator/widgets/test.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'modals/converters.dart';
import 'modals/helpers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();
  late TextSelection _selection;

  double result = 0;
  // String rawCalc = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final topSectionSize = screenHeight * 0.20;
    final bottomSection = screenHeight * 0.57;

    final horPadding = screenWidth * 0.05;

    final buttonMargin = screenWidth * 0.03;
    final bottomPadding = bottomSection * 0.03;
    final fontSize = screenHeight * 0.035;

    final topSectionFontSize = screenHeight * 0.023;
    final resultFontSize = screenHeight * 0.026;

    final availableHeight = bottomSection - (4 * buttonMargin) - bottomPadding;
    final availableWidth = screenWidth - (2 * horPadding) - (3 * buttonMargin);

    List<List<Map>> buttons = [
      [
        {'type': 'oper', 'content': Text('(', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': '('},
        {'type': 'oper', 'content': Text(')', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': ')'},
        {'type': 'oper', 'content': Text('%', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': '%'},
        {'type': 'oper', 'content': Text('÷', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': '÷'},
      ],
      [
        {'type': 'numb', 'content': Text('7', style: TextStyle(fontSize: fontSize, color: Colors.white)), 'operation': 7},
        {'type': 'numb', 'content': Text('8', style: TextStyle(fontSize: fontSize, color: Colors.white)), 'operation': 8},
        {'type': 'numb', 'content': Text('9', style: TextStyle(fontSize: fontSize, color: Colors.white)), 'operation': 9},
        {'type': 'oper', 'content': Text('×', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': '×'},
      ],
      [
        {'type': 'numb', 'content': Text('4', style: TextStyle(fontSize: fontSize, color: Colors.white)), 'operation': 4},
        {'type': 'numb', 'content': Text('5', style: TextStyle(fontSize: fontSize, color: Colors.white)), 'operation': 5},
        {'type': 'numb', 'content': Text('6', style: TextStyle(fontSize: fontSize, color: Colors.white)), 'operation': 6},
        {'type': 'oper', 'content': Text('-', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': '-'},
      ],
      [
        {'type': 'numb', 'content': Text('3', style: TextStyle(fontSize: fontSize, color: Colors.white)), 'operation': 3},
        {'type': 'numb', 'content': Text('2', style: TextStyle(fontSize: fontSize, color: Colors.white)), 'operation': 2},
        {'type': 'numb', 'content': Text('1', style: TextStyle(fontSize: fontSize, color: Colors.white)), 'operation': 1},
        {'type': 'oper', 'content': Text('+', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': '+'},
      ],
      [
        {'type': 'clr', 'content': Text('C', style: TextStyle(fontSize: fontSize, color: Colors.red)), 'operation': clearAll},
        {'type': 'numb', 'content': Text('0', style: TextStyle(fontSize: fontSize, color: Colors.white)), 'operation': 0},
        {'type': 'oper', 'content': Text('.', style: TextStyle(fontSize: fontSize, color: Colors.white)), 'operation': '.'},
        {'type': 'eql', 'content': Text('=', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': '='},
      ],
    ];

    TextStyle style = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: topSectionFontSize);

    return Scaffold(
      // appBar: AppBar(backgroundColor: Colors.red),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: horPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SingleChildScrollView(
              child: Container(
                alignment: Alignment.bottomLeft,
                color: Colors.white10,
                height: topSectionSize,
                child: TextField(
                  textAlign: TextAlign.right,
                  controller: controller,
                  // readOnly: true,
                  showCursor: true,

                  autofocus: true,
                  maxLines: null,
                  keyboardType: TextInputType.none,
                  textInputAction: TextInputAction.newline,
                  style: style,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            Container(
              height: screenHeight * 0.05,
              alignment: Alignment.centerRight,
              child: Text(
                '123234325',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: resultFontSize,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'lib/icons/clock.png',
                    color: Colors.white60,
                    height: screenWidth * 0.06,
                  ),
                  Image.asset(
                    'lib/icons/clear.png',
                    color: Colors.green,
                    height: screenWidth * 0.08,
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.white.withOpacity(0.1),
              thickness: screenHeight * 0.001,
            ),
            SizedBox(height: screenHeight * 0.015),
            SizedBox(
              height: bottomSection,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...List.generate(
                    buttons.length,
                    (index) {
                      List perRow = buttons[index];

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ...List.generate(
                            perRow.length,
                            (index2) {
                              Map eachButton = perRow[index2];
                              String buttonType = eachButton['type'];
                              var buttonOpr = eachButton['operation'];

                              return MyTap(
                                onTap: () {
                                  final operators = ['+', '-', '%', '÷', '×'];

                                  // print(controller.value);
                                  if (buttonType == 'numb' || buttonType == 'oper') {
                                    String newchar = buttonOpr.toString();

                                    TextSelection currentSelection = controller.selection;
                                    int position = currentSelection.baseOffset;

                                    String text = controller.text;

                                    text = text.replaceAll(',', '');
                                    text = text.replaceAll('*', '×');
                                    text = text.replaceAll('/', '÷');

                                    String prefix = text.substring(0, position);
                                    String suffix = text.substring(position, text.length);

                                    //swapping operators
                                    if (prefix.isNotEmpty) {
                                      String last = prefix[prefix.length - 1];
                                      if (last == ',') {
                                        last = prefix[prefix.length - 2]; //if to be swapped is ',' swap the next one
                                      }

                                      if (operators.contains(last) && operators.contains(newchar)) {
                                        prefix = prefix.substring(0, prefix.length - 1);
                                      }
                                    }

                                    //swapping operators
                                    if (suffix.isNotEmpty) {
                                      String first = suffix[0];
                                      if (first == ',') {
                                        first = prefix[1]; //if to be swapped is ',' swap the next one
                                      }
                                      if (operators.contains(first) && operators.contains(newchar)) {
                                        suffix = suffix.substring(1);
                                      }
                                    }

                                    if (prefix.isEmpty && buttonType == 'oper') {
                                      const snackBar = SnackBar(content: Text('Invalid value'));
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      text = suffix;
                                      newchar = '';
                                    } else {
                                      text = prefix + newchar + suffix; //adding prefix + button value + suffix
                                    }

                                    int startLength = text.length;

                                    text = text.replaceAll(',', ''); //removing commas
                                    List result = listify(text, operators);

                                    text = '';
                                    for (String i in result) {
                                      if (operators.contains(i)) {
                                        text = text + i;
                                      } else {
                                        String result = commafy(int.parse(i));
                                        text = text + result;
                                      }
                                    }

                                    for (String operator in operators) {
                                      text = text.replaceAll(operator, '\n$operator');
                                    }

                                    controller.text = text;

                                    int difference = (text.length - startLength); //difference of initial and added commas
                                    controller.selection = TextSelection.collapsed(offset: prefix.length + newchar.length + difference);
                                  }

                                  if (buttonType == 'clr') clearAll();

                                  setState(() {});
                                },
                                child: Container(
                                  height: availableHeight / 5,
                                  width: availableWidth / 4,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                      availableWidth * 0.05,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: eachButton['content'],
                                ),
                              );
                            },
                          )
                        ],
                      );
                    },
                  ),
                  SizedBox(height: bottomPadding),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void clearAll() {
    controller.text = "";
    controller.selection = const TextSelection.collapsed(offset: 0); // must set cursor ofset 0 after controller.text updates
  }
}
