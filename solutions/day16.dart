import 'dart:core';

import 'package:meta/meta.dart';

import '../utils/coordinate.dart';
import '../utils/index.dart';

/// A definition of the relative exit paths for all of the possible entry paths.
@immutable
class TransitionDef {
  const TransitionDef({
    required this.type,
    required this.from,
    required this.to,
  });
  // used for tracking and logging
  final TransitionType type;
  // the relative location of the entry into the square
  final OffsetCoord from;
  // the relative exit directions - a given entry can have multiple exiting
  final List<OffsetCoord> to;

  @override
  String toString() {
    return '{"from": $from , "to": $to}';
  }
}

class SquarefTransitionDefs {
  const SquarefTransitionDefs({required this.symbol, required this.allDefs});
  final String symbol;
  final List<TransitionDef> allDefs;

  @override
  String toString() {
    return '"$symbol" $allDefs';
  }
}

/// Primarily for debugging
enum TransitionType {
  transparent,
  bendWNandES,
  bendWSandEN,
  passWEsplitNS,
  passNSsplitWE,
}

Map<String, SquarefTransitionDefs> charTransitionMap = {
  '/': const SquarefTransitionDefs(
    symbol: '/',
    allDefs: [
      TransitionDef(
        type: TransitionType.bendWNandES,
        from: OffsetCoord(row: 0, col: -1),
        to: [OffsetCoord(row: -1, col: 0)],
      ),
      TransitionDef(
        type: TransitionType.bendWNandES,
        from: OffsetCoord(row: 0, col: 1),
        to: [OffsetCoord(row: 1, col: 0)],
      ),
      TransitionDef(
        type: TransitionType.bendWNandES,
        from: OffsetCoord(row: -1, col: 0),
        to: [OffsetCoord(row: 0, col: -1)],
      ),
      TransitionDef(
        type: TransitionType.bendWNandES,
        from: OffsetCoord(row: 1, col: 0),
        to: [OffsetCoord(row: 0, col: 1)],
      ),
    ],
  ),
  r'\': const SquarefTransitionDefs(
    symbol: r'\',
    allDefs: [
      TransitionDef(
        type: TransitionType.bendWSandEN,
        from: OffsetCoord(row: 0, col: -1),
        to: [OffsetCoord(row: 1, col: 0)],
      ),
      TransitionDef(
        type: TransitionType.bendWSandEN,
        from: OffsetCoord(row: 0, col: 1),
        to: [OffsetCoord(row: -1, col: 0)],
      ),
      TransitionDef(
        type: TransitionType.bendWSandEN,
        from: OffsetCoord(row: -1, col: 0),
        to: [OffsetCoord(row: 0, col: 1)],
      ),
      TransitionDef(
        type: TransitionType.bendWSandEN,
        from: OffsetCoord(row: 1, col: 0),
        to: [OffsetCoord(row: 0, col: -1)],
      ),
    ],
  ),
  '|': const SquarefTransitionDefs(
    symbol: '|',
    allDefs: [
      TransitionDef(
        type: TransitionType.passNSsplitWE,
        from: OffsetCoord(row: 0, col: -1),
        to: [OffsetCoord(row: 1, col: 0), OffsetCoord(row: -1, col: 0)],
      ),
      TransitionDef(
        type: TransitionType.passNSsplitWE,
        from: OffsetCoord(row: 0, col: 1),
        to: [OffsetCoord(row: 1, col: 0), OffsetCoord(row: -1, col: 0)],
      ),
      TransitionDef(
        type: TransitionType.passNSsplitWE,
        from: OffsetCoord(row: -1, col: 0),
        to: [OffsetCoord(row: 1, col: 0)],
      ),
      TransitionDef(
        type: TransitionType.passNSsplitWE,
        from: OffsetCoord(row: 1, col: 0),
        to: [OffsetCoord(row: -1, col: 0)],
      ),
    ],
  ),
  '-': const SquarefTransitionDefs(
    symbol: '-',
    allDefs: [
      TransitionDef(
        type: TransitionType.passWEsplitNS,
        from: OffsetCoord(row: 0, col: -1),
        to: [OffsetCoord(row: 0, col: 1)],
      ),
      TransitionDef(
        type: TransitionType.passWEsplitNS,
        from: OffsetCoord(row: 0, col: 1),
        to: [OffsetCoord(row: 0, col: -1)],
      ),
      TransitionDef(
        type: TransitionType.passWEsplitNS,
        from: OffsetCoord(row: -1, col: 0),
        to: [OffsetCoord(row: 0, col: -1), OffsetCoord(row: 0, col: 1)],
      ),
      TransitionDef(
        type: TransitionType.passWEsplitNS,
        from: OffsetCoord(row: 1, col: 0),
        to: [OffsetCoord(row: 0, col: -1), OffsetCoord(row: 0, col: 1)],
      ),
    ],
  ),
  '.': const SquarefTransitionDefs(
    symbol: '.',
    allDefs: [
      TransitionDef(
        type: TransitionType.transparent,
        from: OffsetCoord(row: 0, col: -1),
        to: [OffsetCoord(row: 0, col: 1)],
      ),
      TransitionDef(
        type: TransitionType.transparent,
        from: OffsetCoord(row: 0, col: 1),
        to: [OffsetCoord(row: 0, col: -1)],
      ),
      TransitionDef(
        type: TransitionType.transparent,
        from: OffsetCoord(row: -1, col: 0),
        to: [OffsetCoord(row: 1, col: 0)],
      ),
      TransitionDef(
        type: TransitionType.transparent,
        from: OffsetCoord(row: 1, col: 0),
        to: [OffsetCoord(row: -1, col: 0)],
      ),
    ],
  ),
};

