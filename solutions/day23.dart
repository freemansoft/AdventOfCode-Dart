import 'package:test/test.dart';

import '../utils/index.dart';

class Day23 extends GenericDay {
  Day23() : super(23);

  @override
  Map<String, List<String>> parseInput() {
    final pairs = InputUtil(23).getPerLine().map((e) => e.split('-')).toList();
    final allNodes = <String, List<String>>{};
    // adding empty and dont' care about efficiency
    // seed the map
    for (final oneLine in pairs) {
      allNodes[oneLine[0]] = <String>[];
      allNodes[oneLine[1]] = <String>[];
    }
    for (final oneLine in pairs) {
      allNodes[oneLine[0]]!.add(oneLine[1]);
      allNodes[oneLine[1]]!.add(oneLine[0]);
    }
    return allNodes;
  }

  @override
  int solvePart1() {
    final allNodes = parseInput();
    print('allNodes $allNodes');
    final tNodes = Map.fromEntries(
      allNodes.entries
          .where((entry) => entry.key.startsWith('t') && entry.value.isNotEmpty)
          .toList(),
    );
    print('tNodes $tNodes');

    final foo = allNodes.keys
        .where((entry) => entry.startsWith('t'))
        .map(
          (aKey) {
            final foundSets = <String>{};
            for (var i = 0; i < allNodes[aKey]!.length - 1; i++) {
              for (var j = i + 1; j < allNodes[aKey]!.length; j++) {
                if (allNodes[allNodes[aKey]![i]]!
                    .contains(allNodes[aKey]![j])) {
                  foundSets.add(
                    [aKey, allNodes[aKey]![i], allNodes[aKey]![j]]
                        .sorted()
                        .toString(),
                  );
                }
                //
              }
            }
            return foundSets;
          },
        )
        .flattened
        .toSet();
    print(' found: $foo');
    return foo.length;
  }

  /// totally not used but it was such massive nested overkill that I kept it
  int solvePart3() {
    final allNodes = parseInput();
    final tNodes = Map.fromEntries(allNodes.entries
        .where((entry) => entry.key.startsWith('t') && entry.value.isNotEmpty)
        .toList());
    print('tNodes $tNodes');
    final y = tNodes.keys
        .map(
          (tKey) => {
            tKey: allNodes[tKey]!
                .map(
                  (oneSecond) => allNodes[oneSecond]!
                      .where((oneThird) => oneThird != tKey)
                      .map((something) => [tKey, oneSecond, something].sorted())
                      .toList(),
                )
                .flattened
                .toList(),
          },
        )
        // pull up these values out of the map
        .expand((toElements) => toElements.values)
        // flatten with the tKey
        .flattened
        .toList();
    print('y.length ${y.length} y $y');
    final tryAndMapIt = {for (var foo in y) foo.toString(): foo};
    print(
        ' tryAndMapIt ${tryAndMapIt.length} ${tryAndMapIt.keys.toList().sorted()}');

    return 0;
  }

  @override
  int solvePart2() {
    return 0;
  }
}
