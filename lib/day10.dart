import 'dart:io';

import 'package:adventofcode2018/util.dart';

var regex = RegExp(r'(-?\d+),\s+(-?\d+).+<(\s?-?\d+),\s+(-?\d+)');
void main() {
  var stars = <Star>[];
  for (var value in regex.allMatches(File('./lib/day10.txt').readAsStringSync())) {
    stars.add(Star(matchInt(value, group: 2), matchInt(value, group: 1), matchInt(value, group: 4), matchInt(value, group: 3)));
  }

  for (var i = 0; i < 10036; i++) { // turns out that was the part 2 answer
    stars.forEach((s) => s.step());
  }
  printGrid(stars); // part 1
}

void printGrid(List<Star> stars) {
  var minX = 10000;
  var minY = 10000;
  var maxX = -10000;
  var maxY = -10000;
  for (var value in stars) {
    if (value.posX < minX) minX = value.posX;
    if (value.posY < minY) minY = value.posY;
    if (value.posX > maxX) maxX = value.posX;
    if (value.posY > maxY) maxY = value.posY;
  }
  for (var x = minX; x <= maxX; x++) {
    var b = StringBuffer();
    for (var y = minY; y <= maxY; y++) {
      b.write(stars.any((s) => s.posX == x && s.posY == y) ? '#' : '.');
    }
    print(b);
  }
}

class Star {
  int posX;
  int posY;
  final int velX;
  final int velY;

  Star(this.posX, this.posY, this.velX, this.velY);

  void step() {
    posX += velX;
    posY += velY;
  }
}
