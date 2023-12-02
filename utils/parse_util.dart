import 'index.dart';

class ParseUtil {
  /// Throws an exception if any given String is not parseable.
  static List<int> stringListToIntList(List<String> strings) {
    return strings.map(int.parse).toList();
  }

  /// Returns decimal number from binary string
  static int binaryToDecimal(String binary) {
    return int.parse(binary, radix: 2);
  }

  /// convert the list of strings to a list of strings only containing digits
  static List<String> digitsOnlyString(List<String> strings) {
    final allReplaced =
        strings.map((a) => a.replaceAll(RegExp('[^0-9]'), '')).toList();
    //print('all replaced size: ${allReplaced.length}');
    return allReplaced;
  }

  /// the replacements must be left to right in source string
  /// and not in order from this list
  /// The null at the end is essentially the default of a switch statement
  static final remapping = {
    'zero': 0,
    'one': 1,
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8,
    'nine': 9,
    '0': 0,
    '1': 1,
    '2': 2,
    '3': 3,
    '4': 4,
    '5': 5,
    '6': 6,
    '7': 7,
    '8': 8,
    '9': 9,
    '': null,
  };

  /// moves across substring starting with each char in the string
  ///
  /// 1. accepts a single string
  /// 2. returns a list of numbers from the string
  /// 3. checks if substring matches key of any map entry
  /// 4. adds value to number list
  static List<int> convertStringtoListOfDigits(String oneRow) {
    final replaced =
        Iterable<String>.generate(oneRow.length, (i) => oneRow.substring(i))
            .map(
              (subOfOneRow) => remapping.entries
                  .firstWhere((element) => subOfOneRow.startsWith(element.key))
                  .value,
            )
            .whereNotNull()
            .toList();
    return replaced;
  }

  /// accepts list of strings representing rows
  /// returns list of lists of all the numbers in each row
  static List<List<int>> wordsToDigetsString(List<String> allRows) {
    final allReplaced = allRows
        .map(
          convertStringtoListOfDigits,
        )
        .toList();
    return allReplaced;
  }
}
