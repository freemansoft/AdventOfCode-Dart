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
