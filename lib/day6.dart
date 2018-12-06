import 'package:adventofcode2018/util.dart' as util;

const input = '''
1, 1
1, 6
8, 3
3, 4
5, 5
8, 9''';
const input2 = '''
162, 168
86, 253
288, 359
290, 219
145, 343
41, 301
91, 214
166, 260
349, 353
178, 50
56, 79
273, 104
173, 118
165, 47
284, 235
153, 69
116, 153
276, 325
170, 58
211, 328
238, 346
333, 299
119, 328
173, 289
44, 223
241, 161
225, 159
266, 209
293, 95
89, 86
281, 289
50, 253
75, 347
298, 241
88, 158
40, 338
291, 156
330, 88
349, 289
165, 102
232, 131
338, 191
178, 335
318, 107
335, 339
153, 156
88, 119
163, 268
159, 183
162, 134''';

var regex = RegExp(r"(\d+), (\d+)");

void main() {
  var minX = 1000;
  var maxX = -1;
  var minY = 1000;
  var maxY = -1;
  var coordinates = <Coordinate>[];
  regex.allMatches(input2).forEach((m) {
    var c = Coordinate(int.parse(m.group(1)), int.parse(m.group(2)));
    coordinates.add(c);
    if (c.x < minX) minX = c.x;
    if (c.x > maxX) maxX = c.x;
    if (c.y < minY) minY = c.y;
    if (c.y > maxY) maxY = c.y;
  });
  List<List<Space>> grid = util.grid(maxX - minX + 1, maxY - minY + 1, Empty());
  print('$minX,$maxX:$minY,$maxY; ${grid.length}x${grid[0].length}; ${coordinates.length} coordinates');
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

void _printGrid(List<List<Space>> grid) => grid.forEach((col) => print(col.map((a) => a.toString()).reduce((a,b) => '$a$b')));

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
