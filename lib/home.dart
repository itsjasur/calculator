import 'dart:convert';

import 'package:calculator/widgets/mytap_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/formatters.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();

  late double screenHeight;
  late double screenWidth;

  String? finalResult;

  int numberOfLines = 1;

  List history = [];
  bool showhistory = false;

  List<TextSpan> inputSpans = [];

  List operators = ['+', '-', '÷', '×', '*', '/', '%', '(', ')'];
  List mathOperators = ['+', '-', '÷', '×', '*', '/'];

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      inputSpans.clear();
      for (int i = 0; i < controller.text.length; i++) {
        if (operators.contains(controller.text[i])) {
          inputSpans.add(TextSpan(text: controller.text[i], style: const TextStyle(color: Colors.green)));
        } else {
          inputSpans.add(TextSpan(text: controller.text[i]));
        }
      }
      setState(() {});
    });
  }

  Future fetchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dataString = prefs.getString('historyList');
    if (dataString != null) {
      List data = jsonDecode(dataString);
      setState(() {
        history = data;
      });
    }
  }

  saveInHistory(String calculation, String result) async {
    history.add({'calculation': calculation, 'result': result});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dataString = jsonEncode(history);
    prefs.setString('historyList', dataString);
  }

  Future clearHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('historyList');
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    final bottomSection = screenHeight * 0.50;
    final horPadding = screenWidth * 0.05;
    final buttonMargin = screenWidth * 0.03;
    final bottomPadding = bottomSection * 0.03;
    final buttonFontSize = screenWidth * 0.07;
    final inputFontSize = screenWidth * 0.065;
    final resultFontSize = screenWidth * 0.06;

    Color numberColor = Colors.white70;
    final availableHeight = bottomSection - (4 * buttonMargin) - bottomPadding;
    final availableWidth = screenWidth - (2 * horPadding) - (3 * buttonMargin);

    List<List<Map>> buttons = [
      [
        {'type': 'brack', 'content': Text('(', style: TextStyle(fontSize: buttonFontSize, color: Colors.green)), 'operation': '('},
        {'type': 'brack', 'content': Text(')', style: TextStyle(fontSize: buttonFontSize, color: Colors.green)), 'operation': ')'},
        {'type': 'perc', 'content': Text('%', style: TextStyle(fontSize: buttonFontSize, color: Colors.green)), 'operation': '%'},
        {'type': 'oper', 'content': Text('÷', style: TextStyle(fontSize: buttonFontSize, color: Colors.green)), 'operation': '÷'},
      ],
      [
        {'type': 'numb', 'content': Text('7', style: TextStyle(fontSize: buttonFontSize, color: numberColor)), 'operation': '7'},
        {'type': 'numb', 'content': Text('8', style: TextStyle(fontSize: buttonFontSize, color: numberColor)), 'operation': '8'},
        {'type': 'numb', 'content': Text('9', style: TextStyle(fontSize: buttonFontSize, color: numberColor)), 'operation': '9'},
        {'type': 'oper', 'content': Text('×', style: TextStyle(fontSize: buttonFontSize, color: Colors.green)), 'operation': '×'},
      ],
      [
        {'type': 'numb', 'content': Text('4', style: TextStyle(fontSize: buttonFontSize, color: numberColor)), 'operation': '4'},
        {'type': 'numb', 'content': Text('5', style: TextStyle(fontSize: buttonFontSize, color: numberColor)), 'operation': '5'},
        {'type': 'numb', 'content': Text('6', style: TextStyle(fontSize: buttonFontSize, color: numberColor)), 'operation': '6'},
        {'type': 'oper', 'content': Text('-', style: TextStyle(fontSize: buttonFontSize, color: Colors.green)), 'operation': '-'},
      ],
      [
        {'type': 'numb', 'content': Text('1', style: TextStyle(fontSize: buttonFontSize, color: numberColor)), 'operation': '1'},
        {'type': 'numb', 'content': Text('2', style: TextStyle(fontSize: buttonFontSize, color: numberColor)), 'operation': '2'},
        {'type': 'numb', 'content': Text('3', style: TextStyle(fontSize: buttonFontSize, color: numberColor)), 'operation': '3'},
        {'type': 'oper', 'content': Text('+', style: TextStyle(fontSize: buttonFontSize, color: Colors.green)), 'operation': '+'},
      ],
      [
        {'type': 'clear', 'content': Text('C', style: TextStyle(fontSize: buttonFontSize, color: Colors.red)), 'operation': 'clearAll'},
        {'type': 'numb', 'content': Text('0', style: TextStyle(fontSize: buttonFontSize, color: numberColor)), 'operation': '0'},
        {'type': 'deci', 'content': Text('.', style: TextStyle(fontSize: buttonFontSize, color: numberColor)), 'operation': '.'},
        {'type': 'equal', 'content': Text('=', style: TextStyle(fontSize: buttonFontSize, color: Colors.green)), 'operation': '='},
      ],
    ];

    TextStyle calculationStyle = TextStyle(
      color: Colors.transparent,
      fontWeight: FontWeight.w500,
      fontSize: inputFontSize,
      fontStyle: FontStyle.normal,
      letterSpacing: 1.5,
      height: 1.35,
      wordSpacing: 1,
    );

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: horPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.2,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(right: 3),
                        width: double.infinity,
                        child: RichText(
                          textAlign: TextAlign.right,
                          maxLines: null,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: inputFontSize,
                              color: Colors.white.withOpacity(0.8),
                              letterSpacing: 1.5,
                              height: 1.35,
                              fontWeight: FontWeight.w500,
                              wordSpacing: 1,
                            ),
                            children: List.from(inputSpans),
                          ),
                        ),
                      ),
                      TextField(
                        textAlign: TextAlign.right,
                        controller: controller,
                        showCursor: true,
                        autofocus: true,
                        keyboardType: TextInputType.none,
                        maxLines: null,
                        style: calculationStyle,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Container(
                  height: screenHeight * 0.05,
                  alignment: Alignment.centerRight,
                  child: finalResult != null
                      ? SelectableText(
                          finalResult!,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                            fontSize: resultFontSize,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ), //topSectoin

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyTap(
                  borderRadius: 6,
                  onTap: () async {
                    await fetchHistory();
                    setState(() {
                      showhistory = !showhistory;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.007),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    width: screenWidth * 0.15,
                    height: screenHeight * 0.045,
                    child: Image.asset(
                      showhistory ? 'lib/icons/history.png' : 'lib/icons/calculator.png',
                      color: Colors.white60,
                    ),
                  ),
                ),
                MyTap(
                  borderRadius: 6,
                  onTap: () {
                    inputFormatter(
                      buttonType: 'erase',
                      horPadding: horPadding,
                      newValue: '',
                      screenWidth: screenWidth,
                      style: calculationStyle,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.007),
                    width: screenWidth * 0.15,
                    height: screenHeight * 0.045,
                    child: Image.asset('lib/icons/erase.png', color: Colors.green),
                  ),
                ),
              ],
            ),

            Divider(thickness: screenHeight * 0.0005, color: Colors.white54),
            SizedBox(height: screenHeight * 0.02),

            showhistory
                ? SizedBox(
                    height: bottomSection,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            // shrinkWrap: true,
                            reverse: true,
                            itemCount: history.length,
                            itemBuilder: (BuildContext context, int index) {
                              // history = history.reversed.toList();

                              String calculation = history[history.length - 1 - index]['calculation'];
                              String result = history[history.length - 1 - index]['result'];

                              TextStyle historyCalculationsStyle = TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.045,
                              );

                              TextStyle historyResultStyle = TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.05,
                              );

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  MyTap(
                                    onTap: () {
                                      inputFormatter(
                                        buttonType: 'pasting',
                                        horPadding: horPadding,
                                        newValue: calculation,
                                        screenWidth: screenWidth,
                                        style: calculationStyle,
                                      );
                                    },
                                    child: Text(
                                      calculation,
                                      maxLines: null,
                                      textAlign: TextAlign.end,
                                      style: historyCalculationsStyle,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.004),
                                  MyTap(
                                    onTap: () {
                                      inputFormatter(
                                        buttonType: 'pasting',
                                        horPadding: horPadding,
                                        newValue: result,
                                        screenWidth: screenWidth,
                                        style: calculationStyle,
                                      );
                                    },
                                    child: Text(
                                      '=$result',
                                      textAlign: TextAlign.end,
                                      style: historyResultStyle,
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.white.withOpacity(0.03),
                                    thickness: screenHeight * 0.001,
                                    height: screenHeight * 0.03,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        MyTap(
                          borderRadius: screenWidth * 0.05,
                          onTap: () async {
                            history.clear();
                            await clearHistory();
                            showhistory = !showhistory;
                            setState(() {});
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                            child: Text(
                              'Clear history',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: screenWidth * 0.045,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02)
                      ],
                    ),
                  )
                : SizedBox(
                    height: bottomSection, // 50% of the screen
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
                                      borderRadius: availableWidth * 0.03,
                                      onTap: () async {
                                        if (buttonType == 'clear') {
                                          controller.text = "";
                                          finalResult = null;
                                          controller.selection = const TextSelection.collapsed(offset: 0);
                                          inputSpans = [];

                                          setState(() {});
                                        } else if (buttonType == 'equal') {
                                          if (finalResult != null) {
                                            await saveInHistory(controller.text, finalResult!);
                                            controller.text = finalResult!;
                                            controller.selection = TextSelection.collapsed(offset: controller.text.length);
                                            finalResult = null;
                                            setState(() {});
                                          }
                                        } else {
                                          inputFormatter(
                                            buttonType: buttonType,
                                            horPadding: horPadding,
                                            newValue: buttonOpr,
                                            screenWidth: screenWidth,
                                            style: calculationStyle,
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: availableHeight / 5,
                                        width: availableWidth / 4,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.05),
                                          borderRadius: BorderRadius.circular(availableWidth * 0.03),
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
                  ), //bottom section
          ],
        ),
      ),
    );
  }

  void inputFormatter({required buttonType, required String newValue, required TextStyle style, required screenWidth, required horPadding}) {
    String inputText = controller.text;

    int initialInputLenght = inputText.length; // before format inputtext length

    int cursorPositionStart = controller.selection.start;
    int cursorPositionEnd = controller.selection.end;

    if (buttonType == 'erase') {
      if (cursorPositionStart == cursorPositionEnd) {
        cursorPositionStart = cursorPositionStart - 1;
      }
    }

    String prefix = inputText.substring(0, cursorPositionStart);
    String suffix = inputText.substring(cursorPositionEnd, inputText.length);

    //adding 0 in front of . if folled by no value
    if (newValue == ".") {
      if (prefix.isEmpty || operators.any((operator) => prefix.endsWith(operator))) {
        newValue = "0.";
      }
    }

    //adding * before right bracket if followed by a number
    if (newValue == '(') {
      if (prefix.isNotEmpty && !operators.any((operator) => prefix.endsWith(operator))) {
        newValue = '×$newValue';
      }
    }

    // removing previous operator if followed by another operator
    if (buttonType == 'oper') {
      prefix = removeEndingOperator(prefix, mathOperators);
      suffix = removeStartingOperator(suffix, mathOperators);
    }

    inputText = prefix + newValue + suffix;

    inputText = inputText.replaceAll(',', '');
    inputText = inputText.replaceAll('\n', '');

    // seperating operators and numbers
    List<String> listedInput = [];
    String currentNumber = '';
    for (int i = 0; i < inputText.length; i++) {
      String currentChar = inputText[i];
      if (operators.contains(currentChar)) {
        if (currentNumber.isNotEmpty) {
          listedInput.add(currentNumber);
          currentNumber = '';
        }
        listedInput.add(currentChar);
      } else {
        currentNumber += currentChar;
      }
    }
    listedInput.add(currentNumber);

    if (listedInput.length >= 3) {
      //CALCULATION LOGIC
      double? result = calculate(inputText);
      if (result != null) {
        finalResult = NumberFormat('#,###.#########').format(result);

        if (finalResult!.length >= 15) {
          finalResult = result.toStringAsExponential(10);
        }
        setState(() {});
      }
    } else {
      finalResult = null;
      setState(() {});
    }

    // formatting inputText as #,###
    List commafiedListedInput = [];
    for (String i in listedInput) {
      if (operators.contains(i)) {
        commafiedListedInput.add(i);
      } else {
        i = decimalChecker(i); // keeping only one decimal point

        if (i.endsWith('.')) {
          double? number = double.tryParse(i);
          if (number != null) {
            i = NumberFormat('#,###.#########').format(number);
            commafiedListedInput.add(i + '.');
          }
        } else {
          double? number = double.tryParse(i);
          if (number != null) {
            i = NumberFormat('#,###.#########').format(number);

            commafiedListedInput.add(i);
          }
        }
      }
    }

    //pairing number and operator in order to make them one item
    List pairedListed = [];
    String newpair = "";
    for (String i in commafiedListedInput) {
      if (buttonType != 'remove') {
        if (!isValidString(i, context)) {
          //removing the last i if length more than 15 or after decimal point more than 10
          i = i.substring(0, i.length - 1);
        }
      }

      if (mathOperators.contains(i)) {
        pairedListed.add(newpair);
        newpair = i;
      } else {
        newpair = newpair + i;
      }
    }
    pairedListed.add(newpair);

    //breaking into lines
    inputText = breakIntoLines(
      calculationStyle: style,
      newlisted: pairedListed,
      screenWidth: screenWidth,
      horPadding: horPadding,
    );

    //updating number of lines
    numberOfLines = '\n'.allMatches(inputText).length;

    // inputSpans.clear();
    // for (int i = 0; i < inputText.length; i++) {
    //   if (operators.contains(inputText[i])) {
    //     inputSpans.add(TextSpan(text: inputText[i], style: const TextStyle(color: Colors.green)));
    //   } else {
    //     inputSpans.add(TextSpan(text: inputText[i]));
    //   }
    // }
    // setState(() {});

    int currentInputLength = inputText.length; //after format inputtext length

    controller.value = TextEditingValue(
      text: inputText,
      selection: TextSelection.collapsed(offset: cursorPositionEnd + (currentInputLength - initialInputLenght)),
    );
  }
}
