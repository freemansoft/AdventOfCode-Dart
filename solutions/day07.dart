import '../utils/index.dart';

/// an operator function like multiple or divide
typedef OperatorFunction = int Function(int, int);

int multiply(int a, int b) => a * b;

int add(int a, int b) => a + b;

int or(int a, int b) => int.parse(a.toString() + b.toString());

List<OperatorFunction> operatorsMulAdd = [multiply, add];
List<OperatorFunction> operatorsMulAddOr = [multiply, add, or];

List<int> operatorPermutations(
  List<int> operands,
  List<OperatorFunction> allowedOperators,
) {
  final descentCalculations =
      descent(operands[0], operands.sublist(1), allowedOperators);
  print('descent results: $descentCalculations');
  return descentCalculations;
}

/// c=1  * +
/// c=2  ** *+ +* ++
/// c=3  *** **+ *+* +** *++ +*+ ++* +++
///
/// it is the 2nd one
///
/// which is it?
/// # combinations = count ^ length(allOperators)
/// c=1 1^2 = 1
/// c=3 3^2 = 9
/// c=4 4^2 = 16
/// # combinations = length(allOperators) ^ count
/// c=1 2^1 = 2
/// c=3 2^3 = 8
/// c=4 2^4 = 16
List<int> descent(
  int current,
  List<int> operands,
  List<OperatorFunction> allowedOperators,
) {
  final foo = <int>[];
  for (final aFunc in allowedOperators) {
    final newValue = aFunc(current, operands[0]);
    if (operands.length > 1) {
      foo.addAll(descent(newValue, operands.sublist(1), allowedOperators));
    } else {
      foo.add(newValue);
    }
  }
  return foo;
}

class Day07 extends GenericDay {
  Day07() : super(7);

  @override
  (List<int>, List<List<int>>) parseInput() {
    final inputThis = InputUtil(7);
    final rawLines = inputThis.getPerLine();
    final eqLeftAndRight = rawLines.map((line) => line.split(':')).toList();
    final values =
        eqLeftAndRight.map((toElement) => int.parse(toElement[0])).toList();
    final operands = eqLeftAndRight
        .map(
          (right) => right[1].trim().split(' ').map(int.parse).toList(),
        )
        .toList();

    return (values, operands);
  }

  @override
  int solvePart1() {
    final (values, operands) = parseInput();

    var sumSolved = 0;
    for (var i = 0; i < values.length; i++) {
      print('target value: ${values[i]}');
      print('operands: ${operands[i]}');
      final possibleAnswers =
          operatorPermutations(operands[i], operatorsMulAdd);
      if (possibleAnswers.contains(values[i])) {
        sumSolved += values[i];
      }
    }
    return sumSolved;
  }

  @override
  int solvePart2() {
    final (values, operands) = parseInput();

    var sumSolved = 0;
    for (var i = 0; i < values.length; i++) {
      print('target value: ${values[i]}');
      print('operands: ${operands[i]}');
      final possibleAnswers =
          operatorPermutations(operands[i], operatorsMulAdd);
      if (possibleAnswers.contains(values[i])) {
        sumSolved += values[i];
      } else {
        final possibleAnswers2 =
            operatorPermutations(operands[i], operatorsMulAddOr);
        if (possibleAnswers2.contains(values[i])) {
          sumSolved += values[i];
        }
      }
    }
    return sumSolved;
  }
}
