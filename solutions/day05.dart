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

  /// The meat of the whole thing
  /// Iterate across lines accumulating them into records
  List<Object> convertLinesToRecords(List<String> lines) {
    // seed row then blank row then the map tables so (2)
    final linesAsRecords = lines
        .sublist(2)
        .map(
          (e) => e.isEmpty
              ? createAndResetAccumulator()
              : _accumulator.add(e.split(' ')),
        )
        .nonNulls
        // must toList so we can add last one
        // could we have extended the Iterable?
        .toList();
    //  may not be a blank line at the end so we have a dangling accumulation
    if (_accumulator.isNotEmpty) {
      linesAsRecords.add(createAndResetAccumulator());
    }
    return linesAsRecords;
  }

  late Map<String, TheMap> lineMap;

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

  int locationForSeed(int seedNum) {
    final soil = lineMap[chain[0]]!.destRange(seedNum);
    final fertilizer = lineMap[chain[1]]!.destRange(soil);
    final water = lineMap[chain[2]]!.destRange(fertilizer);
    final light = lineMap[chain[3]]!.destRange(water);
    final temperature = lineMap[chain[4]]!.destRange(light);
    final humidity = lineMap[chain[5]]!.destRange(temperature);
    final location = lineMap[chain[6]]!.destRange(humidity);
    return location;
  }

  static const int maxIntValue = -1 >>> 1;

  // populates seeds and lineMap
  @override
  List<String> parseInput() {
    final rawLines = input.getPerLine();

    final linesAsRecords = convertLinesToRecords(rawLines);

    // keyed by the from part of the records
    lineMap = Map.fromEntries(
      linesAsRecords.map((e) => MapEntry((e as TheMap).from, e)),
    );

    return rawLines;
  }

  @override
  int solvePart1() {
    final rawLines = parseInput();

    late Iterable<int> seeds;
    seeds = rawLines[0].split(' ').sublist(1).map(int.parse);
    print('part 1 - ${seeds.length} seeds under test: $seeds');

    final allSeeds = seeds.map(locationForSeed);
    print('part 1 - allSeeds: ${allSeeds.toList()}');

    return allSeeds.fold(
        maxIntValue,
        (previousValue, element) =>
            previousValue < element ? previousValue : element);
  }

  @override
  int solvePart2() {
    final rawLines = parseInput();
    // even indexes are start and odd indexes are length
    final rawSeedInfo = rawLines[0].split(' ').sublist(1);
    // iterators one for each seed range
    final ourIterators = <Iterable<int>>[];

    // statistics
    var debugCount = 0;
    // create iterators for each of the seed ranges
    // do not lists which could be huge
    for (var i = 0; i < rawSeedInfo.length; i = i + 2) {
      final start = int.parse(rawSeedInfo[i]);
      final count = int.parse(rawSeedInfo[i + 1]);
      ourIterators.add(Iterable.generate(count, (counter) => start + counter));
      // some code to understand the size of the issue
      debugCount = debugCount + count;
      print('part 2 - adding iterator $start -> ${start + count} : $count '
          'aggregated iteration count is $debugCount');
    }
    print('part 2 - $debugCount iterations');
    // use the combined iterator so this is all lazy
    // run the drill down resolution on each item in all of the iterators
    // would be a great place for scater/gather
    return CombinedIterableView(ourIterators).map(locationForSeed).fold(
        maxIntValue,
        (previousValue, element) =>
            previousValue < element ? previousValue : element);
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
