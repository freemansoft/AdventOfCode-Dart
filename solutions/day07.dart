// THIS DOES NOT WORK :-(
//
import '../utils/index.dart';

class Hand {
  Hand({
    required this.cards,
    required this.bid,
    required this.mappedCards,
    required this.handType,
    required this.handWeight,
  });

  final List<int> cards;
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

  int handTypeForMappedCards(Map<int, int> mappedCards) {
    if (mappedCards.containsValue(5)) {
      // 5 of a kind
      return 7;
    } else if (mappedCards.containsValue(4)) {
      // 4 of a kind
      return 6;
    } else if (mappedCards.containsValue(3) && mappedCards.containsValue(2)) {
      // full house
      return 5;
    } else if (mappedCards.containsValue(3)) {
      // 3 of a kind
      return 4;
    } else if (mappedCards.values.where((element) => element == 2).length ==
        2) {
      // 2 pair
      return 3;
    } else if (mappedCards.containsValue(2)) {
      // one pair
      return 2;
    } else {
      // individuals
      return 1;
    }
  }

  @override
  Iterable<Hand> parseInput() {
    final lines = input.getPerLine();
    // convert each row to hands with list of cards and bid
    // cards are sorted highest to lowest
    final hands = lines.map((e) {
      final theCardsAndBid = e.split(' ');
      final sortedCards = theCardsAndBid[0]
          .split('')
          .map((e) => cardValue[e])
          .nonNulls
          .sorted((a, b) => b.compareTo(a));
      final mappedCards = sortedCards.fold<Map<int, int>>({}, (map, element) {
        map[element] = (map[element] ?? 0) + 1;
        return map;
      });
      return Hand(
          cards: sortedCards,
          mappedCards: mappedCards,
          handType: handTypeForMappedCards(mappedCards),
          bid: int.parse(theCardsAndBid[1]),
          handWeight: sortedCards[0] * 100000000 +
              sortedCards[1] * 1000000 +
              sortedCards[2] * 10000 +
              sortedCards[3] * 100 +
              sortedCards[4]);
    });
    return hands;
  }

  @override
  int solvePart1() {
    final hands = parseInput();
    // sort by the hand weight and then by type because sorting
    // sorting is valid within a type only
    final sortedHandsByType = hands
        .sorted((a, b) => b.handType.compareTo(a.handType))
        .groupListsBy((element) => element.handType);
    final sortedHandsInType = sortedHandsByType.map(
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
                '$rank - ${e.handType} - ${e.handWeight} - ${e.bid} - ${e.bid * rank} - ${e.cards}');
            final value = e.bid * rank;
            rank = rank - 1;
            return value;
          }).sum,
        )
        .sum;
    return score;
  }

  @override
  int solvePart2() {
    return 0;
  }
}
