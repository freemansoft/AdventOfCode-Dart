import '../utils/index.dart';

class Day11 extends GenericDay {
  Day11() : super(11);

  @override
  List<List<String>> parseInput() {
    return input.getPerLine().map((e) => e.split('')).toList();
  }

  @override
  int solvePart1() {
    final universe = parseInput();
    final weightedUniverse = buildWeightedUniverse(universe, emptyRankValue: 2);
    final allUniverses = findUniverses(universe);
    final distances = calcWeightedDistances(allUniverses, weightedUniverse);
    // print(
    //     'P1 ${distances.length} - ${distances.map((e) => (e as Distance).distance)}');
    return (distances.fold(
              0,
              (previousValue, element) => previousValue + element.distance,
            ) /
            2)
        .round();
  }

  @override
  int solvePart2() {
    final universe = parseInput();
    final weightedUniverse =
        buildWeightedUniverse(universe, emptyRankValue: 1000000);
    final allUniverses = findUniverses(universe);
    final distances = calcWeightedDistances(allUniverses, weightedUniverse);
    // print(
    // 'P2 ${distances.length} - ${distances.map((e) => (e as Distance).distance)}');
    return (distances.fold(
              0,
              (previousValue, element) => previousValue + element.distance,
            ) /
            2)
        .round();
  }

  List<Distance> calcWeightedDistances(
    List<Location> allUniverses,
    List<List<int>> weigthedUniverse,
  ) {
    final distances = allUniverses
        .map(
          (e) => allUniverses
              .map(
                (f) => (e != f) ? calcDistance(e, f, weigthedUniverse) : null,
              )
              .nonNulls,
        )
        .flattened
        .toList();

    return distances;
  }

  List<Location> findUniverses(
    List<List<String>> aUniverse, {
    String universeMarker = '#',
  }) {
    final theUnverses = <Location>[];
    for (var row = 0; row < aUniverse.length; row++) {
      for (var col = 0; col < aUniverse[row].length; col++) {
        if (aUniverse[row][col] == universeMarker) {
          theUnverses.add(Location(row, col));
        }
      }
    }
    return theUnverses;
  }

  // build a new universe weighted on empty rows and columns
  List<List<int>> buildWeightedUniverse(
    List<List<String>> universe, {
    int emptyRankValue = 1,
  }) {
    // content is the number of universes in this col
    final emptyCols = List.filled(universe[0].length, 0);
    // content is the number of universes in this col
    final emptyRows = List.filled(universe.length, 0);

    // find empty rows and columns - count number of universes per
    for (var col = 0; col < universe[0].length; col++) {
      for (var row = 0; row < universe.length; row++) {
        emptyCols[col] = emptyCols[col] + (universe[row][col] == '#' ? 1 : 0);
        emptyRows[row] = universe[row].map((e) => e == '#' ? 1 : 0).sum;
      }
    }
    //print('emptyRows: $emptyRows, emptyCols: $emptyCols');

    final newUniverse = <List<int>>[];
    // rows first
    for (var row = 0; row < universe.length; row++) {
      if (emptyRows[row] == 0) {
        newUniverse.add(
          List.filled(universe[row].length, emptyRankValue, growable: true),
        );
      } else {
        newUniverse.add(
          List.filled(universe[row].length, 1, growable: true),
        );
      }
    }
    // now expand the columns where the column is empty
    for (var col = newUniverse[0].length - 1; col >= 0; col--) {
      for (var row = 0; row < newUniverse.length; row++) {
        if (emptyCols[col] == 0) {
          newUniverse[row][col] = emptyRankValue;
        }
        //print('$row  ${newUniverse[row]}');
      }
    }
    //print('weighted universe $newUniverse');
    return newUniverse;
  }

  /// calculates the distance using the distance values in each
  /// cell of the weightedUniverse
  Distance calcDistance(
    Location e,
    Location f,
    List<List<int>> weightedUniverse,
  ) {
    final minRow = (e.row < f.row) ? e.row : f.row;
    final maxRow = (e.row > f.row) ? e.row : f.row;
    final weightRow = Iterable.generate(
      maxRow - minRow,
      (e) => weightedUniverse[e + minRow][0],
    ).sum;
    final minCol = (e.col < f.col) ? e.col : f.col;
    final maxCol = (e.col > f.col) ? e.col : f.col;
    final weightCol = Iterable.generate(
      maxCol - minCol,
      (e) => weightedUniverse[0][e + minCol],
    ).sum;

    // print(
    //     'Distance start: $e, end: $f, weight: $weightRow $weightCol distance: ${weightRow + weightCol}');
    return Distance(start: e, end: f, distance: weightRow + weightCol);
  }
}

class Distance {
  Distance({required this.start, required this.end, required this.distance});

  final Location start;
  final Location end;
  final int distance;
}

class Location {
  Location(
    this.row,
    this.col,
  );
  final int row;
  final int col;

  @override
  String toString() {
    return '{"row":$row, "col":$col}';
  }

  @override
  int get hashCode => '$row:$col'.hashCode;
}
