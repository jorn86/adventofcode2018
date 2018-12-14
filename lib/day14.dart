const input = 633601;

void main() {
  var scores = toDigits(37).toList();
  var e1 = 0;
  var e2 = 1;
  var target = toDigits(input).toList();
  var nextTen = <int>[];
  while (true) {
    for (var newScore in toDigits(scores[e1] + scores[e2])) {
      if (scores.length >= input) {
        if (nextTen.length < 10) {
          nextTen.add(newScore);
        }
        else if (nextTen.length == 10) {
          print(nextTen.join()); // part 1
          nextTen.add(-1);
        }
      }

      scores.add(newScore);

      if (scores.length > target.length
          && listEqual(scores.sublist(scores.length - target.length - 1, scores.length - 1), target)) {
        print(scores.length - target.length - 1); // part 2
        return;
      }
    }
    e1 = forward(e1, scores);
    e2 = forward(e2, scores);
  }
}

bool listEqual<T>(List<T> first, List<T> second) {
  for (int i = 0; i < first.length; i++) {
    if (first[i] != second[i]) return false;
  }
  return true;
}

int forward(int index, List<int> scores) => (index + 1 + scores[index]) % scores.length;

Iterable<int> toDigits(int input) {
  var result = <int>[];
  while (input > 0) {
    result.insert(0, input % 10);
    input ~/= 10;
  }
  return result.isEmpty ? [0] : result;
}
