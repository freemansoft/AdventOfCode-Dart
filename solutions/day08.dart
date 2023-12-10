import '../utils/index.dart';

// part 1 only
class Day08 extends GenericDay {
  Day08() : super(8);

  // right left sequence
  late List<String> rl;
  // step map for our step dancing
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
    var currentLocation = 'AAA';
    const targetLocation = 'ZZZ';
    var index = rl.length;
    var locationIndex = index % rl.length;
    while (currentLocation != targetLocation) {
      //print('1. $currentLocation $index $locationIndex ');
      currentLocation = steps[currentLocation]![rl[locationIndex]]!;
      index = index + 1;
      locationIndex = index % rl.length;
      //print('2. $currentLocation $index $locationIndex ');
    }
    return index - rl.length;
  }

  /// Not correct
  /// but I think it is close
  @override
  int solvePart2() {
    parseInput();
    print('part 2:');
    final minimumSteps = steps.keys
        // find all the starting spots
        .where((element) => element.endsWith('A'))
        .map(calcIterations)
        .toList();
    print('minimum steps $minimumSteps');
    final answer = minimumSteps.reduce((value, element) => lcm(value, element));
    final multiplesPerStep = minimumSteps.map((e) => answer / e).toList();
    print('least common multiple $answer');
    print('divisor per step $multiplesPerStep');
    return answer;
  }
  // (6837, 10519, 1314, 11045, 19987)
  // (1017095887470630.0, 661078484897490.0, 5292149606268415.0, 629595706893318.0, 347920377377130.0)

  int calcIterations(String e) {
    {
      // print('starting spot $e with pattern $rl');
      // all paths are the same so just randomly pick one
      var currentLocation = e;
      // endsWidth instead of ==
      const targetLocation = 'Z';
      var index = rl.length;
      var locationIndex = index % rl.length;
      //print(e);
      while (!currentLocation.endsWith(targetLocation)) {
        // print(
        //     'current location $currentLocation ${steps[currentLocation]} -> ${rl[locationIndex]}');
        currentLocation = steps[currentLocation]![rl[locationIndex]]!;
        index = index + 1;
        locationIndex = index % rl.length;
      }
      // print(
      //     'finished location $currentLocation ${steps[currentLocation]} -> ${rl[locationIndex]}');
      return index - rl.length;
    }
  }

  /// least common multiple
  int lcm(int a, int b) => (a * b) ~/ gcd(a, b);

  /// greatest common demoninator
  int gcd(int a, int b) {
    while (b != 0) {
      final t = b;
      b = a % t;
      a = t;
    }
    return a;
  }
}
