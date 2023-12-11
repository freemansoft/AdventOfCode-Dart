import '../utils/index.dart';

class Day11 extends GenericDay {
  Day11() : super(11);

  @override
  List<List<String>> parseInput() {
    var universe = input.getPerLine().map((e) => e.split('')).toList();
    print(universe);
    return universe;
  }

  @override
  int solvePart1() {
    var universe = parseInput();
    final newUniverse = buildNewUniverse(universe);
    final universes = findUniverses(newUniverse, universeMarker: '#');
    return 0;
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
  List<List<String>> buildNewUniverse(
    List<List<String>> universe,
  ) {
    final emptyCols = List.filled(universe[0].length, 0);
    final emptyRows = List.filled(universe.length, 0);

    // find empty rows and columns - count number of universes per
    for (var col = 0; col < universe[0].length; col++) {
      for (var row = 0; row < universe.length; row++) {
        emptyCols[col] = emptyCols[col] + (universe[row][col] == '#' ? 1 : 0);
        emptyRows[row] = universe[row].map((e) => e == '#' ? 1 : 0).sum;
      }
    }

    final newUniverse = <List<String>>[];
    // newUniverse is a different data structure
    // add the rows first
    for (var row = 0; row < universe.length; row++) {
      // make a copy
      newUniverse.add(List.from(universe[row]));
      //is empty?
      if (emptyRows[row] == 0) {
        newUniverse.add(List.filled(universe[row].length, '.', growable: true));
      }
    }
    // now expand the columns where the column is empty
    for (var row = 0; row < universe.length; row++) {
      for (var col = universe[row].length - 1; col >= 0; col--) {
        if (emptyCols[col] == 0) {
          //print('adding col at ${col + 1} to row $row');
          // add after this column
          newUniverse[row].insert(col + 1, '.');
        }
      }
    }
    return newUniverse;
  }
}

class Location {
  Location(
    this.row,
    this.col,
  );
  final int row;
  final int col;
}
