import 'package:meta/meta.dart';

@immutable
class Coordinate {
  const Coordinate({required this.row, required this.col});
  final int row;
  final int col;

  @override
  bool operator ==(Object other) =>
      other is Coordinate &&
      other.runtimeType == runtimeType &&
      other.row == row &&
      other.col == col;

  @override
  int get hashCode => 'row:$row,col:$col'.hashCode;

  @override
  String toString() {
    return '{ "row": $row , "col": $col}';
  }
}

/// Relative coordinate - when you want to _force_ it
class OffsetCoord extends Coordinate {
  const OffsetCoord({required super.row, required super.col});

  /// what the offset looks like to the reciever of the offset
  /// Only works because no diagonals
  OffsetCoord get invert => OffsetCoord(row: row * -1, col: col * -1);
}

/// defines a transition into or out of a square
@immutable
class Transition {
  const Transition({required this.from, required this.to});
  // relative or absolute originating square
  final OffsetCoord from;
  // absolute current square
  final Coordinate to;

  @override
  bool operator ==(Object other) =>
      other is Transition &&
      other.runtimeType == runtimeType &&
      other.from == from &&
      other.to == to;

  @override
  int get hashCode => 'from:$from,to:$to'.hashCode;

  @override
  String toString() {
    return '{ "from": $from , "to": $to}';
  }
}

/// an entry path and the relative exit paths for that entry
///
/// @param type used for debugging.
/// @param from the entry vector
/// @param to a list of possible exits
///
@immutable
class TransitionDef {
  const TransitionDef({
    required this.type,
    required this.from,
    required this.to,
  });
  // used for tracking and logging
  final String type;
  // the relative location of the entry into the square
  final OffsetCoord from;
  // the relative exit directions - a given entry can have multiple exiting
  final List<OffsetCoord> to;

  @override
  String toString() {
    return '{"from": $from , "to": $to}';
  }
}

/// Holds all the entry paths for a single square and the exits for each
class SquarefTransitionDefs {
  const SquarefTransitionDefs({required this.symbol, required this.allDefs});
  final String symbol;
  final List<TransitionDef> allDefs;

  @override
  String toString() {
    return '"$symbol" $allDefs';
  }
}
