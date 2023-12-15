import '../utils/index.dart';
import 'index.dart';

class Day14 extends GenericDay {
  Day14() : super(14);

  // contains just the locations of pieces
  late Map<Coordinate, String> board;
  int numRows = 0;
  int numCols = 0;

  @override
  void parseInput() {
    final lines = input.getPerLine();
    numRows = lines[0].length;
    numCols = lines.length;
    // generate a list of Maps keyed row:col and then merge the Maps
    board = lines
        .mapIndexed(
          (row, element) => element.split('').mapIndexed(
              (col, element) => {Coordinate(row: row, col: col): element}),
        )
        // each Iterator contains 1 Hasmap with one entry {coordinate:character}
        // put all the resulting maps into one Map by coordinate
        .flattened
        .fold(
      {},
      (previousValue, element) => mergeMaps(previousValue, element),
    )..removeWhere((key, value) => value == '.');
  }

  Map<Coordinate, String> tiltWest(Map<Coordinate, String> sourceBoard) {
    final resultBoard = <Coordinate, String>{};
    for (var row = 0; row < numRows; row++) {
      var lastFullCol = -1;
      for (var col = 0; col < numCols; col++) {
        final thisCell = Coordinate(row: row, col: col);
        if (sourceBoard[thisCell] == '#') {
          resultBoard[thisCell] = '#';
          lastFullCol = col;
        } else if (sourceBoard[thisCell] == 'O') {
          resultBoard[Coordinate(row: row, col: lastFullCol + 1)] = 'O';
          lastFullCol += 1;
        }
      }
    }
    return resultBoard;
  }

  Map<Coordinate, String> tiltEast(Map<Coordinate, String> sourceBoard) {
    final resultBoard = <Coordinate, String>{};
    for (var row = 0; row < numRows; row++) {
      var lastFullCol = numCols;
      for (var col = numCols - 1; col >= 0; col--) {
        final thisCell = Coordinate(row: row, col: col);
        if (sourceBoard[thisCell] == '#') {
          resultBoard[thisCell] = '#';
          lastFullCol = col;
        } else if (sourceBoard[thisCell] == 'O') {
          resultBoard[Coordinate(row: row, col: lastFullCol - 1)] = 'O';
          lastFullCol -= 1;
        }
      }
    }
    return resultBoard;
  }

  Map<Coordinate, String> tiltNorth(Map<Coordinate, String> sourceBoard) {
    final resultBoard = <Coordinate, String>{};
    for (var col = 0; col < numCols; col++) {
      var lastFullRow = -1;
      for (var row = 0; row < numRows; row++) {
        final thisCell = Coordinate(row: row, col: col);
        if (sourceBoard[thisCell] == '#') {
          resultBoard[thisCell] = '#';
          lastFullRow = row;
        } else if (sourceBoard[thisCell] == 'O') {
          resultBoard[Coordinate(row: lastFullRow + 1, col: col)] = 'O';
          lastFullRow += 1;
        }
      }
    }
    return resultBoard;
  }

  Map<Coordinate, String> tiltSouth(Map<Coordinate, String> sourceBoard) {
    final resultBoard = <Coordinate, String>{};
    for (var col = 0; col < numCols; col++) {
      var lastFullRow = numRows;
      for (var row = numRows - 1; row >= 0; row--) {
        final thisCell = Coordinate(row: row, col: col);
        if (sourceBoard[thisCell] == '#') {
          resultBoard[thisCell] = '#';
          lastFullRow = row;
        } else if (sourceBoard[thisCell] == 'O') {
          resultBoard[Coordinate(row: lastFullRow - 1, col: col)] = 'O';
          lastFullRow -= 1;
        }
      }
    }
    return resultBoard;
  }

  @override
  int solvePart1() {
    parseInput();
    final finalBoard = tiltNorth(board);

    return finalBoard.entries
        .map((e) => e.value == 'O' ? numRows - e.key.row : 0)
        .sum;
  }

  @override
  int solvePart2() {
    parseInput();
    var finalBoard = tiltNorth(board);
    var cache = <int, int>{};

    // tilting the board in the same direction leaves it the same
    for (var i = 0; i < 1000000000; i++) {
      finalBoard = tiltNorth(finalBoard);
      finalBoard = tiltWest(finalBoard);
      finalBoard = tiltSouth(finalBoard);
      finalBoard = tiltEast(finalBoard);
      final boardWeight = finalBoard.entries
          .map((e) => e.value == 'O' ? numRows - e.key.row : 0)
          .sum;
      if (cache.containsKey(boardWeight)) {
        print('repeated sum $boardWeight at index $i : iteration ${i + 1} '
            'from cached index ${cache[boardWeight]}');
        //break;
      } else {
        cache[boardWeight] = i;
      }
    }

    /*

    Log cache duplication

    I broke the loop after seeing it start to repeat
    Sequential cache hits -- once I have two secquential we are probably good

    1,000,000,000 Iterations
    999,999,999 Final index because start at zero
    124 was the last index prior to repeating
    999,999,875 index of the beginning of the loop

    183 was the index of the end of the repeat cycle
    59 was the loop length 183-125+1 (length not diff)

    25 is 999,999,875 mod 59
    149 is the index that is where we end up int he loop 124+25

    look at the cache for an sum at iteration 149 ==> 103445

    */

    //print(finalBoard);

    return finalBoard.entries
        .map((e) => e.value == 'O' ? numRows - e.key.row : 0)
        .sum;
  }
}
