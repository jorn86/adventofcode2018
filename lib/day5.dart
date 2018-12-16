import 'dart:io';

void main() {
  var prev = File('./lib/day5.txt').readAsStringSync();
  prev = run(prev);
  print(prev.length); //part1

  var min = 20000;
  for (var char = 65; char < 91; char++) {
    var lower = String.fromCharCode(char);
    var upper = String.fromCharCode(char+32);
    var out = run(prev.replaceAll(lower, "").replaceAll(upper, ""));
    if (out.length < min) {
      min = out.length;
    }
  }
  print(min);
}

String run(String prev) {
  while(true) {
    var next = StringBuffer();
    var prevChar = null;
    prev.runes.forEach((r) {
      if (prevChar != null && (prevChar - r).abs() == 32) {
        prevChar = null;
      }
      else {
        if (prevChar != null) next.writeCharCode(prevChar);
        prevChar = r;
      }
    });
    if (prevChar != null) next.writeCharCode(prevChar);
    if (next.toString() == prev) return next.toString();
    prev = next.toString();
  }
}