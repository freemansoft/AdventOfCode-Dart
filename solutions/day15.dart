import 'dart:convert';

import '../utils/index.dart';

class Day15 extends GenericDay {
  Day15() : super(15);

  @override
  List<String> parseInput() {
    var phrases = input.getPerLine().join().split(',').nonNulls.toList();
    return phrases;
  }

  @override
  int solvePart1() {
    var phrases = parseInput();
    print(phrases);
    var hashes = phrases.map((e) => calcHash(e));
    print(hashes);
    return hashes.sum;
  }

  @override
  int solvePart2() {
    return 0;
  }

  int calcHash(String phrase) {
    // list of ascii values
    return ascii.encode(phrase).fold(
        0, (previousValue, element) => ((previousValue + element) * 17) % 256);
  }
}
