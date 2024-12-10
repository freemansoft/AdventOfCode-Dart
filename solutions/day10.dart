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
    final foundNines = trailheads.map((e) => doSomething(board, e)).toList();
    return foundNines.map((toElement) => toElement.length).sum;
  }

  @override
  int solvePart2() {
    return 0;
  }

  /// from a starting point, find all the 9s.
  List<AbsoluteCoordinate> doSomething(Board<int> board, AbsoluteCoordinate e) {
    print(e);
    var locations = [e];
    while ((board.getValueAtPosition(position: locations[0])) != 9) {
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
          'count: ${locations.length} from: $e ended at: $locations');
    }
    return locations;
  }
}
