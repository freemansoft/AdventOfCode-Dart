import '../utils/index.dart';

class Day11 extends GenericDay {
  Day11() : super(11);

  @override
  List<int> parseInput() {
    return input.getBy(' ').map(int.parse).toList();
  }

  @override
  int solvePart1() {
    final ourInts = parseInput();

    const blinkTarget = 25;

    final listOneMap = loopIt(ourInts, blinkTarget);
    return listOneMap.entries.fold<int>(
        0, (previousValue, mapEntry) => previousValue + mapEntry.value);
  }

  @override
  int solvePart2() {
    final ourInts = parseInput();

    const blinkTarget = 75;

    final listOneMap = loopIt(ourInts, blinkTarget);
    return listOneMap.entries.fold<int>(
        0, (previousValue, mapEntry) => previousValue + mapEntry.value);
  }

  Map<int, int> loopIt(List<int> ourInts, int blinkTarget) {
    final listOne = ourInts;
    print('$listOne');

    final foo = listOne.map(
      (toElement) => MapEntry<int, int>(toElement, 1),
    );
    var listOneMap = Map<int, int>.fromEntries(foo);

    for (var blinkCount = 0; blinkCount < blinkTarget; blinkCount++) {
      // value, count
      final listTwo = <int, int>{};
      print('starting $blinkCount map $listOneMap');
      for (final anEntry in listOneMap.entries) {
        final anInt = anEntry.key;
        if (anInt == 0) {
          if (!listTwo.containsKey(1)) listTwo[1] = 0;
          listTwo[1] = listTwo[1]! + anEntry.value;
        } else if (anInt.toString().length.isEven) {
          final anIntString = anInt.toString();
          final key1 =
              int.parse(anIntString.substring(0, anIntString.length ~/ 2));
          if (!listTwo.containsKey(key1)) listTwo[key1] = 0;
          listTwo[key1] = listTwo[key1]! + anEntry.value;
          final key2 =
              int.parse(anIntString.substring(anIntString.length ~/ 2));
          if (!listTwo.containsKey(key2)) listTwo[key2] = 0;
          listTwo[key2] = listTwo[key2]! + anEntry.value;
        } else {
          if (!listTwo.containsKey(anInt * 2024)) {
            listTwo[anInt * 2024] = 0;
          }
          listTwo[anInt * 2024] = listTwo[anInt * 2024]! + anEntry.value;
        }
      }

      listOneMap = listTwo;
      print('after : ${blinkCount + 1} '
          'count : ${listTwo.entries.fold<int>(0, (previousValue, mapEntry) => previousValue + mapEntry.value)} '
          'current  $listTwo');
    }
    return listOneMap;
  }
}
