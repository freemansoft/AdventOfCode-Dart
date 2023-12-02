import '../utils/index.dart';

class Day01 extends GenericDay {
  Day01() : super(1);

  @override
  List<String> parseInput() {
    // the input as a list of strings
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final foo = parseInput();
    final lineAllDigits = ParseUtil.digitsOnlyString(foo);
    final firstLastDigits =
        lineAllDigits.map((e) => int.parse(e[0] + e[e.length - 1])).toList();

    return firstLastDigits.sum;
  }

  @override
  int solvePart2() {
    final rawText = parseInput();

    final junkAndDigits = ParseUtil.wordsToDigetsString(rawText);
    // The number of representation of a row is the first number concat with last
    // or first*10+last
    final firstLastDigits =
        junkAndDigits.map((e) => e.first * 10 + e.last).toList();

    return firstLastDigits.sum;
  }
}
