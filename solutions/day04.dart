import '../utils/index.dart';

class Day04 extends GenericDay {
  Day04() : super(4);

  @override
  List<List<String>> parseInput() {
    final inputTool = InputUtil(4);
    var charForField = inputTool.perLineToCells(
      inputTool.getPerLine(),
      '',
      (String aChar) => aChar,
    );
    return charForField;
  }

  @override
  int solvePart1() {
    final ourField = Board(
      field: parseInput(),
    );

    var found = 0;
    print(ourField);
    print('width: ${ourField.boardWidth}, height: ${ourField.boardHeight}');
    final agentX = ourField.positionsOf('X').toList();

    print('found: ${agentX.length} agentX: $agentX');
    for (final oneX in agentX) {
      final neighbors = ourField.neighboursWhere(oneX, 'M');
      print('for $oneX found: ${neighbors.length} neighbours: $neighbors');
      for (final neighborM in neighbors) {
        // calculate the distance from X to M
        final offset = oneX.offsetTo(neighborM);
        // now apply that on M to A and A to S
        final neighborA = offset.absoluteFrom(neighborM);
        if (ourField.isOnboard(position: neighborA) &&
            ourField.getValueAtPosition(position: neighborA) == 'A') {
          final neighborS = offset.absoluteFrom(neighborA);
          if (ourField.isOnboard(position: neighborS) &&
              ourField.getValueAtPosition(position: neighborS) == 'S') {
            print('found S at $neighborS');
            found += 1;
          }
        }
      }
    }

    return found;
  }

  /// oh the horror!
  @override
  int solvePart2() {
    final ourField = Board(
      field: parseInput(),
    );

    var found = 0;
    print(ourField);
    print('width: ${ourField.boardWidth}, height: ${ourField.boardHeight}');
    final agentA = ourField.positionsOf('A').toList();

    print('found As: ${agentA.length} agentA: $agentA');

    for (final anA in agentA) {
      // for each A see if it is in an X
      final neighborsM = ourField.neighboursWhere(anA, 'M');

      for (final oneM in neighborsM) {
        final oneMOffset = anA.offsetTo(oneM);
        // only do diagonals
        if (oneMOffset.row != 0 && oneMOffset.col != 0) {
          // look for the S on the opposite side of the A
          final possibleSOffset = oneMOffset.invert;
          final possibleSLocation = possibleSOffset.absoluteFrom(anA);
          if (ourField.isOnboard(position: possibleSLocation) &&
              ourField.getValueAtPosition(position: possibleSLocation) == 'S') {
            print('found MAS string : '
                'offset $oneMOffset :'
                ' M at $oneM :'
                ' A at $anA :'
                ' S at $possibleSLocation');
            // mirror on the row axis
            final mirrorM1 = AbsoluteCoordinate(
              row: anA.row + (oneMOffset.row * -1),
              col: oneM.col,
            );
            final mirrorS1 = AbsoluteCoordinate(
              row: anA.row + (possibleSOffset.row * -1),
              col: possibleSLocation.col,
            );
            // mirror on the col axis
            final mirrorM2 = AbsoluteCoordinate(
              row: oneM.row,
              col: anA.col + (oneMOffset.col * -1),
            );
            final mirrorS2 = AbsoluteCoordinate(
              row: possibleSLocation.row,
              col: anA.col + (possibleSOffset.col * -1),
            );
            if ((ourField.isOnboard(position: mirrorM1) &&
                    ourField.getValueAtPosition(position: mirrorM1) == 'M' &&
                    ourField.isOnboard(position: mirrorS1) &&
                    ourField.getValueAtPosition(position: mirrorS1) == 'S') ||
                (ourField.isOnboard(position: mirrorM2) &&
                    ourField.getValueAtPosition(position: mirrorM2) == 'M' &&
                    ourField.isOnboard(position: mirrorS2) &&
                    ourField.getValueAtPosition(position: mirrorS2) == 'S')) {
              found += 1;
            } else {
              // do nothing
            }
          }
        }
      }
    }

    // we find both mirror sides of the X
    return found ~/ 2;
  }
}
