import 'package:calculator/main.dart';
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

  List operators = ['+', '-', '%', '÷', '×'];
  List secondaryOperators = ['(', ')'];
  List numbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];

  double result = 0;
  // String rawCalc = '';

  @override
  void initState() {
    super.initState();

    // controller.addListener(_handleCursorChange);
  }

  // void _handleCursorChange() {
  //   TextSelection selection = controller.selection;
  //   print("Cursor position: ${selection.start}");
  //   if (selection.isCollapsed) {
  //     print('No text is selected');
  //   } else {
  //     print('Selected text: ${controller.text.substring(selection.start, selection.end)}');
  //   }
  // }

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
    final bottomSection = screenHeight * 0.50;

    final horPadding = screenWidth * 0.05;

    final buttonMargin = screenWidth * 0.03;
    final bottomPadding = bottomSection * 0.03;
    final fontSize = screenHeight * 0.035;

    final topSectionFontSize = screenHeight * 0.023;
    final resultFontSize = screenHeight * 0.026;

    final availableHeight = bottomSection - (4 * buttonMargin) - bottomPadding;
    final availableWidth = screenWidth - (2 * horPadding) - (3 * buttonMargin);

    List calculations = [];

    List<List<Map>> buttons = [
      [
        {'type': 'brac', 'content': Text('(', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': '('},
        {'type': 'brac', 'content': Text(')', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': ')'},
        {'type': 'oper', 'content': Text('%', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': '%'},
        {'type': 'oper', 'content': Text('÷', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': '÷'},
      ],
      [
        {'type': 'numb', 'content': Text('7', style: TextStyle(fontSize: fontSize, color: Colors.white)), 'operation': '7'},
        {'type': 'numb', 'content': Text('8', style: TextStyle(fontSize: fontSize, color: Colors.white)), 'operation': '8'},
        {'type': 'numb', 'content': Text('9', style: TextStyle(fontSize: fontSize, color: Colors.white)), 'operation': '9'},
        {'type': 'oper', 'content': Text('×', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': '×'},
      ],
      [
        {'type': 'numb', 'content': Text('4', style: TextStyle(fontSize: fontSize, color: Colors.white)), 'operation': '4'},
        {'type': 'numb', 'content': Text('5', style: TextStyle(fontSize: fontSize, color: Colors.white)), 'operation': '5'},
        {'type': 'numb', 'content': Text('6', style: TextStyle(fontSize: fontSize, color: Colors.white)), 'operation': '6'},
        {'type': 'oper', 'content': Text('-', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': '-'},
      ],
      [
        {'type': 'numb', 'content': Text('3', style: TextStyle(fontSize: fontSize, color: Colors.white)), 'operation': '3'},
        {'type': 'numb', 'content': Text('2', style: TextStyle(fontSize: fontSize, color: Colors.white)), 'operation': '2'},
        {'type': 'numb', 'content': Text('1', style: TextStyle(fontSize: fontSize, color: Colors.white)), 'operation': '1'},
        {'type': 'oper', 'content': Text('+', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': '+'},
      ],
      [
        {'type': 'clr', 'content': Text('C', style: TextStyle(fontSize: fontSize, color: Colors.red)), 'operation': 'clearAll'},
        {'type': 'numb', 'content': Text('0', style: TextStyle(fontSize: fontSize, color: Colors.white)), 'operation': '0'},
        {'type': 'deci', 'content': Text('.', style: TextStyle(fontSize: fontSize, color: Colors.white)), 'operation': '.'},
        {'type': 'eql', 'content': Text('=', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': '='},
      ],
    ];

    TextStyle style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: topSectionFontSize,
      fontStyle: FontStyle.normal,
      letterSpacing: 1.0,
      wordSpacing: 2.0,
      textBaseline: TextBaseline.alphabetic,
      height: 1.0,
    );

    return Scaffold(
      // appBar: AppBar(backgroundColor: Colors.red),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: horPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              alignment: Alignment.bottomRight,
              color: Colors.white10,
              height: topSectionSize,
              child: SingleChildScrollView(
                reverse: true,
                scrollDirection: Axis.vertical,
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
                              String buttonOpr = eachButton['operation'];

                              return MyTap(
                                onTap: () {
                                  if (buttonType == 'oper' || buttonType == 'numb' || buttonType == 'deci') {
                                    TextSelection currentSelection = controller.selection;
                                    int position = currentSelection.baseOffset;

                                    String text = controller.text;

                                    String prefix = text.substring(0, position);
                                    String suffix = text.substring(position, text.length);

                                    if (buttonType == 'oper') {
                                      prefix = removeEndingOperator(prefix, operators);
                                      suffix = removeStartingOperator(suffix, operators);
                                    }

                                    text = prefix + buttonOpr + suffix;

                                    int intialLength = text.length;

                                    List listed = listify(text, operators + secondaryOperators); //seperating calcs into list
                                    text = listed.map((i) => checkDecimal(i)).join(); //removing secondary decimal dots

                                    text = text.replaceAll('\n', '');
                                    listed = listify(text, operators + secondaryOperators); //seperating calcs into list

                                    double maxWidth = (screenWidth - (horPadding * 2)) * 0.8;
                                    String newText = "";
                                    String line = "";
                                    for (String i in listed) {
                                      double iWidth = measureTextWidth(i, style);
                                      double lineWidth = measureTextWidth(line, style);

                                      if (lineWidth + iWidth <= maxWidth) {
                                        line = line + i;
                                      } else {
                                        newText = newText + line + '\n';
                                        line = i;
                                      }
                                    }

                                    text = newText + line;

                                    int processedLength = text.length;

                                    controller.text = text;
                                    controller.selection =
                                        TextSelection.collapsed(offset: prefix.length + buttonOpr.length - (intialLength - processedLength));
                                  }

                                  if (buttonType == 'clr') {
                                    clearAll();
                                  }

                                  //
                                  //
                                },
                                child: Container(
                                  height: availableHeight / 5,
                                  width: availableWidth / 4,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.01),
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
