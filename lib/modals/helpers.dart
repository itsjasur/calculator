//
//
//
//
//
//
//

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