class Day16 extends GenericDay {
  Day16() : super(16);

  @override
  Field<SquarefTransitionDefs> parseInput() {
    final cells = input
        .getPerLine()
        .map((e) => e.split(''))
        .map(
          (e) => e
              .map(
                (f) => charTransitionMap[f]!,
              )
              .toList(),
        ) // List<List<TransitionDef>> One Row
        .toList();
    final cellsAsFields = Field<SquarefTransitionDefs>(cells);
    return cellsAsFields;
  }

  @override
  int solvePart1() {
    final playingField = parseInput();

    var litCount = solveOne(
      const Transition(
        from: OffsetCoord(row: 0, col: -1),
        to: Coordinate(row: 0, col: 0),
      ),
      playingField,
    );
    return litCount;
  }

  @override
  int solvePart2() {
    final playingField = parseInput();

    var foo = <int>[];

    // ignore: cascade_invocations
    foo.addAll(
      Iterable.generate(
        playingField.height,
        (e) => solveOne(
          Transition(
            from: const OffsetCoord(
              row: 0,
              col: -1,
            ),
            to: Coordinate(row: e, col: 0),
          ),
          playingField,
        ),
      ),
    );

    // ignore: cascade_invocations
    foo.addAll(
      Iterable.generate(
        playingField.height,
        (e) => solveOne(
          Transition(
            from: const OffsetCoord(
              row: 0,
              col: 1,
            ),
            to: Coordinate(row: e, col: playingField.width - 1),
          ),
          playingField,
        ),
      ),
    );

    // ignore: cascade_invocations
    foo.addAll(
      Iterable.generate(
        playingField.width,
        (e) => solveOne(
          Transition(
            from: const OffsetCoord(
              row: 1,
              col: 0,
            ),
            to: Coordinate(row: playingField.height - 1, col: e),
          ),
          playingField,
        ),
      ),
    );

    // ignore: cascade_invocations
    foo.addAll(
      Iterable.generate(
        playingField.width,
        (e) => solveOne(
          Transition(
            from: const OffsetCoord(
              row: -1,
              col: 0,
            ),
            to: Coordinate(row: 0, col: e),
          ),
          playingField,
        ),
      ),
    );

    print(foo);

    return foo.reduce((value, element) => (value < element) ? element : value);
  }

  // first to last
  void executeTasks({
    required List<Transition> openTasks,
    required List<Transition> completedTasks,
    required Field<SquarefTransitionDefs> onField,
  }) {
    while (openTasks.isNotEmpty) {
      final currentTask = openTasks.last;
      openTasks.removeLast();
      // from is relative and to is absolute
      //print('executeTasks - currentTask: $currentTask');
      final cellDefTargetCell =
          onField.getValueAt(x: currentTask.to.col, y: currentTask.to.row);
      // print('executeTasks - row: ${currentTask.to.row} col: ${currentTask.to.col}'
      //     ' cellDef: $cellDefTargetCell');

      // Look for the cellTarget def that aligns with this entry
      for (final oneDef in cellDefTargetCell.allDefs) {
        // only one really maps to this operation
        if (oneDef.from == currentTask.from) {
          // mark this completed before it is so the recursion doesn't repeat it
          completedTasks.add(currentTask);
          // add all the possible exit paths
          //print('------------> ${oneDef.to.length}');
          for (final oneExit in oneDef.to) {
            final target = Coordinate(
              row: currentTask.to.row + oneExit.row,
              col: currentTask.to.col + oneExit.col,
            );
            final nextTransition = Transition(
              from: oneExit.invert,
              to: target,
            );
            if (target.row >= 0 &&
                target.row < onField.height &&
                target.col >= 0 &&
                target.col < onField.width &&
                !openTasks.contains(nextTransition) &&
                !completedTasks.contains(nextTransition)) {
              openTasks.add(
                nextTransition,
              );
              // print('executeTasks - open ${openTasks.length} '
              //     '- completed ${completedTasks.length} '
              //     '- added ${openTasks.last} ');
            } else {
              // print('ignoring:$nextTransition');
            }
          }
        }
      }
    }
  }

  int solveOne(
    Transition transition,
    Field<SquarefTransitionDefs> playingField,
  ) {
    // scheduled movements that have not yet all been consumed
    final openTasks = <Transition>[];
    // consumed used to do branch pruning and exit
    final completedTasks = <Transition>[];
    // ignore: cascade_invocations
    openTasks.add(transition);
    executeTasks(
      openTasks: openTasks,
      completedTasks: completedTasks,
      onField: playingField,
    );

    final litSquares = completedTasks.map((e) => e.to).toSet();

    print('solve1 - open ${openTasks.length} '
        '- completed ${completedTasks.length} '
        '- lit ${litSquares.length}');

    return litSquares.length;
  }
}
