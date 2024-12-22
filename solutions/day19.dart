import 'dart:math';

import '../utils/index.dart';

class Day19 extends GenericDay {
  Day19() : super(19);

  List<String> availableTowels = <String>[];

  @override
  List<String> parseInput() {
    final theInput = InputUtil(19).getParagraphLines().toList();
    // we know the first pargraph is just the towel set
    availableTowels = theInput[0][0].replaceAll(' ', '').split(',');
    return theInput[1];
  }

  @override
  int solvePart1() {
    final lookingFor = parseInput();

    final dogfood = lookingFor.map((e) {
      final results = scanIt(e, availableTowels, e);
      print(results);
      return results;
    }).toList();
    return dogfood.fold(
        0, (previousCount, solvedThis) => previousCount + (solvedThis ? 1 : 0));
  }

  @override
  int solvePart2() {
    return 0;
  }

  /// base string is the original request value and is passed in for debugging
  bool scanIt(String e, List<String> availableTowels, String baseString) {
    if (e.isEmpty) {
      return true;
    }
    for (final towel in availableTowels) {
      if (e.startsWith(towel) &&
          scanIt(
            e.substring(towel.length),
            availableTowels,
            baseString,
          )) {
        return true;
      }
    }
    return false;
  }
}
