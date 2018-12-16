import 'dart:io';

import 'package:adventofcode2018/util.dart' as util;

var regex = RegExp(r"(\d+), (\d+)");

void main() {
  var minX = 1000;
  var maxX = -1;
  var minY = 1000;
  var maxY = -1;
  var coordinates = <Coordinate>[];
  regex.allMatches(File('./lib/day6.txt').readAsStringSync()).forEach((m) {
    var c = Coordinate(util.matchInt(m, group: 1), util.matchInt(m, group: 2));
    coordinates.add(c);
    if (c.x < minX) minX = c.x;
    if (c.x > maxX) maxX = c.x;
    if (c.y < minY) minY = c.y;
    if (c.y > maxY) maxY = c.y;
  });
  List<List<Space>> grid = util.grid(maxX - minX + 1, maxY - minY + 1, Empty());
  for (int i = 0; i < coordinates.length; i++) {
    var code = String.fromCharCode(i+65);
    coordinates[i].code = code;
    coordinates[i].x -= minX;
    coordinates[i].y -= minY;
    grid[coordinates[i].x][coordinates[i].y] = CoordinateSpace(code, coordinates[i]);
  }

  var distance = 1;
  var any = true;
  while(any) {
    any = false;
    for (var value in coordinates) {
      any |= _claim(grid, value, distance);
    }
    distance++;
  }

  var maxArea = 0;
  for (var c in coordinates) {
    var area = _areaOf(c, grid);
    if (area > maxArea) maxArea = area;
  }
  print(maxArea); // part 1

  var size = 0;
  for (var x = 0; x < grid.length; x++) {
    for (var y = 0; y < grid[0].length; y++) {
      var sum = 0;
      for (var c in coordinates) {
        var dist = _distance(c.x, c.y, x, y);
        sum += dist;
      }
      if (sum < 10000) {
        size++;
      }
      grid[x][y].totalDistance = sum;
    }
  }
  print(size); // part 2
}

bool _claim(List<List<Space>> grid, Coordinate coordinate, int distance) {
  var spaces = _surroundingSpaces(grid, coordinate, distance: distance);
  var any = false;
  for (var entry in spaces.entries) {
    if (entry.value.isEmpty()) {
      grid[entry.key.x][entry.key.y] = AreaSpace(coordinate.code, distance);
      any = true;
    }
    else if (entry.value.distanceIs(distance)) {
      grid[entry.key.x][entry.key.y] = Shared();
      any = true;
    }
  }
  return any;
}

Map<Coordinate, Space> _surroundingSpaces(List<List<Space>> grid, Coordinate coordinate, {int distance = 1}) {
  var spaces = <Coordinate, Space>{};

  for (int xOffset = 0; xOffset <= distance; xOffset++) {
    var yOffset = (distance - xOffset).abs();
    _putIf(grid, spaces, Coordinate(coordinate.x + xOffset, coordinate.y + yOffset));
    _putIf(grid, spaces, Coordinate(coordinate.x - xOffset, coordinate.y + yOffset));
    _putIf(grid, spaces, Coordinate(coordinate.x + xOffset, coordinate.y - yOffset));
    _putIf(grid, spaces, Coordinate(coordinate.x - xOffset, coordinate.y - yOffset));
  }
  return spaces;
}

void _putIf(List<List<Space>> grid, Map<Coordinate, Space> spaces, Coordinate coordinate) {
  if (!(coordinate.x < 0 || coordinate.y < 0 || coordinate.x >= grid.length || coordinate.y >= grid[0].length)
      && !spaces.containsKey(coordinate)) {
    spaces[coordinate] = grid[coordinate.x][coordinate.y];
  }
}

_areaOf(Coordinate coordinate, List<List<Space>> grid) =>
    grid.map((col) => col.where((space) => space.code == coordinate.code).length).reduce((a,b) => a+b);

_distance(int x1, int y1, int x2, int y2) => (x1-x2).abs() + (y1-y2).abs();

abstract class Space {
  bool isEmpty() => false;
  String get code => null;
  bool distanceIs(int distance) => false;
  int totalDistance;
  Space();
}
class Empty extends Space {
  Empty();
  @override bool isEmpty() => true;
  @override String toString() => ".";
}
class Shared extends Space {
  @override String toString() => "-";
}
class CoordinateSpace extends Space {
  final String code;
  final Coordinate coordinate;
  CoordinateSpace(this.code, this.coordinate);
  @override String toString() => code;
}
class AreaSpace extends Space {
  final String code;
  final int distance;
  AreaSpace(this.code, this.distance);
  bool distanceIs(int distance) => this.distance == distance;
  @override String toString() => code.toLowerCase();
}

class Coordinate {
  int x;
  int y;
  String code;

  Coordinate(this.x, this.y);

  @override String toString() => '$x,$y';
  @override bool operator ==(other) => other.x == x && other.y == y;
  @override int get hashCode => x*1000+y;
}
