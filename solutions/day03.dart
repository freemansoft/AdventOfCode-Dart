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

  /// Return a list of locations where gears exist
  /// There is a true or false for each character in the row
  List<bool> mapOfGears(String aLine) {
    final results = <bool>[];
    for (var i = 0; i < aLine.length; i++) {
      results.add(aLine[i].startsWith('*'));
    }
    return results;
  }

  /// Walk the number map
  /// Scan the symbol map for any nearby : above, on and below
  /// Use a set so we don't have to worry about duplicate insertions
  Set<NumberLocation> findNumbersNearSymbols(
    List<List<NumberLocation>> mapOfNumbers,
    List<List<bool>> mapOfSymbols,
  ) {
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

  /// Returns all the power calcualtions from all the part*part calculations
  List<int> findRatios(
    List<List<NumberLocation>> mapOfNumbers,
    List<List<bool>> gearLocationsMap,
  ) {
    final results = <int>[];
    // walk across the gear map
    // we need the indexes so not using .map operators :-(
    for (var gearRow = 0; gearRow < gearLocationsMap.length; gearRow++) {
      for (var gearCol = 0;
          gearCol < gearLocationsMap[gearRow].length;
          gearCol++) {
        // do work if we found a gear
        if (gearLocationsMap[gearRow][gearCol]) {
          print('gear $gearRow,$gearCol');
          // use a set as a lazy dedupe
          final oneGearParts = <NumberLocation>{};
          // now look for all parts near the gear
          for (var partRow = gearRow - 1; partRow <= gearRow + 1; partRow++) {
            // BFI boundary check
            if (partRow >= 0 && partRow < mapOfNumbers.length) {
              // scan every location in the row
              for (final location in mapOfNumbers[partRow]) {
                if (gearCol >= location.start - 1 &&
                    gearCol <= location.end + 1) {
                  oneGearParts.add(location);
                }
              }
            }
          }
          // oneGearParts is a set of NumberLocations, parts on this gear
          //print(oneGearParts);
          // no gear ratio of only one part
          if (oneGearParts.length > 1) {
            results.add(
              oneGearParts
                  .map((e) => e.value)
                  .fold(1, (previousValue, element) => previousValue * element),
            );
            //print(results.last);
          }
        }
      }
    }
    return results;
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
    final lines = parseInput();
    // each row contains a list of objects describing where numbers are
    final numberLocations = lines.map(mapOfNumbers).toList();
    // each row contains list of flags describing if symbol or not
    final gearLocations = lines.map(mapOfGears).toList();
    // find the power values for all the gears
    final ratioValues = findRatios(numberLocations, gearLocations);
    final result = ratioValues.sum;
    return result;
  }
}
