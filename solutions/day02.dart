import '../utils/index.dart';

class Day02 extends GenericDay {
  Day02() : super(2);

  List<List<int>> intCells = [[]];

  @override
  void parseInput() {
    final inputUtil = InputUtil(1);
    print('${inputUtil.getPerLine()}');
    intCells = inputUtil.perLineToCells<int>(
      input.getPerLine(),
      ' ',
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
    print(intCells);
    final sortedIncreasing = intCells
        .map((e) => e.toList()..sort((a, b) => a.compareTo(b)))
        .toList();
    final sortedDecreasing = intCells
        .map((e) => e.toList()..sort((a, b) => b.compareTo(a)))
        .toList();

    // print('===========');
    // print('$sortedDecreasing');
    // print('$sortedIncreasing');

    var numGood = 0;

    for (var i = 0; i < intCells.length; i++) {
      var isGood = true;
      print(
        'vs descending ${intCells[i]}, ${sortedDecreasing[i]} === vs'
        ' ascending ${intCells[i]}, ${sortedIncreasing[i]}',
      );
      // we compare the sorted list against the lists to see if they match
      // they must be all increasing or all decreasing
      if (sortedDecreasing[i].equals(intCells[i])) {
        for (var j = 0; j < intCells[i].length - 1; j++) {
          final difference =
              sortedDecreasing[i][j] - sortedDecreasing[i][j + 1];
          if (difference < 1 || difference > 3) {
            isGood = false;
          }
        }
      } else if (sortedIncreasing[i].equals(intCells[i])) {
        for (var j = 0; j < intCells[i].length - 1; j++) {
          final difference =
              sortedIncreasing[i][j + 1] - sortedIncreasing[i][j];
          if (difference < 1 || difference > 3) {
            isGood = false;
          }
        }
      } else {
        // not worthy of checking
        isGood = false;
      }
      if (isGood) numGood += 1;
    }
    return numGood;
  }

  /// not solved
  @override
  int solvePart2() {
    parseInput();
    print(intCells);

    return -1;
  }
}
