import 'dart:io';

import 'package:adventofcode2018/util.dart' as util;

var steps = 1000000000;

void main() {
  var lines = File('./lib/day18.txt').readAsLinesSync();
  var initial = util.grid<Tile>(lines.length, lines[0].length, null);
  for (int x = 0; x < lines.length; x++) {
    for (var y = 0; y < lines[x].length; y++) {
      switch (lines[x].codeUnitAt(y)) {
        case 35:  initial[x][y] = Tile.lumber; break;
        case 46:  initial[x][y] = Tile.open; break;
        case 124: initial[x][y] = Tile.trees; break;
        default: throw '$x,$y: ${String.fromCharCode(lines[x].codeUnitAt(y))}';
      }
    }
  }

  var states = <List<List<Tile>>>[];
  var current = initial;
  for (int i = 0; i < steps; i++) {
    if (i == 10) {
      var trees = count(current, Tile.trees);
      var lumber = count(current, Tile.lumber);
      print('$trees * $lumber = ${trees*lumber}'); // part 1
    }

    current = step(current);

    var index = states.indexWhere((state) => sameState(current, state));
    if (index >= 0) {
      var diff = i - index;
      var finalStep = states[i - (steps % diff)];
      var trees = count(finalStep, Tile.trees);
      var lumber = count(finalStep, Tile.lumber);
      print('$trees * $lumber = ${trees*lumber}'); // part 2
      return;
    }
    states.add(current);
  }
}

bool sameState(List<List<Tile>> current, List<List<Tile>> state) {
  for (int x = 0; x < current.length; x++) {
    for (int y = 0; y < current[x].length; y++) {
      if (current[x][y] != state[x][y]) return false;
    }
  }
  return true;
}

void printGrid(List<List<Tile>> current) {
  print(current.map((line) => line.map((tile) {
    switch(tile) {
      case Tile.open: return '.';
      case Tile.trees: return '|';
      case Tile.lumber: return '#';
      default: throw '$tile from $line in $current';
    }
  }).join('')).join('\n'));
  print('');
}

List<List<Tile>> step(List<List<Tile>> current) {
  var next = util.grid<Tile>(current.length, current[0].length, null);
  for (int x = 0; x < current.length; x++) {
    for (int y = 0; y < current[x].length; y++) {
      switch (current[x][y]) {
        case Tile.open: next[x][y] = countAdjacent(current, x, y, Tile.trees) >= 3 ? Tile.trees : Tile.open; break;
        case Tile.trees: next[x][y] = countAdjacent(current, x, y, Tile.lumber) >= 3 ? Tile.lumber : Tile.trees; break;
        case Tile.lumber: next[x][y] = countAdjacent(current, x, y, Tile.lumber) >= 1 && countAdjacent(current, x, y, Tile.trees) >= 1
            ? Tile.lumber : Tile.open; break;
        default: throw '${current[x][y]} at $x, $y';
      }
    }
  }
  return next;
}

int countAdjacent(List<List<Tile>> current, int x, int y, Tile tile) =>
    eq(current, x-1, y-1, tile) +
    eq(current, x-1, y, tile) +
    eq(current, x-1, y+1, tile) +
    eq(current, x, y-1, tile) +
    eq(current, x, y+1, tile) +
    eq(current, x+1, y-1, tile) +
    eq(current, x+1, y, tile) +
    eq(current, x+1, y+1, tile);

int eq(List<List<Tile>> current, int x, int y, Tile tile) =>
    !(x < 0 || y < 0 || x >= current.length || y >= current[x].length) && current[x][y] == tile ? 1 : 0;

int count(List<List<Tile>> current, Tile tile) =>
    util.sum(current.map((line) => util.sum(line.map((t) => t == tile ? 1 : 0))));

enum Tile {
  open, trees, lumber
}
