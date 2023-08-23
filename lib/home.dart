import 'dart:convert';
import 'package:calculator/widgets/mytap_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
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
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final topSectionSize = screenHeight * 0.20;
    final bottomSection = screenHeight * 0.50;
    final horPadding = screenWidth * 0.05;
    final buttonMargin = screenWidth * 0.03;
    final bottomPadding = bottomSection * 0.03;
    final fontSize = screenHeight * 0.034;
    final topSectionFontSize = screenHeight * 0.03;
    final resultFontSize = screenHeight * 0.028;
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
      // appBar: AppBar(),
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
                    logic(
                      buttonType: 'remove',
                      horPadding: horPadding,
                      input: '',
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
            Divider(color: Colors.white.withOpacity(0.1), thickness: screenHeight * 0.001),
            SizedBox(height: screenHeight * 0.01),
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
                              history = history.reversed.toList();

                              String calculation = history[index]['calculation'];
                              String result = history[index]['result'];

                              TextStyle calculationsStyle = TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: screenHeight * 0.02,
                              );

                              TextStyle resultStyle = TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: screenHeight * 0.024,
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
                                      calculation,
                                      maxLines: null,
                                      textAlign: TextAlign.end,
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
                                      result,
                                      textAlign: TextAlign.end,
                                      style: resultStyle,
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
                                fontSize: screenHeight * 0.02,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02)
                      ],
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
                                      borderRadius: availableWidth * 0.03,
                                      onTap: () {
                                        return logic(
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
      List calculations = listify(controller.text, operators);
      if (calculations.length <= 1) {
      } else if (finalResult != null) {
        String calculation = controller.text;
        finalResult = commafy(finalResult!, context);
        controller.text = finalResult!;
        saveInHistory(calculation, finalResult!);

        finalResult = null;
        controller.selection = TextSelection.collapsed(offset: controller.text.length);
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        const snackBar = SnackBar(content: Center(child: Text("Invalid format")));
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
        if (buttonType != 'remove') {
          if (!isValidString(i, context)) {
            //removing the last i if length more than 15 or after decimal point more than 10
            i = i.substring(0, i.length - 1);
          }
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
}
