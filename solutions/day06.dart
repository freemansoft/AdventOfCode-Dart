import '../utils/index.dart';

class Day06 extends GenericDay {
  Day06() : super(6);

  late List<(int, int)> linesAsRecords;

  (int, int) buildRecord({
    required int time,
    required int distance,
  }) {
    return (time, distance);
  }

  @override
  void parseInput() {
    final linesAsLists =
        input.getPerLine().map((e) => e.split(RegExp(r"\s+"))).toList();
    //print(linesAsLists);
    //print(IterableZip([linesAsLists[0], linesAsLists[1]]).toList());
    // should change this to a map
    linesAsRecords =
        IterableZip([linesAsLists[0].sublist(1), linesAsLists[1].sublist(1)])
            .map(
              (e) =>
                  buildRecord(time: int.parse(e[0]), distance: int.parse(e[1])),
            )
            .toList();
  }

  @override
  int solvePart1() {
    parseInput();
    //print(linesAsRecords);
    // the number of time slots above distance for each run
    var allRuns = linesAsRecords.map((e) => getNumAboveSpeed(e.$1, e.$2));
    var answer = allRuns.reduce((value, element) => value * element);
    return answer;
  }

  @override
  int solvePart2() {
    return 0;
  }

  /// calculates the number of time slots that would be above the distance
  int getNumAboveSpeed(int time, int distance) {
    var speedsAtSeconds = Iterable<int>.generate(time)
        .map((e) => ((time - e) * e) > distance ? 1 : 0)
        .reduce((value, element) => value + element);
    //print('number above record: $speedsAtSeconds');
    return speedsAtSeconds;
  }
}
