import '../utils/index.dart';

class Day14 extends GenericDay {
  Day14() : super(14);

  @override
  List<OffsetOutboundTransition> parseInput() {
    final bots = InputUtil(14).getPerLine().map((e) {
      final p = e.split(' ')[0].substring(2).split(',');
      final v = e.split(' ')[1].substring(2).split(',');
      return OffsetOutboundTransition(
        from: AbsoluteCoordinate(row: int.parse(p[1]), col: int.parse(p[0])),
        to: OffsetCoordinate(
          row: int.parse(v[1]),
          col: int.parse(v[0]),
        ),
      );
    }).toList();

    return bots;
  }

  @override
  int solvePart1() {
    // const sizeWidth = 11;
    // const sizeHeight = 7;
    const sizeWidth = 101;
    const sizeHeight = 103;
    const seconds = 100;

    final bots = parseInput();
    print('${bots.length} - $bots');
    final finalBots = bots
        .map((aBot) =>
            aBot.moveBy(seconds, wrapWidth: sizeWidth, wrapHeight: sizeHeight))
        .toList();
    final finalBotPositions = finalBots.map((e) => e.from);
    print(
        'final bot ${finalBotPositions.length} positions\n ${finalBotPositions.toList()}');

    // build the bounding boxes
    final quadBoxes = [
      const CoordinatePair(
        from: AbsoluteCoordinate(
          row: 0,
          col: 0,
        ),
        to: AbsoluteCoordinate(
          row: (sizeHeight ~/ 2) - 1,
          col: (sizeWidth ~/ 2) - 1,
        ),
      ),
      const CoordinatePair(
        from: AbsoluteCoordinate(
          row: 0,
          col: (sizeWidth ~/ 2) + 1,
        ),
        to: AbsoluteCoordinate(
          row: (sizeHeight ~/ 2) - 1,
          col: sizeWidth - 1,
        ),
      ),
      const CoordinatePair(
        from: AbsoluteCoordinate(
          row: (sizeHeight ~/ 2) + 1,
          col: 0,
        ),
        to: AbsoluteCoordinate(
          row: sizeHeight - 1,
          col: (sizeWidth ~/ 2) - 1,
        ),
      ),
      const CoordinatePair(
        from: AbsoluteCoordinate(
          row: (sizeHeight ~/ 2) + 1,
          col: (sizeWidth ~/ 2) + 1,
        ),
        to: AbsoluteCoordinate(
          row: sizeHeight - 1,
          col: sizeWidth - 1,
        ),
      ),
    ];
    print('quadrant boxes are $quadBoxes');
    final quadCounts = <int>[0, 0, 0, 0];

    for (final aBot in finalBotPositions) {
      outer:
      for (var i = 0; i < quadCounts.length; i++) {
        if (aBot.row >= quadBoxes[i].from.row &&
            aBot.row <= quadBoxes[i].to.row &&
            aBot.col >= quadBoxes[i].from.col &&
            aBot.col <= quadBoxes[i].to.col) {
          quadCounts[i] += 1;
          break outer;
        }
      }
    }
    print('${quadCounts.sum} - $quadCounts');
    return quadCounts[0] * quadCounts[1] * quadCounts[2] * quadCounts[3];
  }

  @override
  int solvePart2() {
    return 0;
  }
}
