import '../utils/index.dart';

class Day01 extends GenericDay {
  Day01() : super(1);

  List<List<int>> intCells = [[]];

  @override
  void parseInput() {
    final inputUtil = InputUtil(1);
    print('${inputUtil.getPerLine()}');
    intCells = inputUtil.perLineToCells<int>(
      input.getPerLine(),
      '   ',
      parseIt,
    );
  }

  int parseIt(String s) {
    //print(s);
    return int.parse(s.trim());
  }

  @override
  int solvePart1() {
    parseInput();
    final col0Sorted = intCells.map((e) => e[0]).toList()..sort();
    final col1Sorted = intCells.map((e) => e[1]).toList()..sort();
    print(col0Sorted);
    print(col1Sorted);
    var sum = 0;
    for (var i = 0; i < col0Sorted.length; i++) {
      final diff = (col0Sorted[i] - col1Sorted[i]).abs();
      print(' ${col0Sorted[i]} - ${col1Sorted[i]} = $diff');
      // print('$
      sum += diff;
    }
    print(sum);
    return sum;
  }

  @override
  int solvePart2() {
    parseInput();
    final col0 = intCells.map((e) => e[0]).toList();
    final col1 = intCells.map((e) => e[1]).toList();
    var sum = 0;
    for (var i = 0; i < col0.length; i++) {
      final newValue = col1.where((item) => item == col0[i]).length * col0[i];
      print(' ${col0[i]} $newValue');
      sum += newValue;
    }
    return sum;
  }
}
