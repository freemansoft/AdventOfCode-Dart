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

  @override
  int solvePart2() {
    return 0;
  }
}
