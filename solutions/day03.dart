import '../utils/index.dart';

class NumberLocation {
  NumberLocation({required this.start, required this.end, required this.value});

  final int start;
  final int end;
  final int value;

  @override
  String toString() {
    return '{ "start": $start , "end": $end, "value": $value}';
  }
}

class Day03 extends GenericDay {
  Day03() : super(3);

  /// turn each number in the row into a Number Location
  List<NumberLocation> mapOfNumbers(String aLine) {
    final results = <NumberLocation>[];
    var i = 0;
    while (i < aLine.length) {
      if (aLine[i].startsWith(RegExp('[0-9]'))) {
        final start = i;
        var end = i;
        while (i < aLine.length && aLine[i].startsWith(RegExp('[0-9]'))) {
          end = i;
          i++;
        }
        //print('$start - $end - ${aLine.substring(start, end + 1)}');
        final value = int.parse(aLine.substring(start, end + 1));
        results.add(NumberLocation(start: start, end: end, value: value));
      }
      i++;
    }
    return results;
  }

  /// Return a list of locations where symbols exist
  /// There is a true or false for each character in the row
  List<bool> mapOfSymbols(String aLine) {
    final results = <bool>[];
    for (var i = 0; i < aLine.length; i++) {
      results.add(!aLine[i].startsWith(RegExp('^[0-9.]')));
    }
    return results;
  }

  /// Walk the number map
  /// Scan the symbol map for any nearby : above, on and below
  /// Use a set so we don't have to worry about duplicate insertions
  Set<NumberLocation> findNumbersNearSymbols(
      List<List<NumberLocation>> mapOfNumbers, List<List<bool>> mapOfSymbols) {
    // use a set so that we can insert same one multiple times
    final results = <NumberLocation>{};
    // use indexes because we need to do +/- one for scanning
    for (var row = 0; row < mapOfNumbers.length; row++) {
      for (var col = 0; col < mapOfNumbers[row].length; col++) {
        // for each number look at the map of symbols
        final numberCell = mapOfNumbers[row][col];
        // scan three rows : above, on, below
        for (var scanRow = row - 1; scanRow <= row + 1; scanRow++) {
          if (scanRow > 0 && scanRow < mapOfSymbols.length) {
            // scan the columns in the specified row
            for (var scanCol = numberCell.start - 1;
                scanCol <= numberCell.end + 1;
                scanCol++) {
              if (scanCol > 0 &&
                  scanCol < mapOfSymbols[scanRow].length - 1 &&
                  (mapOfSymbols[scanRow][scanCol])) {
                results.add(mapOfNumbers[row][col]);
              }
            }
          }
        }
      }
    }
    return results.nonNulls.toSet();
  }

  @override
  List<String> parseInput() {
    final lines = input.getPerLine();
    return lines;
  }

  @override
  int solvePart1() {
    final lines = parseInput();
    // each row contains a list of objects describing where numbers are
    final numberLocations = lines.map(mapOfNumbers).toList();
    // each row contains list of flags describing if symbol or not
    final symbolLocations = lines.map(mapOfSymbols).toList();
    // the set of numbers near symbols
    final numbersNearSymbols =
        findNumbersNearSymbols(numberLocations, symbolLocations);
    final result = numbersNearSymbols.map((e) => e.value).sum;
    return result;
  }

  @override
  int solvePart2() {
    return 0;
  }
}
