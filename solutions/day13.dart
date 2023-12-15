import '../utils/index.dart';

class Day13 extends GenericDay {
  Day13() : super(13);

  @override
  parseInput() {
    final lines = input.getPerLine();
    final blankLines = lines
        .mapIndexed((index, element) => element.isEmpty ? index : null)
        .toList()
        .nonNulls;
    var group = 0;
    // Map of lists of rows keyed by group number
    var blocks = lines
        .map((e) {
          if (e.isEmpty) {
            group = group + 1;
            return null;
          } else {
            return {group: e};
          }
        })
        .nonNulls
        .groupListsBy((element) => element.keys.firstOrNull);

    return;
  }

  @override
  int solvePart1() {
    parseInput();
    return 0;
  }

  @override
  int solvePart2() {
    return 0;
  }
}
