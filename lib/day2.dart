import 'dart:io';

void first() {
  var ids = File('./lib/day2.txt').readAsLinesSync();
  var twos = 0;
  var threes = 0;
  for (var value in ids) {
    var chars = <int, int>{};
    value.runes.forEach((c) {
      if (chars.containsKey(c)) {
        chars[c] =  chars[c] + 1;
      }
      else {
        chars[c] = 1;
      }
    });
    if (chars.containsValue(2)) {
      twos++;
    }
    if (chars.containsValue(3)) {
      threes++;
    }
  }
  print ('$twos * $threes = ${twos * threes}');
}

void second() {
  var ids = File('./lib/day2.txt').readAsLinesSync();
  for (int i = 0; i < ids.length; i++) {
    var first = ids[i];
    for (int j = i+1; j < ids.length; j++) {
      var second = ids[j];
      var singleDiff = false;
      var fi = first.runes.iterator;
      var si = second.runes.iterator;
      while (fi.moveNext() && si.moveNext()) {
        if (fi.current != si.current) {
          if (singleDiff) {
            singleDiff = false;
            break;
          }
          else {
            singleDiff = true;
          }
        }
      }
      if (singleDiff) {
        print('found $first $second');
        return;
      }
    }
  }
}
