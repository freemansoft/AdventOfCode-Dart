import '../utils/index.dart';

class Day12 extends GenericDay {
  Day12() : super(12);

  @override
  @override
  Board<String> parseInput() {
    final board = Board(
      field: InputUtil(12).getPerLine().map((e) => e.split('')).toList(),
    );
    return board;
  }

  @override
  int solvePart2() {
    return 0;
  }

  @override
  int solvePart1() {
    final board = parseInput();
    final processed = <AbsoluteCoordinate>{};
    final poolResult = <List<AbsoluteCoordinate>>[];
    board
        // seed the map with all the types
        .forEach(
      (location) {
        final result = processThis(board, location, processed);
        if (result.isNotEmpty) {
          print('value pool ${board.getValueAtPosition(position: location)}'
              ' count: ${result.length} result $result');
        }
        poolResult.add(result);
      },
    );
    // area *
    const sharedSides = 1;
    return poolResult
        .map(
          (aPool) =>
              aPool.length *
              (aPool.length * 4 - similarNeighbors(board, aPool)),
        )
        .sum;
  }

  /// Find all the contiguous items with the same value
  /// use `processed` to dedupe from previous runs
  List<AbsoluteCoordinate> processThis(
    Board<String> board,
    AbsoluteCoordinate location,
    Set<AbsoluteCoordinate> processed,
  ) {
    final aValue = board.getValueAtPosition(position: location);
    if (!processed.contains(location)) {
      processed.add(location);
      // print('processThis found'
      //     ' ${board.adjacentWhere(location, aValue).toList()}');
      return [
        location,
        ...board
            .adjacentWhere(location, aValue)
            .map(
              (relatedLocation) => processThis(
                board,
                relatedLocation,
                processed,
              ),
            )
            .flattened
        //.toList()
        ,
      ];
    } else {
      return [];
    }
  }

  /// find how many similar neighbor sides to remove
  int similarNeighbors(Board<String> board, List<AbsoluteCoordinate> aPool) {
    return aPool
        .map(
          (element) => board
              .adjacentWhere(
                element,
                board.getValueAtPosition(position: element),
              )
              .toList()
              .length,
        )
        .sum;
  }
}
