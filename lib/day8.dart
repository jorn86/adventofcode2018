import 'dart:io';

import 'package:adventofcode2018/util.dart' as util;

var regex = RegExp(r"\d+");
void main() {
  var numbers = regex.allMatches(File('./lib/day8.txt').readAsStringSync()).iterator;
  var root = parseNode(numbers);
  if (numbers.moveNext()) throw 'input not empty';
  print(sum(root));
  print(value(root));
}

int value(Node root) {
  if (root.children.isEmpty) {
    return util.sum(root.metadata);
  }
  var result = 0;
  for (var m in root.metadata) {
    var index = m - 1;
    if (index >= 0 && index < root.children.length) {
      result += value(root.children[index]);
    }
  }
  return result;
}

int sum(Node root) {
  var result = util.sum(root.metadata);
  for (var value in root.children) {
    result += sum(value);
  }
  return result;
}

Node parseNode(Iterator<Match> numbers) {
  var node = Node();
  var children = next(numbers);
  var meta = next(numbers);
  for (int i = 0; i < children; i++) {
    node.children.add(parseNode(numbers));
  }
  for (int i = 0; i < meta; i++) {
    node.metadata.add(next(numbers));
  }
  return node;
}

int next(Iterator<Match> numbers) {
  if (!numbers.moveNext()) throw 'input empty';
  return util.matchInt(numbers.current);
}

class Node {
  List<int> metadata = <int>[];
  List<Node> children = <Node>[];
}
