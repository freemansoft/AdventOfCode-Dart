import '../utils/index.dart';

class Day05 extends GenericDay {
  Day05() : super(5);

  var _accumulator = <List<String>>[];

  TheMap createAndResetAccumulator() {
    final oneRecord = TheMap(
      _accumulator[0][0].split('-')[0],
      _accumulator[0][0].split('-')[2],
      _accumulator
          .sublist(1)
          .map((e) =>
              TheMapEntry(int.parse(e[0]), int.parse(e[1]), int.parse(e[2])))
          .toList(),
    );
    _accumulator = [];
    return oneRecord;
  }

  late List<int> seeds;
  late List<Object> linesAsRecords;
  late Map<String, TheMap> lineMap;

  @override
  parseInput() {
    final lines = input.getPerLine();

    seeds = lines[0].split(' ').sublist(1).map(int.parse).toList();

    linesAsRecords = lines
        .sublist(2)
        .map(
          (e) => e.isEmpty
              ? createAndResetAccumulator()
              : _accumulator.add(e.split(' ')),
        )
        .nonNulls
        .toList();
    //  may not be a blank line at the end so we have a dangling accumulation
    if (_accumulator.isNotEmpty) {
      linesAsRecords.add(createAndResetAccumulator());
    }

    lineMap = Map.fromEntries(
      linesAsRecords.map((e) => MapEntry((e as TheMap).from, e)),
    );
  }

  List<String> chain = [
    'seed',
    'soil',
    'fertilizer',
    'water',
    'light',
    'temperature',
    'humidity',
    //'location',
  ];

  @override
  int solvePart1() {
    parseInput();
    print(seeds);
    print(linesAsRecords);

    final wtf = seeds.map((e) {
      final soil = lineMap[chain[0]]!.destRange(e);
      final fertilizer = lineMap[chain[1]]!.destRange(soil);
      final water = lineMap[chain[2]]!.destRange(fertilizer);
      final light = lineMap[chain[3]]!.destRange(water);
      final temperature = lineMap[chain[4]]!.destRange(light);
      final humidity = lineMap[chain[5]]!.destRange(temperature);
      final location = lineMap[chain[6]]!.destRange(humidity);
      return location;
    }).toList();
    print('wtf: $wtf');
    return wtf.fold(
        999999999999999,
        (previousValue, element) =>
            previousValue < element ? previousValue : element);
  }

  @override
  int solvePart2() {
    return 0;
  }
}

class TheMapEntry {
  TheMapEntry(this.destStart, this.sourceStart, this.rangeLength);
  final int destStart;
  final int sourceStart;
  final int rangeLength;

  int destRange(int i) {
    if (i >= sourceStart && i < sourceStart + rangeLength) {
      return destStart + i - sourceStart;
    } else {
      return i;
    }
  }

  @override
  String toString() {
    return '{ "sourceStart": $sourceStart,'
        ' "destStart": $destStart,'
        ' "range": $rangeLength,'
        //' "destRange": ${destRange()}'
        '}';
  }
}

class TheMap {
  TheMap(this.from, this.to, this.entries);
  final String from;
  final String to;
  final List<TheMapEntry> entries;

  /// returns the value for the source across all entries
  int destRange(int index) {
    // now merge in the mapping
    for (final element in entries) {
      final oneMapping = element.destRange(index);
      if (oneMapping != index) {
        return oneMapping;
      }
    }
    return index;
  }

  @override
  String toString() {
    return '{ "from": $from,'
        ' "to": $to, '
        ' "entries": $entries,'
        //' "destRange": ${destRange()}'
        '}\n';
  }
}
