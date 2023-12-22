import 'package:meta/meta.dart';

import '../utils/coordinate.dart';
import '../utils/index.dart';

// we want the original character
String keyToKey(String key) => key;

StepCoordinate findTheStart(Field<String> playingField) {
  for (var row = 0; row < playingField.height; row++) {
    for (var col = 0; col < playingField.width; col++) {
      if (playingField.getValueAt(x: col, y: row) == 'S') {
        return StepCoordinate(
            step: 0, location: Coordinate(row: row, col: col));
      }
    }
  }
  throw Exception('could not find the start position');
}

class Day21 extends GenericDay {
  Day21() : super(21);

  @override
  Field<String> parseInput() {
    final cells = input.perLineToCells(input.getPerLine(), '', keyToKey);
    final cellsAsFields = Field<String>(cells);
    return cellsAsFields;
  }

  @override
  int solvePart1() {
    final playingField = parseInput();
    final numCompletedTasks = solveOne(
      64,
      findTheStart(playingField),
      playingField,
    );
    return numCompletedTasks;
  }

  @override
  int solvePart2() {
    return 0;
  }

  // converted from recursive to iterative
  void executeTasks({
    required int maxDepth,
    required Set<StepCoordinate> openTasks,
    required Set<StepCoordinate> completedTasks,
    required Field<String> onField,
  }) {
    while (openTasks.isNotEmpty) {
      // .first is breadth first  .last is depth first
      // can use .first to prune earlier steps
      final currentTask = openTasks.first;
      openTasks.remove(currentTask);
      completedTasks.add(currentTask);
      if (currentTask.step < maxDepth) {
        // print(
        //     'executing: $currentTask openTask: ${openTasks.length} completedTasks: ${completedTasks.length}');
        // filter out the off board later
        final motion = [
          StepCoordinate(
            step: currentTask.step + 1,
            location: Coordinate(
              row: currentTask.location.row - 1,
              col: currentTask.location.col,
            ),
          ),
          StepCoordinate(
              step: currentTask.step + 1,
              location: Coordinate(
                row: currentTask.location.row + 1,
                col: currentTask.location.col,
              )),
          StepCoordinate(
              step: currentTask.step + 1,
              location: Coordinate(
                row: currentTask.location.row,
                col: currentTask.location.col - 1,
              )),
          StepCoordinate(
              step: currentTask.step + 1,
              location: Coordinate(
                row: currentTask.location.row,
                col: currentTask.location.col + 1,
              )),
        ];

        for (final oneCoord in motion) {
          if (oneCoord.location.row >= 0 &&
              oneCoord.location.row < onField.height &&
              oneCoord.location.col >= 0 &&
              oneCoord.location.col < onField.width &&
              onField.getValueAt(
                    x: oneCoord.location.col,
                    y: oneCoord.location.row,
                  ) !=
                  '#' &&
              !openTasks.contains(oneCoord) &&
              !completedTasks.contains(oneCoord)) {
            // print(
            //     'adding: $oneCoord openTask: ${openTasks.length} completedTasks: ${completedTasks.length}');
            openTasks.add(oneCoord);
          } else {
            // print(
            //     'ignoring: $oneCoord openTask: ${openTasks.length} completedTasks: ${completedTasks.length}');
          }
        }
      }
    }
  }

  int solveOne(
      int maxDepth, StepCoordinate findTheStart, Field<String> playingField) {
    // scheduled movements that have not yet all been consumed
    final openTasks = <StepCoordinate>{};
    // consumed used to do branch pruning and exit
    final completedTasks = <StepCoordinate>{};
    // ignore: cascade_invocations
    openTasks.add(findTheStart);
    executeTasks(
      maxDepth: maxDepth,
      openTasks: openTasks,
      completedTasks: completedTasks,
      onField: playingField,
    );
    print('evaulated ${completedTasks.length}');
    return completedTasks.fold(
        0,
        (previousValue, element) =>
            element.step == maxDepth ? previousValue + 1 : previousValue);
  }
}
