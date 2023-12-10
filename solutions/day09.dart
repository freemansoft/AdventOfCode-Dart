import '../utils/index.dart';

class Day09 extends GenericDay {
  Day09() : super(9);

  /// returns the list of rows where each row is a List<int>
  @override
  Iterable<List<List<int>>> parseInput() {
    return input
        .getPerLine()
        .map((e) => [e.split(' ').nonNulls.map(int.parse).toList()]);
  }

  /// recursivly calculate the diffs returning a sequence of the iterations
  List<List<int>> calcDiffs(List<int> sequence) {
    if (sequence.every((element) => element == 0)) return [sequence];
    final nextSequence = sequence
        .mapIndexed(
          (index, element) => index == 0 ? null : element - sequence[index - 1],
        )
        .nonNulls
        .toList();
    return [sequence, ...calcDiffs(nextSequence)];
  }

  @override
  int solvePart1() {
    final Iterable<List<List<int>>> lines = parseInput();
    //print('lines: $lines');
    // for each sample
    // calculate the diffs for the last row
    final diffs = lines
        .map(
          (e) => calcDiffs(e.last),
        )
        .toList();
    //print('diffs: $diffs');
    // for each row,
    // reverse the steps because the 2nd phase is bottom up
    // then walk from the beginning to end calcuating the last value
    final reversed = diffs.map((e) => e.reversed).toList();
    print('reversed: $reversed');
    final answer = reversed
        .map(
          (e) => e.reduce((value, element) => [element.last + value.last]),
        )
        .toList();
    print('answer:  aggregating: ${answer.length} - $answer');
    return answer.map((e) => e[0]).sum;
  }

  @override
  int solvePart2() {
    final Iterable<List<List<int>>> lines = parseInput();

    return 0;
  }
}
