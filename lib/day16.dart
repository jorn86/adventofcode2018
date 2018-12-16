import 'package:adventofcode2018/util.dart';
import 'dart:io';

final regex = RegExp(r'(\d+), (\d), (\d), (\d)');
final operationRegex = RegExp(r'(\d+) (\d) (\d) (\d)');

List<int> registers;

void main() {
  var input = File('./lib/day16.part1.txt').readAsLinesSync().iterator;
  var operations = [addr(), addi(), mulr(), muli(), banr(), bani(), borr(), bori(), setr(), seti(), gtri(), gtir(), gtrr(), eqir(), eqri(), eqrr()];
  var result = 0;
  while (input.moveNext()) {
    registers = parseLine(input, regex); input.moveNext();
    var operation = parseLine(input, operationRegex); input.moveNext();
    var after = parseLine(input, regex); input.moveNext();
    var matches = 0;
    for (var opcode in operations) {
      if (after[operation[3]] == opcode.apply(operation[1], operation[2])) {
        opcode.possibleNumbers.add(operation[0]);
        matches++;
      }
    }
    if (matches >= 3) result++;
  }
  print(result); // part 1

  while (!operations.map((o) => o.possibleNumbers.length <= 1).reduce((a,b) => a && b)) {
    for (var opcode in operations) {
      if (opcode.possibleNumbers.length == 1) {
        for (var toremove in operations) {
          if (toremove == opcode) continue;
          toremove.possibleNumbers.remove(opcode.resolvedNumber);
        }
      }
    }
  }

  var map = Map.fromIterable(operations, key: (o) => o.resolvedNumber);
  registers = List.filled(4, 0);
  input = File('./lib/day16.part2.txt').readAsLinesSync().iterator;
  while (input.moveNext()) {
    var operation = parseLine(input, operationRegex);
    registers[operation[3]] = map[operation[0]].apply(operation[1], operation[2]);
  }
  print(registers);
}

parseLine(Iterator<String> input, RegExp regExp) {
  var match = regExp.firstMatch(input.current);
  return [matchInt(match, group: 1), matchInt(match, group: 2), matchInt(match, group: 3), matchInt(match, group: 4)];
}

abstract class OpCode {
  final possibleNumbers = Set();
  int get resolvedNumber => possibleNumbers.length == 1 ? possibleNumbers.first : throw possibleNumbers;
  int apply(int a, int b);
  @override String toString() => '$runtimeType';
}
class addr extends OpCode {
  @override int apply(int a, int b) => registers[a] + registers[b];
}
class addi extends OpCode {
  @override int apply(int a, int b) => registers[a] + b;
}
class mulr extends OpCode {
  @override int apply(int a, int b) => registers[a] * registers[b];
}
class muli extends OpCode {
  @override int apply(int a, int b) => registers[a] * b;
}
class banr extends OpCode {
  @override int apply(int a, int b) => registers[a] & registers[b];
}
class bani extends OpCode {
  @override int apply(int a, int b) => registers[a] & b;
}
class borr extends OpCode {
  @override int apply(int a, int b) => registers[a] | registers[b];
}
class bori extends OpCode {
  @override int apply(int a, int b) => registers[a] | b;
}
class setr extends OpCode {
  @override int apply(int a, int b) => registers[a];
}
class seti extends OpCode {
  @override int apply(int a, int b) => a;
}
class gtir extends OpCode {
  @override int apply(int a, int b) => a > registers[b] ? 1 : 0;
}
class gtri extends OpCode {
  @override int apply(int a, int b) => registers[a] > b ? 1 : 0;
}
class gtrr extends OpCode {
  @override int apply(int a, int b) => registers[a] > registers[b] ? 1 : 0;
}
class eqir extends OpCode {
  @override int apply(int a, int b) => a == registers[b] ? 1 : 0;
}
class eqri extends OpCode {
  @override int apply(int a, int b) => registers[a] == b ? 1 : 0;
}
class eqrr extends OpCode {
  @override int apply(int a, int b) => registers[a] == registers[b] ? 1 : 0;
}
