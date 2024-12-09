import 'dart:math';

import '../utils/index.dart';

class Day09 extends GenericDay {
  Day09() : super(9);

  @override
  void parseInput() {}

  @override
  int solvePart1() {
    final expandedBlocks = expandThisSucka(input.asString);

    print('${expandedBlocks.length} : expandedBlocks');
    print('${expandedBlocks.where((e) => e != '.').length} : filled cells '
        'out of ${expandedBlocks.length}');

    // just what we can use
    // these are reversed because we consume in reverse order, from the back
    final replacementBlocks = expandedBlocks.reversed.toList()
      ..removeWhere((aValue) => aValue == '.');
    var scanIndex = 0;
    var replacementIndex = 0;
    // the blocks after filling in
    final compactedBlocks = <String>[];
    // while compacted size is ot yet the size of everthing in replacement list
    while (compactedBlocks.length < replacementBlocks.length) {
      // everwhere there is a who, copy the furthest back into this slot
      if (expandedBlocks[scanIndex] == '.') {
        compactedBlocks.add(replacementBlocks[replacementIndex]);
        replacementIndex += 1;
      } else {
        // retain the previous if it is not an empty space
        compactedBlocks.add(expandedBlocks[scanIndex]);
      }
      scanIndex += 1;
    }
    print('${replacementBlocks.length} : replacementBlocks');
    print('${compactedBlocks.length} : compactedBlocks');
    return checksum(compactedBlocks);
  }

  @override
  int solvePart2() {
    final expandedBlocks = expandThisSucka(input.asString);
    print('$expandedBlocks');

    // somehow do the copy thing

    // calculate checksum
    return checksum(expandedBlocks);
  }

  // converts the compacted format to an expanded version
  List<String> expandThisSucka(String inputString) {
    // expand the blocks
    // this cannot handle a blank line
    final expandedBlocks = <String>[];

    print('input string length: ${inputString.length}');
    for (var i = 0; i <= input.asString.length ~/ 2; i += 1) {
      final aDigit = input.asString.substring(i * 2, i * 2 + 1);
      final blockSize = int.parse(aDigit);
      for (var size = 0; size < blockSize; size++) {
        expandedBlocks.add(i.toString());
      }
      // last descriptor may have no empty space description
      if (input.asString.length > (i * 2) + 1) {
        final suspectedDigit =
            input.asString.substring((i * 2) + 1, (i * 2) + 2);
        final spaceSize = int.parse(suspectedDigit);
        for (var size = 0; size < spaceSize; size++) {
          expandedBlocks.add('.');
        }
      }
    }
    return expandedBlocks;
  }

  int checksum(List<String> expandedBlocks) {
    var checksum = 0;
    for (var i = 0; i < expandedBlocks.length; i++) {
      checksum +=
          (expandedBlocks[i] != '.') ? i * int.parse(expandedBlocks[i]) : 0;
      //print('$i * ${sortedBlocks[i]} => ${i * int.parse(sortedBlocks[i])}');
    }
    return checksum;
  }
}
