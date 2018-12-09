import 'package:adventofcode2018/util.dart';

const players = 438;
const last1 = 71626;
const last2 = last1 * 100;

void main() {
  run(last1);
  run(last2);
}

void run(int lastMarble) {
  var current = LinkedNode(0);
  var score = List.filled(players, 0);
  for (var turn = 1; turn <= lastMarble; turn++) {
    if (turn % 23 == 0) {
      var removed = current.move(-7).unlink();
      score[turn % players] += turn + removed.value;
      current = removed.next;
    }
    else {
      current = current.next.insertAfter(turn);
    }
  }
  print('highest score is ${score.reduce((a,b) => a>b?a:b)}');
}
