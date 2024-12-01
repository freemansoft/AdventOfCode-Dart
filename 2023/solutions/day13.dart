import '../../utils/coordinate.dart';
import '../../utils/index.dart';

// NOT COMPLETE  WAS NOT FINISHED

class Day13 extends GenericDay {
  Day13() : super(13);

  /// list of paragraphs where each paragraph is a Coordiante and value
  @override
  List<Map<Coordinate, String>> parseInput() {
    final allPargraphs = input.getParagraphLines();

    // list of documents - each document is a map of values at coordinates
    // List<Map<Coordinate, String>>
    final paragraphsAsMaps = allPargraphs
        .map(
          (oneParagraph) => oneParagraph
              .mapIndexed(
                (rowIndex, oneRow) => oneRow.split('').mapIndexed(
                      (colIndex, oneChar) =>
                          {Coordinate(row: rowIndex, col: colIndex): oneChar},
                    ),
              )
              .flattened
              .fold(
            <Coordinate, String>{},
            mergeMaps,
          ),
        )
        .toList();
    return paragraphsAsMaps;
  }

  @override
  int solvePart1() {
    // first pargrah reflects across vertical
    // second paragraph reflects acros horizontal
    final allParagraphs = parseInput();
    final paragraphScores = allParagraphs.map((e) {
      final colHashes = calcHashesCol(e);
      final rowHashes = calcHashesRow(e);

      print(' vHash: $colHashes');
      print(' hHash: $rowHashes');

      return calcHorizReflectionLine(colHashes) * 100 +
          calcVertReflectionLine(rowHashes);
    }).toList();
    print('$paragraphScores');
    return paragraphScores.sum;
  }

  @override
  int solvePart2() {
    return 0;
  }

  // To Do: add recursion
  int calcHorizReflectionLine(List<int> colHashes) {
    for (var row = 0; row < colHashes.length; row++) {
      if (colHashes[row] == colHashes[row + 1]) return row;
    }
    return 0;
  }

  // To Do: add recursion
  int calcVertReflectionLine(List<int> rowHashes) {
    for (var col = 0; col < rowHashes.length; col++) {
      if (rowHashes[col] == rowHashes[col + 1]) return col;
    }
    return 0;
  }

  // a List of hashes, one for each column
  List<int> calcHashesCol(Map<Coordinate, String> allParagraph) {
    final colHashes = <int>[];
    var col = 0;
    // lazy bounds checking
    while (allParagraph.containsKey(Coordinate(row: 0, col: col))) {
      var row = 0;
      final colContents = <String>[];
      var aKey = Coordinate(row: row, col: col);
      while (allParagraph.containsKey(aKey)) {
        colContents.add(allParagraph[aKey]!);
        row += 1;
        aKey = Coordinate(row: row, col: col);
      }
      print('colContents: $colContents');
      colHashes.add(colContents.toString().hashCode);
      col += 1;
    }
    return colHashes;
  }

// a list of hashes, one for each row
  List<int> calcHashesRow(Map<Coordinate, String> allParagraph) {
    final rowHashes = <int>[];
    var row = 0;
    // lazy bounds checking
    while (allParagraph.containsKey(Coordinate(row: row, col: 0))) {
      var col = 0;
      final rowContents = <String>[];
      var aKey = Coordinate(row: row, col: col);
      while (allParagraph.containsKey(aKey)) {
        rowContents.add(allParagraph[aKey]!);
        col += 1;
        aKey = Coordinate(row: row, col: col);
      }
      print('rowContents: $rowContents');
      rowHashes.add(rowContents.toString().hashCode);
      row += 1;
    }
    return rowHashes;
  }
}
