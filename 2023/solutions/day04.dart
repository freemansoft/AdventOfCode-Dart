import 'dart:math';

import '../../utils/index.dart';

class Card {
  Card({
    required this.game,
    required this.winningNumbers,
    required this.cardNumbers,
  }) {
    numWinning =
        winningNumbers.toSet().intersection(cardNumbers.toSet()).length;
  }

  final int game;
  final List<int> winningNumbers;
  final List<int> cardNumbers;
  late int numWinning;

  @override
  String toString() {
    return '{ "game": $game , "winningNumbers": $winningNumbers,'
        ' "cardNumbers": $cardNumbers}';
  }
}

class Day04 extends GenericDay {
  Day04() : super(4);

  @override
  Iterable<Card> parseInput() {
    final lines = input.getPerLine();
    // each row is the "game" and the rounds
    final gameAndRounds = lines
        // process each row
        .map(
      (e) => Card(
        // yes we run the same split(':') twice :-(
        game: int.parse(e.split(':')[0].split(' ').last),
        winningNumbers: e
            .split(':')[1]
            .split('|')[0]
            .split(' ')
            .where((element) => element != '')
            .map(int.parse)
            .toList()
          ..sort(),
        cardNumbers: e
            .split(':')[1]
            .split('|')[1]
            .split(' ')
            .where((element) => element != '')
            .map(int.parse)
            .toList()
          ..sort(),
      ),
    );

    return gameAndRounds;
  }

  int numWinning(Card aCard) {
    return 0;
  }

  @override
  int solvePart1() {
    final foo = parseInput();
    final wins = foo.map((e) => e.numWinning);
    final powerScores =
        foo.map((e) => e.numWinning > 0 ? pow(2, e.numWinning - 1) : 0);
    print('numWins: ${wins.sum}, score: ${powerScores.sum as int} wins: $wins '
        ', scores: $powerScores');
    return powerScores.sum as int;
  }

  /// recursively descend to add the cards
  void calc(List<int> wins, int startIndex, List<int> currentCounts) {
    currentCounts[startIndex] += 1;
    if (wins[startIndex] > 0) {
      // use an iterator because we add by index later
      for (var j = 1;
          startIndex + j < wins.length && j <= wins[startIndex];
          j++) {
        calc(wins, startIndex + j, currentCounts);
      }
    }
  }

  @override
  int solvePart2() {
    final input = parseInput();
    final wins = input.map((e) => e.numWinning).toList();
    final numCards = List<int>.filled(wins.length, 0);
    // use an itertor because we add by index later
    // recursively descend each card
    for (var i = 0; i < wins.length; i++) {
      calc(wins, i, numCards);
    }
    print(numCards);
    return numCards.sum;
  }
}
