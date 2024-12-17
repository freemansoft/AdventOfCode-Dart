import 'dart:math';

import '../utils/index.dart';

class Day17 extends GenericDay {
  Day17() : super(17);

  @override
  parseInput() {
    final fullProgram = InputUtil(17).getParagraphLines();
    final registerAString = fullProgram[0][0].split(':')[1].substring(1);
    registers[0] = int.parse(registerAString);
    final registerBString = fullProgram[0][1].split(':')[1].substring(1);
    registers[1] = int.parse(registerBString);
    final registerCString = fullProgram[0][2].split(':')[1].substring(1);
    registers[2] = int.parse(registerCString);
    program = ProgramStep.from(fullProgram[1][0].split(':')[1].substring(1));
  }

  //registers a, b, c
  final registers = [0, 0, 0];

  List<ProgramStep> program = <ProgramStep>[];

  @override
  int solvePart1() {
    parseInput();
    var addressPointer = 0;
    final outputBuffer = <int>[];
    print('program: $program');
    while (addressPointer <= program.last.address) {
      addressPointer = program
          .where((element) => element.address == addressPointer)
          .first
          .executeStep(registers, outputBuffer);
      print('    resulted in $registers '
          '${registers.map((e) => e.toRadixString(8)).toList()} - '
          'output $outputBuffer');
    }
    print(outputBuffer);
    // this is the answer , first non number answer
    print(
      outputBuffer.toString().replaceAll(' ', '')
        ..replaceAll('[', '').replaceAll(']', ''),
    );
    return 0;
  }

  @override
  int solvePart2() {
    return 0;
  }
}

class ProgramStep {
  const ProgramStep(this.address, this.operator, this.operand);
  final int address;
  final int operator;
  final int operand;

  static int registerAIndex = 0;
  static int registerBIndex = 1;
  static int registerCIndex = 2;

  static List<ProgramStep> from(String inputString) {
    final programSteps = <ProgramStep>[];
    final parts = inputString.split(',');
    for (var i = 0; i < parts.length; i = i + 2) {
      final operator = int.parse(parts[i]);
      final operand = int.parse(parts[i + 1]);
      programSteps.add(ProgramStep(i, operator, operand));
    }
    return programSteps;
  }

  int executeStep(List<int> registers, List<int> outputBuffer) {
    print('Executing ${operatorDescription()} $this with '
        'registers $registers '
        'registers ${registers.map((e) => e.toRadixString(8)).toList()}');
    switch (operator) {
      case 0: // adv division   registerA~/2^combOperand
        final divisor = pow(2, evalComboOperand(registers, operand)).toInt();
        registers[registerAIndex] = registers[registerAIndex] ~/ divisor;
        return address + 2;
      case 1: // bxl bitwise XOR (registerB, operand)
        registers[registerBIndex] = registers[registerBIndex] ^ operand;
        return address + 2;
      case 2: // bst operand modulo 8
        registers[registerBIndex] = evalComboOperand(registers, operand) % 8;
        return address + 2;
      case 3: // jnz (jump no zero)  if A is 0 then +2 else operand
        if (registers[registerAIndex] != 0) {
          return operand;
        } else {
          return address + 2;
        }
      case 4: // bxc  bitwise XOR ( reg b, reg c)
        registers[registerBIndex] =
            registers[registerBIndex] ^ registers[registerCIndex];
        return address + 2;
      case 5: // out operand modulo 8
        outputBuffer.add(evalComboOperand(registers, operand) % 8);
        return address + 2;
      case 6: // BDV integer division on register A is stored in B
        final divisor = pow(2, evalComboOperand(registers, operand)).toInt();
        registers[registerBIndex] = registers[registerAIndex] ~/ divisor;
        return address + 2;
      case 7: // CDV
        final divisor = pow(2, evalComboOperand(registers, operand)).toInt();
        registers[registerCIndex] = registers[registerAIndex] ~/ divisor;
        return address + 2;
      default:
        print('invalid instruction code $operator,$operand');
        return address + 2;
    }
  }

  String operatorDescription() {
    switch (operator) {
      case 0:
        return 'adv';
      case 1:
        return 'bxl';
      case 2:
        return 'bst';
      case 3:
        return 'jnz';
      case 4:
        return 'bxc';
      case 5:
        return 'out';
      case 6:
        return 'bdv';
      case 7:
        return 'cdv';
      default:
        return 'xxx';
    }
  }

  int evalComboOperand(List<int> registers, int operand) {
    return (operand < 4) ? operand : registers[operand - 4];
  }

  @override
  String toString() {
    return '{ address : $address, operator: $operator, operand: $operand }';
  }
}
