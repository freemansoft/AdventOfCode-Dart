import '../utils/index.dart';

class Day03 extends GenericDay {
  Day03() : super(3);

  @override
  dynamic parseInput() {
    final input = InputUtil(3).getPerLine();
    return input;
  }

  @override
  int solvePart1() {
    var sumOfOperators = 0;
    final data = parseInput() as List<String>;
    for (var line in data) {
      // only supporting single operand type
      final clauses = line.split('mul');
      print(clauses);
      for (var aClause in clauses) {
        // the first right paren.  ignore the rest
        final endParen = aClause.indexOf(')');
        if (endParen > 0 && aClause.startsWith('(')) {
          final aClauseNoParen = aClause.substring(1, endParen);
          print('evaluate $aClause as ${aClauseNoParen}');
          try {
            final operands = aClauseNoParen.split(',').map(int.parse).toList();
            if (operands.length == 2) {
              final result = operands[0] * operands[1];
              sumOfOperators += result;
            }
          } catch (e) {
            print('bad math for $aClauseNoParen - $e');
          }
        } else {
          print('ignore $aClause');
        }
      }
    }
    return sumOfOperators;
  }

  @override
  int solvePart2() {
    return 0;
  }
}
