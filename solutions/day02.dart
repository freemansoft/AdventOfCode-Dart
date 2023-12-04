import '../utils/index.dart';

class Day02 extends GenericDay {
  Day02() : super(2);

  // Maximum allowed by color
  final maxByColor = {'red': 12, 'green': 13, 'blue': 14};

  /// returns an Iterable of games from the input file
  ///   each game is a Map
  ///     "Game" :game_number
  ///     "Rounds": List of rounds.
  ///       each round is a Map of the red/green/blue
  @override
  Iterable<Map<dynamic, dynamic>> parseInput() {
    final lines = input.getPerLine();
    // each row is the "game" and the rounds
    final gameAndRounds = lines
        // process each row
        .map(
      (e) => {
        // yes we run the same split(':') twice :-(
        'Game': int.parse(e.split(':')[0].split(' ')[1]),
        'Rounds': e
            // top level split game from rounds and toss the game number
            .split(':')[1]
            // now split the games in the round
            .split(';')
            .map(
              // split each round's red/green/blue into a map
              (g) => {
                for (final v in g.split(',').map(
                      (h) => h.trim().split(' '),
                    ))
                  v[1]: int.parse(v[0]),
              },
            )
            .toList(),
      },
    );
    return gameAndRounds;
  }

  // final firstLastDigits =
  //     lineAllDigits.map((e) => int.parse(e[0] + e[e.length - 1])).toList();

  /// list of rounds
  /// each round is a 'red', 'green', 'blue'
  /// The number of red, green and blue in each round must be < maxByColor
  bool isValidGame(List<Map<String, int>> rounds) {
    return rounds
            .map(
              (e) =>
                  (!e.containsKey('red') || e['red']! <= maxByColor['red']!) &&
                  (!e.containsKey('green') ||
                      e['green']! <= maxByColor['green']!) &&
                  (!e.containsKey('blue') || e['blue']! <= maxByColor['blue']!),
            )
            .where((element) => element == true)
            .toList()
            .length ==
        rounds.length;
  }

  /// returns list of game numbers that are valid
  Iterable<int> findValidGames(Iterable<Map<dynamic, dynamic>> inputs) {
    return inputs
        .map(
          (e) => isValidGame(e['Rounds'] as List<Map<String, int>>)
              ? e['Game'] as int
              : null,
        )
        .nonNulls;
  }

  @override
  int solvePart1() {
    final allRounds = parseInput();
    final validGames = findValidGames(allRounds);
    //print(allRounds);
    //print(validGames);
    return validGames.sum;
  }

  // return the max(red) * max(green) * max(blue)
  int powerFromGame(int gameNum, List<Map<String, int>> aGame) {
    // ignore: inference_failure_on_function_invocation
    final red = aGame
        .map((e) => e['red'] ?? 0)
        .nonNulls
        .reduce((value, element) => value > element ? value : element);
    final green = aGame
        .map((e) => e['green'] ?? 0)
        .nonNulls
        .reduce((value, element) => value > element ? value : element);
    final blue = aGame
        .map((e) => e['blue'] ?? 0)
        .nonNulls
        .reduce((value, element) => value > element ? value : element);
    return red * green * blue;
  }

  // return the powers for every game
  Iterable<int> findThePowersOfGames(Iterable<Map<dynamic, dynamic>> inputs) {
    return inputs.map(
      (e) => powerFromGame(
        e['Game'] as int,
        e['Rounds'] as List<Map<String, int>>,
      ),
    );
  }

  @override
  int solvePart2() {
    final allRounds = parseInput();
    final thePowers = findThePowersOfGames(allRounds);
    return thePowers.sum;
  }
}
