const initialState = '##.......#.######.##..#...#.#.#..#...#..####..#.##...#....#...##..#..#.##.##.###.##.#.......###....#';
const transitionsInput = '''
.#### => .
....# => .
###.. => .
..#.# => .
##### => #
####. => .
#.##. => #
#.#.# => .
##.#. => #
.###. => .
#..#. => #
###.# => .
#.### => .
##... => #
.#.## => .
..#.. => .
#...# => #
..... => .
.##.. => .
...#. => .
#.#.. => .
.#..# => #
.#.#. => .
.#... => #
..##. => .
#..## => .
##.## => #
...## => #
..### => #
#.... => .
.##.# => #
##..# => #
''';

final regex = RegExp(r'([#.]{5}) => ([#.])');

const steps = 50000000000;

void main() {
  var transitions = <Transition>[];
  for (var match in regex.allMatches(transitionsInput)) {
    transitions.add(Transition(_parse(match.group(1)), _parse(match.group(2))[0]));
  }
  var state = State(_parse(initialState), transitions);
  for (int i = 0; i < 100; i++) {
    if (i == 20) print(state.sum()); // part 1
    state.step();
  }
  state.offset = steps - 19;
  print(state.sum()); // part 2
}

List<bool> _parse(String initialState) => initialState.codeUnits.map((c) => c == 35).toList();

class Transition {
  final List<bool> from;
  final bool to;

  const Transition(this.from, this.to);

  @override
  String toString() => '$from => $to';

  matches(List<bool> subList) {
    for (int i = 0; i < subList.length; i++) {
      if (subList[i] != from[i]) return false;
    }
    return true;
  }
}

class State {
  final List<Transition> transitions;
  List<bool> state;
  int offset = 0;

  State(this.state, this.transitions);

  void step() {
    var newOffset = -1;
    var newState = <bool>[];
    for (int i = -1; i <= state.length; i++) {
      var value = _resultFor(_subList(i - 2, i + 2, state), transitions);
      if (newState.isEmpty && !value) {
        newOffset++;
      }
      else {
        newState.add(value);
      }
    }
    this.offset += newOffset;
    var lastTrue = newState.length - 1;
    while(!newState[lastTrue]) { lastTrue--; };
    this.state = newState.sublist(0, lastTrue + 1);
  }

  int sum() {
    var sum = 0;
    for (int i = 0; i < state.length; i++) {
      if (state[i]) {
        sum += (i + offset);
      }
    }
    return sum;
  }

  bool _resultFor(List<bool> subList, List<Transition> transitions) {
    return transitions.firstWhere((t) => t.matches(subList), orElse: () => Transition(null, false)).to;
  }

  List<bool> _subList(int from, int to, List<bool> state) {
    var sublist = <bool>[];
    for (int i = from; i <= to; i++) {
      try {
        sublist.add(state[i]);
      }
      catch (e) {
        sublist.add(false);
      }
    }
    return sublist;
  }
}
