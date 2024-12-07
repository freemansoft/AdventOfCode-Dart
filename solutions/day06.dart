import '../tool/generic_day.dart';
import '../utils/board.dart';
import '../utils/index.dart';
import '../utils/input_util.dart';

class Day06 extends GenericDay {
  Day06() : super(6);

  @override
  List<List<String>> parseInput() {
    final field = InputUtil(6).getPerLine().map((e) => e.split('')).toList();
    return field;
  }

  @override
  int solvePart1() {
    final board = Board(field: parseInput());
    final orientation = findPlayerWithOrientation(board);
    print('$orientation');

    // the full path
    final covered = advanceAll(board: board, guardOrientation: orientation);
    print('covered: $covered');
    print('sorted ${covered.toSet().sorted()}');
    return covered.toSet().length;
  }

  @override
  int solvePart2() {
    // no idea.  don't know the graph theory
    return 0;
  }

  List<AbsoluteCoordinate> advanceAll<String>({
    required Board<String> board,
    required Transition<AbsoluteCoordinate, OffsetCoordinate> guardOrientation,
  }) {
    //
    final proposedTarget = guardOrientation.to.absoluteFrom(
      guardOrientation.from,
    );
    //
    if (!board.containsPosition(proposedTarget)) {
      // left the board
      return [guardOrientation.from];
    } else if (board.getValueAtPosition(position: proposedTarget) == '#') {
      var newTo = turnRight(guardOrientation.to);
      return advanceAll(
        board: board,
        guardOrientation: Transition(from: guardOrientation.from, to: newTo),
      );
    } else {
      return [
        guardOrientation.from,
        ...advanceAll(
          board: board,
          guardOrientation:
              Transition(from: proposedTarget, to: guardOrientation.to),
        ),
      ];
    }
  }

  OffsetCoordinate turnRight(OffsetCoordinate currentOrientation) {
    if (currentOrientation == const OffsetCoordinate(row: -1, col: 0)) {
      return const OffsetCoordinate(row: 0, col: 1);
    } else if (currentOrientation == const OffsetCoordinate(row: 0, col: 1)) {
      return const OffsetCoordinate(row: 1, col: 0);
    } else if (currentOrientation == const OffsetCoordinate(row: 1, col: 0)) {
      return const OffsetCoordinate(row: 0, col: -1);
    } else if (currentOrientation == const OffsetCoordinate(row: 0, col: -1)) {
      return const OffsetCoordinate(row: -1, col: 0);
    }
    // throw Exception('Invalid orientation'
    return currentOrientation;
  }

  Transition<AbsoluteCoordinate, OffsetCoordinate> findPlayerWithOrientation(
    Board<String> board,
  ) {
    for (var i = 0; i < board.boardHeight; i++) {
      for (var j = 0; j < board.boardWidth; j++) {
        if (board.getValueAt(row: i, col: j) == '^') {
          return Transition<AbsoluteCoordinate, OffsetCoordinate>(
            from: AbsoluteCoordinate(row: i, col: j),
            to: const OffsetCoordinate(row: -1, col: 0),
          );
        }
        if (board.getValueAt(row: i, col: j) == '>') {
          return Transition<AbsoluteCoordinate, OffsetCoordinate>(
            from: AbsoluteCoordinate(row: i, col: j),
            to: const OffsetCoordinate(row: 0, col: 1),
          );
        }
        if (board.getValueAt(row: i, col: j) == 'v') {
          return Transition<AbsoluteCoordinate, OffsetCoordinate>(
            from: AbsoluteCoordinate(row: i, col: j),
            to: const OffsetCoordinate(row: 1, col: 0),
          );
        }
        if (board.getValueAt(row: i, col: j) == '<') {
          return Transition<AbsoluteCoordinate, OffsetCoordinate>(
            from: AbsoluteCoordinate(row: i, col: j),
            to: const OffsetCoordinate(row: 0, col: -1),
          );
        }
      }
    }
    throw Exception('cannot find the guard');
  }
}
