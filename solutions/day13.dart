// ignore_for_file: unnecessary_lambdas

import 'dart:math' as math;

import '../utils/index.dart';

class Day13 extends GenericDay {
  Day13() : super(13);

  @override
  List<PrizeAttempt> parseInput() {
    final paragraphs = InputUtil(13)
        .getParagraphLines()
        .map(
          (element) => PrizeAttempt.from(element),
        )
        .toList();
    //print('$paragraphs');
    return paragraphs;
  }

  @override
  int solvePart1() {
    final problemSets = parseInput();
    final costs = problemSets
        .map((e) {
          return solveOneProblem(e, 3, 1);
        })
        .where((value) => value != -1)
        .toList();

    print('examined ${costs.length} - $costs');
    return costs.sum;
  }

  @override
  int solvePart2() {
    return 0;
  }

  /// find the lowest cost for this one problem
  int solveOneProblem(PrizeAttempt anAttempt, int aCost, int bCost) {
    // find all the divisors of prize by button a
    // find all the divisors of prize by button b
    // find the intersection of a and b
    // calculate the cost

    var minCost = 0;
    final int maxACount = math.min(
      anAttempt.prize.x ~/ anAttempt.buttonA.x,
      anAttempt.prize.y ~/ anAttempt.buttonA.y,
    );
    final int maxBCount = math.min(
      anAttempt.prize.x ~/ anAttempt.buttonB.x,
      anAttempt.prize.y ~/ anAttempt.buttonB.y,
    );

    for (var aCount = 0; aCount <= maxACount; aCount++) {
      innerLoop:
      for (var bCount = 0; bCount <= maxBCount; bCount++) {
        //
        final anAttemptX =
            aCount * anAttempt.buttonA.x + bCount * anAttempt.buttonB.x;
        final anAttemptY =
            aCount * anAttempt.buttonA.y + bCount * anAttempt.buttonB.y;
        // print('for $anAttempt ($aCount, $bCount) '
        //     'resulted in $anAttemptX , $anAttemptY');
        if (anAttempt.prize.x < anAttemptX || anAttempt.prize.y < anAttemptY) {
          break innerLoop;
        }
        if (anAttempt.prize.x == anAttemptX &&
            anAttempt.prize.y == anAttemptY) {
          final newCost = aCount * aCost + bCount * bCost;
          print(
              'found $anAttempt cost $newCost  why(button A press count $aCount, '
              'button B press count $bCount) '
              'resulted in $anAttemptX , $anAttemptY');
          if (minCost == 0 || newCost < minCost) {
            minCost = newCost;
          }
        }
      }
    }
    // print('$minCost for $anAttempt');

    // return because can't be done
    return minCost;
  }
}

class PrizeAttempt {
  PrizeAttempt(this.buttonA, this.buttonB, this.prize);
  factory PrizeAttempt.from(List<String> problem) {
    return PrizeAttempt(
      Button.from(problem[0]),
      Button.from(problem[1]),
      Prize.from(problem[2]),
    );
  }

  final Button buttonA;
  final Button buttonB;
  final Prize prize;

  @override
  String toString() {
    return '{ "prize": $prize buttonA": $buttonA , "buttonB": $buttonB }';
  }
}

class Button {
  Button(this.x, this.y);
  factory Button.from(String statementString) {
    final splitted = statementString.split(' ');
    return Button(
      splitted[2].contains('+')
          ? int.parse(splitted[2].substring(2, splitted[2].length - 1))
          : int.parse(splitted[2].substring(1)),
      splitted[3].contains('+')
          ? int.parse(splitted[3].substring(2))
          : int.parse(splitted[3].substring(1)),
    );
  }
  final int x;
  final int y;

  @override
  String toString() {
    return '{ "x": $x , "y": $y}';
  }
}

class Prize {
  Prize(this.x, this.y);
  factory Prize.from(String prizeString) {
    final splitted = prizeString.split(' ');
    return Prize(
      int.parse(splitted[1].substring(2, splitted[1].length - 1)),
      int.parse(splitted[2].substring(2)),
    );
  }
  final int x;
  final int y;

  @override
  String toString() {
    return '{ "x": $x , "y": $y}';
  }
}
