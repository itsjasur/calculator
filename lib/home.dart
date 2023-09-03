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

  List history = [];
  bool showhistory = false;

  bool equalClicked = false;

  // List<TextSpan> inputSpans = [];

  List operators = ['+', '-', '÷', '×', '*', '/', '%', '(', ')'];
  List mathOperators = ['+', '-', '÷', '×', '*', '/'];

  @override
  void initState() {
    super.initState();
    // controller.addListener(() {

    //   // inputSpans.clear();
    //   // for (int i = 0; i < controller.text.length; i++) {
    //   //   if (operators.contains(controller.text[i])) {
    //   //     inputSpans.add(TextSpan(text: controller.text[i], style: const TextStyle(color: Colors.green)));
    //   //   } else {
    //   //     inputSpans.add(TextSpan(text: controller.text[i]));
    //   //   }
    //   // }
    //   setState(() {});
    // });
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

    final bottomSection = screenHeight * 0.5;
    final horPadding = screenWidth * 0.05;
    final buttonMargin = screenWidth * 0.03;
    final bottomPadding = bottomSection * 0.03;
    final btnFontSize = screenWidth * 0.073;
    final inputFontSize = screenWidth * 0.08;
    final resultFontSize = screenWidth * 0.07;

    Color numberColor = Colors.white.withOpacity(0.8);
    final availableHeight = bottomSection - (4 * buttonMargin) - bottomPadding;
    final availableWidth = screenWidth - (2 * horPadding) - (3 * buttonMargin);

    List<List<Map>> buttons = [
      [
        {'type': 'brack', 'content': Text('(', style: TextStyle(fontWeight: FontWeight.w500, fontSize: btnFontSize, color: Colors.green)), 'operation': '('},
        {'type': 'brack', 'content': Text(')', style: TextStyle(fontWeight: FontWeight.w500, fontSize: btnFontSize, color: Colors.green)), 'operation': ')'},
        {'type': 'perc', 'content': Text('%', style: TextStyle(fontWeight: FontWeight.w500, fontSize: btnFontSize, color: Colors.green)), 'operation': '%'},
        {'type': 'oper', 'content': Text('÷', style: TextStyle(fontWeight: FontWeight.w500, fontSize: btnFontSize, color: Colors.green)), 'operation': '÷'},
      ],
      [
        {'type': 'numb', 'content': Text('7', style: TextStyle(fontWeight: FontWeight.w500, fontSize: btnFontSize, color: numberColor)), 'operation': '7'},
        {'type': 'numb', 'content': Text('8', style: TextStyle(fontWeight: FontWeight.w500, fontSize: btnFontSize, color: numberColor)), 'operation': '8'},
        {'type': 'numb', 'content': Text('9', style: TextStyle(fontWeight: FontWeight.w500, fontSize: btnFontSize, color: numberColor)), 'operation': '9'},
        {'type': 'oper', 'content': Text('×', style: TextStyle(fontWeight: FontWeight.w500, fontSize: btnFontSize, color: Colors.green)), 'operation': '×'},
      ],
      [
        {'type': 'numb', 'content': Text('4', style: TextStyle(fontWeight: FontWeight.w500, fontSize: btnFontSize, color: numberColor)), 'operation': '4'},
        {'type': 'numb', 'content': Text('5', style: TextStyle(fontWeight: FontWeight.w500, fontSize: btnFontSize, color: numberColor)), 'operation': '5'},
        {'type': 'numb', 'content': Text('6', style: TextStyle(fontWeight: FontWeight.w500, fontSize: btnFontSize, color: numberColor)), 'operation': '6'},
        {'type': 'oper', 'content': Text('-', style: TextStyle(fontWeight: FontWeight.w500, fontSize: btnFontSize, color: Colors.green)), 'operation': '-'},
      ],
      [
        {'type': 'numb', 'content': Text('1', style: TextStyle(fontWeight: FontWeight.w500, fontSize: btnFontSize, color: numberColor)), 'operation': '1'},
        {'type': 'numb', 'content': Text('2', style: TextStyle(fontWeight: FontWeight.w500, fontSize: btnFontSize, color: numberColor)), 'operation': '2'},
        {'type': 'numb', 'content': Text('3', style: TextStyle(fontWeight: FontWeight.w500, fontSize: btnFontSize, color: numberColor)), 'operation': '3'},
        {'type': 'oper', 'content': Text('+', style: TextStyle(fontWeight: FontWeight.w500, fontSize: btnFontSize, color: Colors.green)), 'operation': '+'},
      ],
      [
        {'type': 'clear', 'content': Text('C', style: TextStyle(fontWeight: FontWeight.w500, fontSize: btnFontSize, color: Colors.red)), 'operation': 'clearAll'},
        {'type': 'numb', 'content': Text('0', style: TextStyle(fontWeight: FontWeight.w500, fontSize: btnFontSize, color: numberColor)), 'operation': '0'},
        {'type': 'deci', 'content': Text('.', style: TextStyle(fontWeight: FontWeight.w500, fontSize: btnFontSize, color: numberColor)), 'operation': '.'},
        {'type': 'equal', 'content': Text('=', style: TextStyle(fontWeight: FontWeight.w500, fontSize: btnFontSize, color: Colors.green)), 'operation': '='},
      ],
    ];

    TextStyle calculationStyle = TextStyle(
      // color: Colors.transparent,
      color: equalClicked ? Colors.green : Colors.white.withOpacity(0.9),
      fontWeight: FontWeight.w500,
      fontSize: inputFontSize,
      fontStyle: FontStyle.normal,
      // letterSpacing: 1.5,
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
                  child: SingleChildScrollView(
                    reverse: true,
                    child: TextField(
                      textAlign: TextAlign.right,
                      controller: controller,
                      showCursor: true,
                      autofocus: true,
                      keyboardType: TextInputType.none,
                      maxLines: null,
                      style: calculationStyle,
                      decoration: const InputDecoration(
                        // isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                Container(
                  height: screenHeight * 0.06,
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
                    height: screenHeight * 0.04,
                    child: Image.asset(
                      showhistory ? 'lib/icons/calculator.png' : 'lib/icons/history.png',
                      color: Colors.white60,
                    ),
                  ),
                ),
                MyTap(
                  borderRadius: 6,
                  onLongPress: () {
                    inputFormatter(
                      buttonType: 'erase',
                      horPadding: horPadding,
                      newValue: '',
                      screenWidth: screenWidth,
                      style: calculationStyle,
                    );
                  },
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
                    height: screenHeight * 0.04,
                    child: Image.asset('lib/icons/erase.png', color: Colors.green),
                  ),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.005),
            Divider(thickness: screenHeight * 0.002, color: Colors.white10),
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
                            reverse: true,
                            itemCount: history.length,
                            itemBuilder: (BuildContext context, int index) {
                              // history = history.reversed.toList();

                              String calculation = history[history.length - 1 - index]['calculation'];
                              String result = history[history.length - 1 - index]['result'];

                              TextStyle historyCalculationsStyle = TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.06,
                              );

                              TextStyle historyResultStyle = TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.07,
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
                                      '= $result',
                                      textAlign: TextAlign.end,
                                      style: historyResultStyle,
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.white.withOpacity(0.05),
                                    thickness: screenHeight * 0.002,
                                    height: screenHeight * 0.05,
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
                                        setState(() {
                                          equalClicked = false;
                                        });
                                        if (buttonType == 'clear') {
                                          controller.text = "";
                                          finalResult = null;
                                          controller.selection = const TextSelection.collapsed(offset: 0);
                                          // inputSpans = [];

                                          setState(() {});
                                        } else if (buttonType == 'equal') {
                                          if (finalResult == null && controller.text.isNotEmpty) {
                                            ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                            const snackBar = SnackBar(content: Center(child: Text("Invalid format")));
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                          } else if (finalResult != null) {
                                            equalClicked = true;
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

    // inputText = inputText.replaceAll('\n', '');

    int initialInputLenght = inputText.length; // before format inputtext length

    int cursorPositionStart = controller.selection.start;
    int cursorPositionEnd = controller.selection.end;

    if (buttonType == 'erase' && cursorPositionStart > 0) {
      int count = 1;

      if (cursorPositionStart == cursorPositionEnd) {
        if (inputText[cursorPositionStart - 1] == '\n') {
          count = 2; //removing last two if last is \n
        }
        cursorPositionStart = cursorPositionStart - count;
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

    List listedInput = listify(inputText, operators);

    if (buttonType != 'remove' && buttonType != 'erase' && !operators.contains(newValue)) {
      for (String i in listedInput) {
        if (validateInput(i, context)) {
          inputText = prefix + suffix;
        }
      }
    }

    inputText = inputText.replaceAll('\n', '');
    inputText = inputText.replaceAll(',', '');

    listedInput = listify(inputText, operators);
    if (listedInput.length >= 3) {
      //CALCULATION LOGIC
      double? result = calculate(inputText);

      if (result != null) {
        if (result > 9999999) {
          finalResult = NumberFormat('#,###.######').format(result);
        } else {
          finalResult = NumberFormat('#,###.#########').format(result);
        }

        String formatlessFinalResult = finalResult!.replaceAll(',', '');

        List<String> parts = formatlessFinalResult.split('.');
        String wholePart = parts[0];
        if (wholePart.length > 15) {
          finalResult = result.toStringAsExponential(8);
        }

        setState(() {});
      } else {
        finalResult = null;
        setState(() {});
      }
    }

    // formatting inputText as #,###
    List commafiedListedInput = [];
    for (String i in listedInput) {
      if (operators.contains(i)) {
        commafiedListedInput.add(i);
      } else {
        i = decimalChecker(i); // keeping only one decimal point

        List parts = i.split('.');
        String wholePart = parts[0];
        String decimalPart = parts.length > 1 ? ('.' + parts[1]) : "";

        double? number = double.tryParse(wholePart);

        if (number != null) {
          wholePart = NumberFormat('#,###.#########').format(number);
        }

        commafiedListedInput.add(wholePart + decimalPart);
      }
    }

    //pairing number and operator in order to make them one item
    List pairedListed = [];
    String newpair = "";
    for (String i in commafiedListedInput) {
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

    int currentInputLength = inputText.length; //after format inputtext length

    controller.value = TextEditingValue(
      text: inputText,
      selection: TextSelection.collapsed(offset: cursorPositionEnd + (currentInputLength - initialInputLenght)),
    );
  }
}
