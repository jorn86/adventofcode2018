import 'package:adventofcode2018/util.dart' as util;

const serial = 8772;

void main() {
  var cellPower = util.grid(301, 301, 0);
  var areaPower = util.grid(301, 301, 0);
  for (var x = 1; x <= 300; x++) {
    var rackId = x+10;
    for (var y = 1; y <= 300; y++) {
      areaPower[x][y] = cellPower[x][y] = (((((rackId * y) + serial) * rackId) ~/ 100) % 10) - 5;
    }
  }
  print(gridPower(cellPower, 90, 269, 16));

  var max = -100;
  for (var size = 2; size <= 20; size++) {
    print('checking size $size');
    for (var x = 1; x <= 301 - size; x++) {
      for (var y = 1; y <= 301 - size; y++) {
        var power = gridPower(cellPower, x, y, size);
        if (power > max) {
          max = power;
          print('$x,$y,$size: $power');
        }
      }
    }
  }
}

gridPower(List<List<int>> grid, int topX, int topY, int size) {
  var power = 0;
  for (int x = topX; x < topX+size; x++) {
    for (int y = topY; y < topY+size; y++) {
      power += grid[x][y];
    }
  }
  return power;
}
