// THIS DOES NOT WORK :-(
//

import '../../utils/index.dart';

class Hand {
  Hand({
    required this.sortedCards,
    required this.unsortedCards,
    required this.bid,
    required this.mappedCards,
    required this.handType,
    required this.handWeight,
  });

  final List<int> sortedCards;
  final List<int> unsortedCards;
  final int bid;
  final Map<int, int> mappedCards;
  final int handType;
  final int handWeight;

  // weight within a handType
}

int handWeight(List<int> cards) {
  return cards[0] * 100000000 +
      cards[1] * 1000000 +
      cards[2] * 10000 +
      cards[3] * 100 +
      cards[4];
}

class Day07 extends GenericDay {
  Day07() : super(7);

  final cardValue = {
    'A': 14,
    'K': 13,
    'Q': 12,
    'J': 11,
    'T': 10,
    '9': 9,
    '8': 8,
    '7': 7,
    '6': 6,
    '5': 5,
    '4': 4,
    '3': 3,
    '2': 2,
  };

  final cardValueJoker = {
    'A': 14,
    'K': 13,
    'Q': 12,
    'T': 10,
    '9': 9,
    '8': 8,
    '7': 7,
    '6': 6,
    '5': 5,
    '4': 4,
    '3': 3,
    '2': 2,
    'J': 1, // joker
  };
  // Jokertown  mappings from one group to another by the number of jokers
  //   1 -> 2 (1)
  //   2 -> 4 (1)  (2)
  //   3 -> 5 (1) / 6 (2)
  //   4 -> 6
  //   5 -> 6 (1) / 7 (2)
  //   6 -> 7

  final jokerPromotion = {
    '1:1J': 2, // single       - single
    '2:1J': 4, // 1 pair       - 3 of a kind
    '2:2J': 4, // 1 pair       - 3 of a kind
    '3:1J': 5, // 2 pair       - full house
    '3:2J': 6, // 2 pair       - 4 of a kind
    '4:1J': 6, // 3 of a kind  - 4 of a kind
    '4:3J': 6, // 3 of a kind  - 4 of a kind
    '5:2J': 7, // Full House   - 5 of a kind
    '5:3J': 7, // Full House   - 5 of a kind
    '6:1J': 7, // 4 of a kind  - 5 of a kind
    '6:4J': 7, // 4 of a kind  - 5 of a kind
    '7:5J': 7, // 5 of a kind  - 5 of a kind
  };

  int handTypeForMappedCards(
    Map<int, int> mappedCards, {
    bool jokersWild = false,
  }) {
    if (mappedCards.containsValue(5)) {
      // 5 of a kind
      return 7;
    } else if (mappedCards.containsValue(4)) {
      if (jokersWild && mappedCards.containsKey(11)) {
        // 5 of a kind no matter how many J cards
        return 7;
      } else {
        // 4 of a kind
        return 6;
      }
    } else if (mappedCards.containsValue(3) && mappedCards.containsValue(2)) {
      if (jokersWild && mappedCards.containsKey(11)) {
        // 5 of a kind no matter how many J cards
        return 7;
      } else {
        // full house
        return 5;
      }
    } else if (mappedCards.containsValue(3)) {
      if (jokersWild && mappedCards.containsKey(11)) {
        // 5 of a kind no matter how many J cards
        return 6;
      } else {
        // 3 of a kind
        return 4;
      }
    } else if (mappedCards.values.where((element) => element == 2).length ==
        2) {
      if (jokersWild && mappedCards.containsKey(11)) {
        if (mappedCards[11]! == 1) {
          // full house
          return 5;
        } else {
          // (mappedCards[11]! == 2) {
          // four of a kind
          return 6;
        }
      } else {
        // 2 pair
        return 3;
      }
    } else if (mappedCards.containsValue(2)) {
      if (jokersWild && mappedCards.containsKey(11)) {
        return 4;
      } else {
        // one pair
        return 2;
      }
    } else {
      if (jokersWild && mappedCards.containsKey(11)) {
        // pair
        return 2;
      } else {
        // individuals
        return 1;
      }
    }
  }

  @override
  List<String> parseInput() {
    final lines = input.getPerLine();
    return lines;
  }

  Iterable<Hand> buildHands(List<String> lines, {bool jokersWild = false}) {
    // convert each row to hands with list of cards and bid
    // cards are sorted highest to lowest
    final hands = lines.map((e) {
      final theCardsAndBid = e.split(' ');
      // original order
      final unsortedCards = theCardsAndBid[0]
          .split('')
          .map((e) => jokersWild ? cardValueJoker[e] : cardValue[e])
          .nonNulls
          .toList();
      // hight to low not actually needed if you read the problem
      final sortedCards = theCardsAndBid[0]
          .split('')
          .map((e) => cardValue[e])
          .nonNulls
          .sorted((a, b) => b.compareTo(a));
      // categorized, mapped to categories
      final mappedCards = sortedCards.fold<Map<int, int>>({}, (map, element) {
        map[element] = (map[element] ?? 0) + 1;
        return map;
      });
      return Hand(
        sortedCards: sortedCards,
        unsortedCards: unsortedCards,
        mappedCards: mappedCards,
        handType: handTypeForMappedCards(mappedCards, jokersWild: jokersWild),
        bid: int.parse(theCardsAndBid[1]),
        handWeight: unsortedCards[0] * 100000000 +
            unsortedCards[1] * 1000000 +
            unsortedCards[2] * 10000 +
            unsortedCards[3] * 100 +
            unsortedCards[4],
      );
    });
    return hands;
  }

  int scoreTheHands(Iterable<Hand> hands) {
    // sort by the hand weight and then by type because sorting
    // sorting is valid within a type only
    final groupedHandsByType = hands
        .sorted((a, b) => b.handType.compareTo(a.handType))
        .groupListsBy((element) => element.handType);
    final sortedHandsInType = groupedHandsByType.map(
      (key, value) => MapEntry(
        key,
        value.sorted((a, b) => b.handWeight.compareTo(a.handWeight)),
      ),
    );

    var rank = hands.length;

    final score = sortedHandsInType.entries
        .map(
          (entry) => entry.value.map((e) {
            print(
              '$rank - ${e.handType} - ${e.handWeight} - ${e.bid} - ${e.bid * rank} - ${e.sortedCards}',
            );
            final value = e.bid * rank;
            rank = rank - 1;
            return value;
          }).sum,
        )
        .sum;
    return score;
  }

  @override
  int solvePart1() {
    final lines = parseInput();
    final hands = buildHands(lines);

    final score = scoreTheHands(hands);
    return score;
  }

  @override
  int solvePart2() {
    final lines = parseInput();
    final hands = buildHands(lines, jokersWild: true);
    final score = scoreTheHands(hands);
    return score;
  }
}
