import '../utils/index.dart';

class Day08 extends GenericDay {
  Day08() : super(8);

  @override
  Board<String> parseInput() {
    final board = Board<String>(
      field: input.perLineToCells(
        input.getPerLine(),
        '',
        (x) => x,
      ),
    );
    print('$board');
    return board;
  }

  @override
  int solvePart1() {
    final board = parseInput();
    final antennaMap = board.positionsOfAll(ignoreValue: '.');
    print('$antennaMap');
    final existingAntennas = antennaMap.entries
        .map(
          (entry) => MapEntry<String, List<CoordinatePair>>(
            entry.key,
            crossProduct(entry.value),
          ),
        )
        .toList();
    print('existing antennas types: ${existingAntennas.length} '
        '\npairs:${existingAntennas.map(
      (entry) => '\n${entry.key}, ${entry.value.length}, ${entry.value}',
    )}');

    // may be on or off the board
    final newAntennas = existingAntennas
        .map(
          (aType) => MapEntry(
            aType.key,
            aType.value.map((anEntry) {
              // create the jammer pairs
              final offset1 = anEntry.to.offsetTo(anEntry.from);
              final jammer1 = offset1.absoluteFrom(anEntry.from);
              final offset2 = anEntry.from.offsetTo(anEntry.to);
              final jammer2 = offset2.absoluteFrom(anEntry.to);
              final jammerPair = CoordinatePair(from: jammer1, to: jammer2);
              print('pre board check pr $anEntry jammer pair $jammerPair');
              return jammerPair;
            }).toList(),
          ),
        )
        .toList();

    return newAntennas
        .map((element) => element.value.expand((pair) => [pair.from, pair.to]))
        .flattened
        .where((position) => board.isOnboard(position: position))
        .toSet()
        .length;
  }

  @override
  int solvePart2() {
    final board = parseInput();
    final antennaMap = board.positionsOfAll(ignoreValue: '.');
    print('$antennaMap');
    final existingAntennas = antennaMap.entries
        .map(
          (entry) => MapEntry<String, List<CoordinatePair>>(
            entry.key,
            crossProduct(entry.value),
          ),
        )
        .toList();
    print('existing antennas types: ${existingAntennas.length} '
        '\npairs:${existingAntennas.map(
      (entry) => '\n${entry.key}, ${entry.value.length}, ${entry.value}',
    )}');

    // may be on or off the board
    final newAntennas = existingAntennas
        .map(
          (aType) => MapEntry(
            aType.key,
            aType.value.expand((anEntry) {
              final found = <AbsoluteCoordinate>[];
              // build out in two directions
              final offset1 = anEntry.to.offsetTo(anEntry.from);
              var jammer1 = offset1.absoluteFrom(anEntry.from);
              while (board.isOnboard(position: jammer1)) {
                found.add(jammer1);
                jammer1 = offset1.absoluteFrom(jammer1);
              }
              // now the second direction
              final offset2 = anEntry.from.offsetTo(anEntry.to);
              var jammer2 = offset2.absoluteFrom(anEntry.to);
              while (board.isOnboard(position: jammer2)) {
                found.add(jammer2);
                jammer2 = offset2.absoluteFrom(jammer2);
              }
              return found;
            }).toList(),
          ),
        )
        .toList();

    final newAntennaFlat =
        newAntennas.map((element) => element.value).flattened;
    final existingAntennaFlat = antennaMap.values.flattened;
    return [newAntennaFlat, existingAntennaFlat].flattened.toSet().length;
  }

  /// a misuse of the term transition here
  List<CoordinatePair> crossProduct(
    List<AbsoluteCoordinate> locations,
  ) {
    final allPairs = <CoordinatePair>[];
    for (final first in locations) {
      for (final second in locations) {
        final one = CoordinatePair(from: first, to: second);
        final two = CoordinatePair(from: second, to: first);
        if (first != second &&
            !allPairs.contains(one) &&
            !allPairs.contains(two)) {
          allPairs.add(CoordinatePair(from: first, to: second));
        }
      }
    }

    return allPairs;
  }
}
