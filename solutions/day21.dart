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
      final currentTask = openTasks.last;
      openTasks.remove(currentTask);
      completedTasks.add(currentTask);
      if (currentTask.step < maxDepth) {
        // print(
        //     'executing: $currentTask openTask: ${openTasks.length} completedTasks: ${completedTasks.length}');
        final motion = [
          StepCoordinate(
            step: currentTask.step + 1,
            location: Coordinate(
              row: max<int>([currentTask.location.row - 1, 0]) ?? -100,
              col: currentTask.location.col,
            ),
          ),
          StepCoordinate(
              step: currentTask.step + 1,
              location: Coordinate(
                row: min<int>(
                        [currentTask.location.row + 1, onField.height - 1]) ??
                    -100,
                col: currentTask.location.col,
              )),
          StepCoordinate(
              step: currentTask.step + 1,
              location: Coordinate(
                row: currentTask.location.row,
                col: max<int>([0, currentTask.location.col - 1]) ?? -100,
              )),
          StepCoordinate(
              step: currentTask.step + 1,
              location: Coordinate(
                row: currentTask.location.row,
                col: min<int>(
                        [currentTask.location.col + 1, onField.width - 1]) ??
                    -100,
              )),
        ];

        for (final oneCoord in motion) {
          if (onField.getValueAt(
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
    print('$completedTasks');
    return completedTasks.fold(
        0,
        (previousValue, element) =>
            element.step == maxDepth ? previousValue + 1 : previousValue);
  }
}

@immutable
class StepCoordinate {
  const StepCoordinate({required this.step, required this.location});

  final int step;
  final Coordinate location;

  @override
  bool operator ==(Object other) =>
      other is StepCoordinate &&
      other.runtimeType == runtimeType &&
      other.location.row == location.row &&
      other.location.col == location.col &&
      other.step == step;

  @override
  int get hashCode =>
      'step:$step row:${location.row},col:${location.col}'.hashCode;

  @override
  String toString() {
    return '{ "step": $step, "row": ${location.row} , "col": ${location.col}}';
  }
}
