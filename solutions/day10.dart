import '../utils/index.dart';

class Day10 extends GenericDay {
  Day10() : super(10);

  @override
  Board<int> parseInput() {
    final board = IntegerBoard.fromString(input.asString, unparsableValue: -1);
    return board;
  }

  @override
  int solvePart1() {
    final board = parseInput();
    final trailheads = board.positionsOf(0).toList();
    // number of nines for each trailhead
    final foundNines =
        trailheads.map((e) => takingItToTheNines(board, e)).toList();
    return foundNines.map((toElement) => toElement.length).sum;
  }

  @override
  int solvePart2() {
    return 0;
  }

  /// from a starting point, find all the 9s.
  List<AbsoluteCoordinate> takingItToTheNines(
    Board<int> board,
    AbsoluteCoordinate startingLocation, {
    int endingValue = 9,
  }) {
    print(startingLocation);
    var locations = [startingLocation];
    while ((board.getValueAtPosition(position: locations[0])) != endingValue) {
      locations = locations
          .map(
            (start) => board.adjacentWhere(
              start,
              board.getValueAtPosition(position: start) + 1,
            ),
          )
          .flattened
          .toSet()
          .toList();
      print('step ${board.getValueAtPosition(position: locations[0])} '
          'count: ${locations.length} '
          'from: $startingLocation '
          'ended at: $locations');
    }
    return locations;
  }
}
