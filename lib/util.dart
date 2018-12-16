int matchInt(Match match, {int group = 0}) => int.parse(match.group(group));

int sum(Iterable<int> list) => list.isEmpty ? 0 : list.reduce((a,b) => a+b);

List<List<E>> grid<E>(int x, int y, E initialValue) {
  var grid = <List<E>>[];
  for (int i = 0; i < x; i++) {
    grid.add(List.filled(y, initialValue));
  }
  return grid;
}
