import '../utils/index.dart';

class Day06 extends GenericDay {
  Day06() : super(6);

  /// list of records time and distance
  late List<(int, int)> raceRecords;

  /// created this to retain typing
  (int, int) buildRecord({
    required int time,
    required int distance,
  }) {
    return (time, distance);
  }

  @override
  void parseInput() {}

  /// calculates the number of time slots that would be above the distance
  /// scans all of the time slots to see if they would be above the distance
  /// putting 1 if they are and zero if they are not
  int getNumAboveSpeed(int time, int distance) {
    final speedsAtSeconds = Iterable<int>.generate(time)
        .map((e) => ((time - e) * e) > distance ? 1 : 0)
        .reduce((value, element) => value + element);
    //print('number above record: $speedsAtSeconds');
    return speedsAtSeconds;
  }

  @override
  int solvePart1() {
    // convert the row columns into list elements
    final linesAsLists =
        input.getPerLine().map((e) => e.split(RegExp(r"\s+"))).toList();
    //print(linesAsLists);
    // print(
    //   IterableZip([linesAsLists[0].sublist(1), linesAsLists[1].sublist(1)]));
    // invert the list converting the columns into records ( rows )
    raceRecords =
        IterableZip([linesAsLists[0].sublist(1), linesAsLists[1].sublist(1)])
            .map(
              (e) =>
                  buildRecord(time: int.parse(e[0]), distance: int.parse(e[1])),
            )
            .toList();
    //print(linesAsRecords);
    // the number of time slots above distance for each run
    final allRuns = raceRecords.map((e) => getNumAboveSpeed(e.$1, e.$2));
    // The answer is the multiplication of the number succeeded for each event
    final answer = allRuns.reduce((value, element) => value * element);
    return answer;
  }

  @override
  int solvePart2() {
    // there is only one record so just smash everything together
    final linesAsLists = input
        .getPerLine()
        .map((e) => e.replaceAll(' ', ''))
        .map((e) => e.split(':'))
        .toList();
    // use the same code we used in item 1 to calculate
    final allRuns = getNumAboveSpeed(
        int.parse(linesAsLists[0][1]), int.parse(linesAsLists[1][1]));

    return allRuns;
  }
}
