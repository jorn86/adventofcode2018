import 'dart:io';

import 'package:adventofcode2018/util.dart';

void main() {
  var lines = File('./lib/day4.txt').readAsLinesSync();
  lines.sort();

  Map<int, List<int>> totalSleep = {};
  var guard = -1;
  var prevMinute = 0;
  var max = <int>[];
  var maxGuard = 0;
  for (var line in lines) {
    var minute = int.parse(line.substring(15,17));
    if (line.contains("Guard")) {
      guard = int.parse(line.substring(26, line.indexOf(" ", 26)));
      if (!totalSleep.containsKey(guard)) totalSleep[guard] = List.filled(60, 0);
      prevMinute = 0;
    }
    else {
      if (line.contains("wakes up")) {
        for (var min = prevMinute; min < minute; min++) {
          totalSleep[guard][min] += 1;
        }
        if (sum(totalSleep[guard]) > sum(max)) {
          max = totalSleep[guard];
          maxGuard = guard;
        }
      }
      else {
        prevMinute = minute;
      }
    }
  }

  part1(maxGuard, max);

  var maxSleep = 0;
  var maxMinute;
  for (var value in totalSleep.entries) {
    var guard = value.key;
    for (var minute = 0 ; minute < 60; minute++) {
      if (value.value[minute] > maxSleep) {
        maxSleep = value.value[minute];
        maxGuard = guard;
        maxMinute = minute;
      }
    }
  }
  print ('$maxGuard * $maxMinute = ${maxGuard * maxMinute}');
}

void part1(int maxGuard, List<int> max) {
  var maxSleep = 0;
  var maxIndex;
  for (int i = 0; i < max.length; i++) {
    var value = max[i];
    if (value > maxSleep) {
      maxSleep = value;
      maxIndex = i;
    }
  }
  print('$maxGuard * $maxIndex = ${maxGuard * maxIndex}');
}
