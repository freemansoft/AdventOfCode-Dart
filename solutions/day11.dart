import '../utils/index.dart';

class Day11 extends GenericDay {
  Day11() : super(11);

  @override
  List<List<String>> parseInput() {
    return input.getPerLine().map((e) => e.split('')).toList();
  }

  @override
  int solvePart1() {
    var universe = parseInput();
    final expandedUniverse = buildExpandedUniverse(universe);
    final allUniverses = findUniverses(expandedUniverse, universeMarker: '#');
    final distances = allUniverses
        .map(
          (e) => allUniverses
              .map(
                (f) => (e != f) ? calcDistance(e, f) : Null,
              )
              .where((element) => element != Null),
        )
        .flattened
        .toList();
    print(
        '${distances.length} - ${distances.map((e) => (e as Distance).distance)}');
    return (distances.fold(
              0,
              (previousValue, element) =>
                  previousValue + (element as Distance).distance,
            ) /
            2)
        .round();
  }

  @override
  int solvePart2() {
    return 0;
  }

  List<Location> findUniverses(List<List<String>> aUniverse,
      {String universeMarker = '#'}) {
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

  // build a new universe based on empty rows and columns
  List<List<String>> buildExpandedUniverse(
    List<List<String>> universe,
  ) {
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

    // newUniverse is a different data structure
    final newUniverse = <List<String>>[];
    // rows first
    for (var row = 0; row < universe.length; row++) {
      newUniverse.add(List.from(universe[row]));
      if (emptyRows[row] == 0) {
        newUniverse.add(List.filled(universe[row].length, '*', growable: true));
      }
    }
    //print('Expanded universe from ${universe.length} to ${newUniverse.length}');
    // now expand the columns where the column is empty
    for (var col = newUniverse[0].length - 1; col >= 0; col--) {
      for (var row = 0; row < newUniverse.length; row++) {
        if (emptyCols[col] == 0) {
          newUniverse[row].insert(col, '*');
        }
        //print('$row  ${newUniverse[row]}');
      }
    }
    return newUniverse;
  }

  Distance calcDistance(Location e, Location f) {
    //print('$e - $f - ${(f.row - e.row).abs() + (f.col - e.col).abs()}');
    return Distance(
        start: e,
        end: f,
        distance: (f.row - e.row).abs() + (f.col - e.col).abs());
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

  int get hashCode => "$row:$col".hashCode;
}
