import 'dart:io';

import 'package:adventofcode2018/util.dart' as util;

void main() {
  var carts = <Cart>[];
  var grid = _init(carts);
  int i = 0;
  while (step(carts, grid)) print(i++);
}

bool step(List<Cart> carts, List<List<Node>> grid) {
  carts.sort();
  for (var cart in carts) {
    cart.move(grid);
    if (collision(carts)) return false;
  }
  return true;
}

bool collision(List<Cart> carts) {
  for (int i = 0; i < carts.length; i++) {
    var cart = carts[i];
    for (int j = i+1; j < carts.length; j++) {
      if (cart.x == carts[j].x && cart.y == carts[j].y) {
        print('X at ${cart.y},${cart.x}');
        return true;
      }
    }
  }
  return false;
}

List<List<Node>> _init(List<Cart> carts) {
  var lines = File('./lib/day13.example.txt').readAsLinesSync();
  var grid = util.grid<Node>(lines.length, lines.map((l) => l.length).reduce((a,b) => a > b ? a : b), Empty());
  for (int y = 0; y < lines.length; y++) {
    var chars = lines[y].codeUnits;
    for (int x = 0; x < chars.length; x++) {
      String code = String.fromCharCode(chars[x]);
      switch(chars[x]) {
        case 32: break;
        case 43: // +
          grid[y][x] = Intersection(); break;
        case 45: // -
          grid[y][x] = StraightTrack('-'); break;
        case 47: // /
          grid[y][x] = CornerTrackForward(); break;
        case 60: // <
          carts.add(Cart(Direction.west, y, x));
          grid[y][x] = StraightTrack('-'); break;
        case 62: // >
          carts.add(Cart(Direction.east, y, x));
          grid[y][x] = StraightTrack('-'); break;
        case 92: // \
          grid[y][x] = CornerTrackBack(); break;
        case 94: // ^
          carts.add(Cart(Direction.north, y, x));
          grid[y][x] = StraightTrack('|'); break;
        case 118: // v
          carts.add(Cart(Direction.south, y, x));
          grid[y][x] = StraightTrack('|'); break;
        case 124: // |
          grid[y][x] = StraightTrack('|'); break;
        default:
          throw code;
      }
    }
  }
  return grid;
}

abstract class Node {
  final String code;

  const Node(this.code);

  Direction turn(Direction from, TurnDirection direction);

  @override
  String toString() => code;
}
class Empty extends Node {
  const Empty(): super(' ');

  @override
  Direction turn(Direction from, TurnDirection direction) => throw 'empty';
}
class StraightTrack extends Node {
  const StraightTrack(String code): super(code);

  Direction turn(Direction from, TurnDirection direction) => from;
}
class CornerTrackBack extends Node {
  const CornerTrackBack(): super(r'\');

  @override
  Direction turn(Direction from, TurnDirection direction) {
    switch (from) {
      case Direction.north: return Direction.west;
      case Direction.west: return Direction.north;
      case Direction.south: return Direction.east;
      case Direction.east: return Direction.south;
      default: throw from;
    }
  }
}
class CornerTrackForward extends Node {
  const CornerTrackForward(): super('/');

  @override
  Direction turn(Direction from, TurnDirection direction) {
    switch (from) {
      case Direction.north: return Direction.east;
      case Direction.east: return Direction.north;
      case Direction.south: return Direction.west;
      case Direction.west: return Direction.south;
      default: throw from;
    }
  }
}
class Intersection extends Node {
  const Intersection(): super('+');

  @override
  String toString() => '+';

  @override
  Direction turn(Direction from, TurnDirection direction) {
    return from.turn(direction);
  }
}

class Cart implements Comparable<Cart> {
  Direction direction;
  TurnDirection nextTurn = TurnDirection.left;
  int x;
  int y;

  Cart(this.direction, this.x, this.y);

  @override
  String toString() => '$direction at ($x,$y)';

  @override
  int compareTo(Cart other) {
    if (x == other.x) return other.y - y;
    return other.x - x;
  }

  void move(List<List<Node>> grid) {
    switch (direction) {
      case Direction.north: x--; break;
      case Direction.east: y++; break;
      case Direction.south: x++; break;
      case Direction.west: y--; break;
    }
    direction = grid[x][y].turn(direction, nextTurn);
    if (grid[x][y] is Intersection) {
      switch (nextTurn) {
        case TurnDirection.left: nextTurn = TurnDirection.straight; break;
        case TurnDirection.straight: nextTurn = TurnDirection.right; break;
        case TurnDirection.right: nextTurn = TurnDirection.left; break;
      }
    }
  }
}

class Direction {
  static const north = Direction(0);
  static const east = Direction(1);
  static const south = Direction(2);
  static const west = Direction(3);

  final int _value;

  const Direction(this._value);

  Direction turn(TurnDirection direction) {
    return _forValue((_value + direction.offset) % 4);
  }

  static Direction _forValue(int value) {
    switch (value) {
      case 0: return north;
      case 1: return east;
      case 2: return south;
      case 3: return west;
    }
    throw value;
  }

  @override
  String toString() {
    switch (_value) {
      case 0: return '^';
      case 1: return '>';
      case 2: return 'v';
      case 3: return '<';
      default: throw _value;
    }
  }
}

class TurnDirection {
  static const straight = TurnDirection(0);
  static const right = TurnDirection(1);
  static const left = TurnDirection(3);

  final int offset;

  const TurnDirection(this.offset);
}
