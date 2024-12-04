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
    print('*********** part 1 **************');
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
    print('*********** part 2 **************');
    var sumOfOperators = 0;
    final data = parseInput() as List<String>;
    print('starting with $data');

    // isActive spans lines
    var isActive = true;
    for (final line in data) {
      // regex the heck out of this
      final mulRegExp = RegExp(r"(don\'t\(\))|(do\(\))|mul\(\d+,\d+\)");

      // all the matches
      final match = mulRegExp.allMatches(line).toList();
      //print('$match');

      // split the matches into elements of a list
      final macroTokens = match.map((e) => e[0]!).toList();
      print('$macroTokens');

      for (final token in macroTokens) {
        if (token == "don't()") {
          isActive = false;
          print(token);
        } else if (token == 'do()') {
          isActive = true;
          print(token);
        } else if (token.startsWith('mul')) {
          if (isActive) {
            print('calculating $token');
            final operands = token
                .substring(4, token.length - 1)
                .split(',')
                .map(int.parse)
                .toList();
            if (operands.length == 2) {
              final result = operands[0] * operands[1];
              print('operands: $operands adding $result to $sumOfOperators');
              sumOfOperators += result;
              print('operands: $operands resulting in $sumOfOperators');
            } else {
              print('bad operands $operands staying at $sumOfOperators');
            }
          } else {
            // shouldn't happen
            print('ignoring $token');
          }
        }
      }
    }
    // 92082041
    return sumOfOperators;
  }
}
