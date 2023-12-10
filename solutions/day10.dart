import '../utils/index.dart';

class Coordinate {
  Coordinate({required this.row, required this.col});
  final int row;
  final int col;

  @override
  bool operator ==(Object other) =>
      other is Coordinate &&
      other.runtimeType == runtimeType &&
      other.row == row &&
      other.col == col;

  @override
  int get hashCode => 'row:$row,col:$col'.hashCode;

  String toString() {
    return '{ "row": $row , "col": $col}';
  }
}

class Day10 extends GenericDay {
  Day10() : super(10);

  // symbol : [[relative connect point 1 r:c], [relative connect point 2 r:c]]
  Map<String, Set<Coordinate>> symbols = {
    // is a vertical pipe connecting north and south.
    '|': {
      Coordinate(row: -1, col: 0),
      Coordinate(row: 1, col: 0),
    },
    // is a horizontal pipe connecting east and west
    '-': {
      Coordinate(row: 0, col: -1),
      Coordinate(row: 0, col: 1),
    },
    //is a 90-degree bend connecting north and east.
    'L': {
      Coordinate(row: -1, col: 0),
      Coordinate(row: 0, col: 1),
    },
    //is a 90-degree bend connecting north and west.
    'J': {
      Coordinate(row: -1, col: 0),
      Coordinate(row: 0, col: -1),
    },
    //is a 90-degree bend connecting south and west.
    '7': {Coordinate(row: 0, col: -1), Coordinate(row: 1, col: 0)},
    // is a 90-degree bend connecting south and east.
    'F': {Coordinate(row: 0, col: 1), Coordinate(row: 1, col: 0)},
    // is ground; there is no pipe in this tile.
    '.': {},
    // is the starting position of the animal; there is a pipe on this tile,
    // but your sketch does not show what shape the pipe has.
    'S': {
      Coordinate(row: -1, col: 0),
      Coordinate(row: 0, col: -1),
      Coordinate(row: 0, col: 1),
      Coordinate(row: 1, col: 0),
    },
  };

  /// really the directions we can search in
  /// the second set is what it has to have to see back to us
  final Set<List<Coordinate>> validDirections = {
    [Coordinate(row: -1, col: 0), Coordinate(row: 1, col: 0)],
    [Coordinate(row: 0, col: -1), Coordinate(row: 0, col: 1)],
    [Coordinate(row: 0, col: 1), Coordinate(row: 0, col: -1)],
    [Coordinate(row: 1, col: 0), Coordinate(row: -1, col: 0)],
  };

  Coordinate findStartLocation() {
    // re-read the file because I didn't retain the original anywhere :-(
    final start = input
        .getPerLine()
        .mapIndexed(
          (index, element) => element.contains('S')
              ? Coordinate(row: index, col: element.indexOf('S'))
              : null,
        )
        .nonNulls
        .first;
    return start;
  }

  Set<Coordinate> findFirstSteps(
    Coordinate startLocation,
    List<List<Set<Coordinate>>> cellMap,
  ) {
    final results = <Coordinate>{};

    for (final a in validDirections) {
      var look = a[0];
      var lookback = a[1];
      if (startLocation.row + look.row >= 0 &&
          startLocation.row + look.row < cellMap.length &&
          startLocation.col + look.col >= 0 &&
          startLocation.col + look.row < cellMap[0].length &&
          cellMap[startLocation.row + look.row][startLocation.col + look.col]
              .contains(lookback)) {
        results.add(
          Coordinate(
            row: startLocation.row + look.row,
            col: startLocation.col + look.col,
          ),
        );
      }
    }
    return results;
  }

  dynamic calcRoute({
    required Coordinate start,
    required Coordinate firstStep,
    required List<List<Set<Coordinate>>> cellMap,
    required List<Coordinate> alreadyWalked,
  }) {
    //print('  depth - ${alreadyWalked.length}');
    if (alreadyWalked.isEmpty) {
      //print(' calcRoute: $start, firstStep: $firstStep');
    }
    if (start == firstStep) {
      //print('  Returning for $firstStep - $alreadyWalked.length');
      return alreadyWalked;
    } else if (alreadyWalked.contains(firstStep)) {
      //print('  Returning for $firstStep - ${alreadyWalked.length}');
      //print('  Returning for $firstStep - $alreadyWalked');
      return;
    }
    {
      // print(
      //   '  walking from $firstStep '
      //   'cellmap ${cellMap[firstStep.row][firstStep.col]} '
      //   'alreadyWalked: $alreadyWalked',
      // );
      // for each way out
      var x = cellMap[firstStep.row][firstStep.col].map((e) => calcRoute(
            start: start,
            firstStep: Coordinate(
              row: firstStep.row + e.row,
              col: firstStep.col + e.col,
            ),
            cellMap: cellMap,
            alreadyWalked: List.from(alreadyWalked)..add(firstStep),
          ));
      //print('  Returning for $firstStep - ${x}');
      // x.nonNulls is a nested all the way down to the array that is the answer
      // x.nonNulls.first is the first step
      return x.nonNulls.last;
    }
  }

  @override
  // rows of columns where each cell is a list of valid directions from that cell
  List<List<Set<Coordinate>>> parseInput() {
    // convert input into a list of lists of ints
    return input
        .getPerLine()
        .map((e) => e.split('').nonNulls.map((f) => symbols[f]!).toList())
        .toList();
  }

  @override
  int solvePart1() {
    // map of all the cells where each cell is a set of valid directiosn
    final cellMap = parseInput();
    // coordinates of the start square
    final start = findStartLocation();
    // all of the squares that have connectors to start - at least two
    final firstStep = findFirstSteps(start, cellMap);

    // list of all the routes walked one for each first step so at least 2
    // print('Start: $start first steps ${firstStep.map((e) => e)}');
    final route = firstStep.map((e) {
      // print('Initiating calcRoute with $e');
      return calcRoute(
        start: start,
        firstStep: e,
        cellMap: cellMap,
        alreadyWalked: [],
      );
    });
    //print('-------------------------');
    // find the max length of any of the lists of steps
    final fullLength = route.map((e) => (e as List<Coordinate>).length).fold(
        0,
        (previousValue, element) =>
            previousValue > element ? previousValue : element);
    return ((fullLength - 1) / 2).round();
  }

  @override
  int solvePart2() {
    return 0;
  }
}
