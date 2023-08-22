import 'dart:convert';

import 'package:calculator/widgets/mytap_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/helpers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();

  List operators = ['+', '-', '÷', '×', '*', '/'];
  List secondaryOperators = ['(', ')', '%'];

  List history = [];
  bool showhistory = false;

  String? finalResult;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  fetchHistory() async {
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final topSectionSize = screenHeight * 0.20;
    final bottomSection = screenHeight * 0.50;

    final horPadding = screenWidth * 0.05;

    final buttonMargin = screenWidth * 0.03;
    final bottomPadding = bottomSection * 0.03;

    final fontSize = screenHeight * 0.034;

    final topSectionFontSize = screenHeight * 0.028;

    final resultFontSize = screenHeight * 0.025;

    Color numberColor = Colors.white70;

    final availableHeight = bottomSection - (4 * buttonMargin) - bottomPadding;
    final availableWidth = screenWidth - (2 * horPadding) - (3 * buttonMargin);

    List<List<Map>> buttons = [
      [
        {'type': 'brack', 'content': Text('(', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': '('},
        {'type': 'brack', 'content': Text(')', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': ')'},
        {'type': 'perc', 'content': Text('%', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': '%'},
        {'type': 'oper', 'content': Text('÷', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': '÷'},
      ],
      [
        {'type': 'numb', 'content': Text('7', style: TextStyle(fontSize: fontSize, color: numberColor)), 'operation': '7'},
        {'type': 'numb', 'content': Text('8', style: TextStyle(fontSize: fontSize, color: numberColor)), 'operation': '8'},
        {'type': 'numb', 'content': Text('9', style: TextStyle(fontSize: fontSize, color: numberColor)), 'operation': '9'},
        {'type': 'oper', 'content': Text('×', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': '×'},
      ],
      [
        {'type': 'numb', 'content': Text('4', style: TextStyle(fontSize: fontSize, color: numberColor)), 'operation': '4'},
        {'type': 'numb', 'content': Text('5', style: TextStyle(fontSize: fontSize, color: numberColor)), 'operation': '5'},
        {'type': 'numb', 'content': Text('6', style: TextStyle(fontSize: fontSize, color: numberColor)), 'operation': '6'},
        {'type': 'oper', 'content': Text('-', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': '-'},
      ],
      [
        {'type': 'numb', 'content': Text('1', style: TextStyle(fontSize: fontSize, color: numberColor)), 'operation': '1'},
        {'type': 'numb', 'content': Text('2', style: TextStyle(fontSize: fontSize, color: numberColor)), 'operation': '2'},
        {'type': 'numb', 'content': Text('3', style: TextStyle(fontSize: fontSize, color: numberColor)), 'operation': '3'},
        {'type': 'oper', 'content': Text('+', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': '+'},
      ],
      [
        {'type': 'clear', 'content': Text('C', style: TextStyle(fontSize: fontSize, color: Colors.red)), 'operation': 'clearAll'},
        {'type': 'numb', 'content': Text('0', style: TextStyle(fontSize: fontSize, color: numberColor)), 'operation': '0'},
        {'type': 'deci', 'content': Text('.', style: TextStyle(fontSize: fontSize, color: numberColor)), 'operation': '.'},
        {'type': 'equal', 'content': Text('=', style: TextStyle(fontSize: fontSize, color: Colors.green)), 'operation': '='},
      ],
    ];

    TextStyle calculationStyle = TextStyle(
      color: Colors.white.withOpacity(0.8),
      fontWeight: FontWeight.bold,
      fontSize: topSectionFontSize,
      fontStyle: FontStyle.normal,
      letterSpacing: 1.0,
      wordSpacing: 2.0,
      textBaseline: TextBaseline.alphabetic,
      height: 1.35,
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
                  style: calculationStyle,
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
              height: screenHeight * 0.08,
              alignment: Alignment.centerRight,
              child: finalResult != null
                  ? SelectableText(
                      commafy(finalResult!, context),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                        fontSize: resultFontSize,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: horPadding),
              height: screenHeight * 0.04,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyTap(
                    onTap: () {
                      setState(() {
                        showhistory = !showhistory;
                      });
                    },
                    child: Image.asset(
                      'lib/icons/clock.png',
                      color: Colors.white60,
                      height: screenWidth * 0.053,
                    ),
                  ),
                  MyTap(
                    onTap: () {
                      logic(
                        buttonType: 'remove',
                        horPadding: horPadding,
                        input: '',
                        screenWidth: screenWidth,
                        style: calculationStyle,
                      );
                    },
                    child: Image.asset(
                      'lib/icons/clear.png',
                      color: Colors.green,
                      height: screenWidth * 0.075,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white.withOpacity(0.1), thickness: screenHeight * 0.001),
            SizedBox(height: screenHeight * 0.01),
            showhistory
                ? SizedBox(
                    height: bottomSection,
                    child: ListView.builder(
                      reverse: true,
                      itemCount: history.length,
                      itemBuilder: (BuildContext context, int index) {
                        String calculation = history[index]['calculation'];
                        String result = history[index]['result'];

                        TextStyle calculationsStyle = TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight * 0.020,
                        );

                        TextStyle resultStyle = TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight * 0.025,
                        );

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            MyTap(
                              onTap: () {
                                logic(
                                  buttonType: 'history',
                                  input: calculation,
                                  style: calculationsStyle,
                                  screenWidth: screenWidth,
                                  horPadding: horPadding,
                                );
                              },
                              child: Text(
                                maxLines: null,
                                textAlign: TextAlign.end,
                                commafyList(
                                  calculations: calculation,
                                  context: context,
                                  operators: operators,
                                  calculationsStyle: calculationsStyle,
                                  horPadding: horPadding,
                                  screenWidth: screenWidth,
                                ),
                                style: calculationsStyle,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.004),
                            MyTap(
                              onTap: () {
                                logic(
                                  buttonType: 'history',
                                  input: result,
                                  style: calculationsStyle,
                                  screenWidth: screenWidth,
                                  horPadding: horPadding,
                                );
                              },
                              child: Text(
                                '=${commafy(result, context)}',
                                style: resultStyle,
                              ),
                            ),
                            Divider(color: Colors.white.withOpacity(0.03), thickness: screenHeight * 0.001),
                          ],
                        );
                      },
                    ),
                  )
                : SizedBox(
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
                                        logic(
                                          buttonType: buttonType,
                                          horPadding: horPadding,
                                          input: buttonOpr,
                                          screenWidth: screenWidth,
                                          style: calculationStyle,
                                        );
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

  logic({required buttonType, required String input, required TextStyle style, required screenWidth, required horPadding}) {
    if (buttonType == 'clear') {
      controller.text = "";
      // must set cursor ofset 0 after controller.text updates
      controller.selection = const TextSelection.collapsed(offset: 0);
      finalResult = null;
    } else if (buttonType == 'equal') {
      if (finalResult != null) {
        saveInHistory(controller.text, finalResult!);

        controller.text = commafy(finalResult!, context);
        finalResult = null;
        controller.selection = TextSelection.collapsed(offset: controller.text.length);
      } else {
        const snackBar = SnackBar(content: Text("Invalid format"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      TextSelection currentSelection = controller.selection;
      int position = currentSelection.baseOffset;

      String text = controller.text;

      String prefix = text.substring(0, position);
      String suffix = text.substring(position, text.length);

      // removing previous operator if followed by another operator
      if (buttonType == 'oper') {
        prefix = removeEndingOperator(prefix, operators);
        suffix = removeStartingOperator(suffix, operators);
      }

      if (input == "%" && prefix.endsWith('%')) {
        input = "";
      }

      if (input == ".") {
        if (prefix.isEmpty || operators.any((operator) => prefix.endsWith(operator))) {
          input = "0.";
        }
      }

      //adding * before right bracket if followed by a number
      if (input == '(') {
        if (prefix.isNotEmpty && !operators.any((operator) => prefix.endsWith(operator))) {
          input = '×$input';
        }
      }

      if (buttonType == 'remove') {
        if (prefix.isNotEmpty) {
          prefix = prefix.substring(0, prefix.length - (prefix.endsWith(',') ? 2 : 1));
          text = prefix + suffix; //if ends with , remove 2 chars
        }
      } else {
        text = prefix + input + suffix;
      }

      int intialLength = text.length;

      text = text.replaceAll('\n', '');
      text = text.replaceAll(',', ''); //removing all commas
      List listed = listify(text, operators + secondaryOperators); //seperating calcs into list
      text = listed.map((i) => checkDecimal(i)).join(); //removing secondary decimal dots

      if (listed.length >= 3) {
        //CALCULATION LOGIC
        finalResult = calculate(text);
        setState(() {});
      } else {
        finalResult = null;
        setState(() {});
      }

      listed = listify(text, operators + secondaryOperators); //seperating calcs into list

      List newlisted = [];
      String newpair = "";
      for (String i in listed) {
        if (!isValidString(i, context)) {
          //removing the last i if length more than 15 or after decimal point more than 10
          i = i.substring(0, i.length - 1);
        }

        if (operators.contains(i) || secondaryOperators.contains(i)) {
          newlisted.add(newpair);
          newpair = i;
        } else {
          newpair = newpair + commafy(i, context);
        }
      }
      newlisted.add(newpair);

      text = breakIntoLines(
        calculationStyle: style,
        newlisted: newlisted,
        screenWidth: screenWidth,
        horPadding: horPadding,
      );

      int processedLength = text.length;

      controller.text = text;
      controller.selection = TextSelection.collapsed(offset: prefix.length + input.length - (intialLength - processedLength));
    }

    setState(() {});
  }

  // if (buttonType == 'clear') {
  //   controller.text = "";
  //   // must set cursor ofset 0 after controller.text updates
  //   controller.selection = const TextSelection.collapsed(offset: 0);
  //   finalResult = null;
  //   setState(() {});
  // }
  // if (buttonType == 'equal') {
  //   if (finalResult != null) {
  //     saveInHistory(controller.text, finalResult!);

  //     controller.text = commafy(finalResult!, context);
  //     finalResult = null;
  //     controller.selection = TextSelection.collapsed(offset: controller.text.length);
  //   } else {
  //     const snackBar = SnackBar(content: Text("Invalid format"));
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   }
  // }
  // }
}
