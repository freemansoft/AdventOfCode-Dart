import '../utils/index.dart';

// part 1 only
class Day08 extends GenericDay {
  Day08() : super(8);

  late List<String> rl;
  late Map<String, Map<String, String>> steps;

  @override
  parseInput() {
    var foo = input.getPerLine();
    rl = foo[0].split('');
    steps = Map.fromEntries(foo.sublist(2).map((e) {
      final stuff = e
          .replaceAll(' = (', ' ')
          .replaceAll(', ', ' ')
          .replaceAll(')', '')
          .split(' ');
      return MapEntry(stuff[0], {'L': stuff[1], 'R': stuff[2]});
    }).toList());
  }

  @override
  int solvePart1() {
    parseInput();
    String currentLocation = 'AAA';
    String targetLocation = 'ZZZ';
    int index = rl.length;
    int locationIndex = index % rl.length;
    while (currentLocation != targetLocation) {
      print('1. $currentLocation $index $locationIndex ');
      currentLocation = steps[currentLocation]![rl[locationIndex]]!;
      index = index + 1;
      locationIndex = index % rl.length;
      print('2. $currentLocation $index $locationIndex ');
    }
    return index - rl.length;
  }

  @override
  int solvePart2() {
    return 0;
  }
}
