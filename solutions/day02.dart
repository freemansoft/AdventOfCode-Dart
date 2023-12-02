import '../utils/index.dart';
import 'dart:math';

class Day02 extends GenericDay {
  Day02() : super(2);

  // Maximum allowed by color
  final maxByColor = {'red': 12, 'green': 13, 'blue': 14};

  /// returns a list of games
  ///   each game is a Map
  ///     "Game" :game_number
  ///     "Rounds": List of rounds.
  ///       each round is a Map of the red/green/blue
  @override
  List<Map<dynamic, dynamic>> parseInput() {
    final lines = input.getPerLine();
    // each row is the "game" and the rounds
    final gameAndRounds = lines
        // process each row
        .map((e) => {
              // yes we run the same split(':') twice :-(
              'Game': int.parse(e.split(':')[0].split(' ')[1]),
              'Rounds': e
                  // top level split game from rounds and toss the game number
                  .split(':')[1]
                  // now split the games in the round
                  .split(';')
                  .map(
                    // split red/green/blue into a map
                    (g) => {
                      for (final v in g.split(',').map(
                            (h) => h.trim().split(' '),
                          ))
                        v[1]: int.parse(v[0]),
                    },
                  )
                  .toList(),
            }) //
        .toList();
    return gameAndRounds;
  }

  // final firstLastDigits =
  //     lineAllDigits.map((e) => int.parse(e[0] + e[e.length - 1])).toList();

  /// list of rounds
  /// each round is a 'red', 'green', 'blue'
  bool isValidGame(List<Map<String, int>> rounds) {
    return rounds
            .map(
              (e) =>
                  (!e.containsKey('red') ||
                      e['red'] as int <= maxByColor['red']!) &&
                  (!e.containsKey('green') ||
                      e['green'] as int <= maxByColor['green']!) &&
                  (!e.containsKey('blue') ||
                      e['blue'] as int <= maxByColor['blue']!),
            )
            .where((element) => element == true)
            .toList()
            .length ==
        rounds.length;
  }

  /// returns list of game numbers that are valid
  List<int> findValidGames(List<Map<dynamic, dynamic>> inputs) {
    return inputs
        .map((e) => isValidGame(e['Rounds'] as List<Map<String, int>>)
            ? e['Game'] as int
            : null)
        .nonNulls
        .toList();
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
    // print(
    //     '$gameNum ==> red: $red, green: $green, blue: $blue ==> ${red * green * blue}');
    return red * green * blue;
  }

  // return the list of the powers
  List<int> findThePowersOfGames(List<Map<dynamic, dynamic>> inputs) {
    return inputs
        .map((e) => powerFromGame(
            e['Game'] as int, e['Rounds'] as List<Map<String, int>>))
        .toList();
  }

  @override
  int solvePart2() {
    final allRounds = parseInput();
    final thePowers = findThePowersOfGames(allRounds);
    return thePowers.sum;
  }
}
