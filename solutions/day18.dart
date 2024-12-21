import '../utils/index.dart';

class Day18 extends GenericDay {
  Day18() : super(18);

  @override
  List<List<int>> parseInput() {
    final foo = InputUtil(18)
        .getPerLine()
        .map(
          (toElement) => toElement.split(',').map(int.parse).toList(),
        )
        .toList();
    return foo;
  }

  @override
  int solvePart1() {
    const boardWidth = 7;
    const boardHeight = 7;

    final rocks = parseInput();
    final ourBoard =
        Board<String>.filled(width: boardWidth, height: boardHeight, fill: '.');
    //print(ourBoard);
    // the input is in X,Y format
    for (final rock in rocks) {
      ourBoard.setValueAt(row: rock[1], col: rock[0], value: '#');
    }
    // print(ourBoard);

    // now we need to find the path from 00 to (boardWidth-1,boardHeight-1)
    advance(
      end: const AbsoluteCoordinate(row: boardWidth - 1, col: boardHeight - 1),
      board: ourBoard,
      visited: <AbsoluteCoordinate>{},
      openTasks: <AbsoluteCoordinate>[const AbsoluteCoordinate(row: 0, col: 0)],
    );

    return 0;
  }

  @override
  int solvePart2() {
    return 0;
  }

  // pull the first task
  bool advance({
    required AbsoluteCoordinate end,
    required Board<String> board,
    required Set<AbsoluteCoordinate> visited,
    required List<AbsoluteCoordinate> openTasks,
  }) {
    // this is failure actually
    if (openTasks.isEmpty) return false;

    final currentTask = openTasks.removeAt(0);
    visited.add(currentTask);

    if (currentTask == end) {
      print('found: $end have-visited: ${visited.length}');
      return true;
    }
    final possibleTargets = board.adjacentWhere(currentTask, '.');
    for (final target in possibleTargets) {
      if (!visited.contains(target) && !openTasks.contains(target)) {
        openTasks.add(target);
        print('added: $target openTasks: $openTasks');
      }
    }

    var found = false;
    while (openTasks.isNotEmpty && !found) {
      found = advance(
        end: end,
        board: board,
        visited: visited,
        openTasks: openTasks,
      );
    }
    //print('visited: ${visited.length} $visited');
    return found;
  }
}
