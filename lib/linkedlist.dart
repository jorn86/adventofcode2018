class LinkedNode<T> extends Iterable<T> {
  final T value;
  LinkedNode<T> _prev;
  LinkedNode<T> _next;

  LinkedNode._internal(this.value, {LinkedNode<T> prev, LinkedNode<T> next}) {
    _prev = prev;
    _next = next;
  }

  factory LinkedNode(T value) {
    var node = LinkedNode._internal(value);
    node._prev = node._next = node;
    return node;
  }

  LinkedNode<T> get prev => _prev;
  LinkedNode<T> get next => _next;

  LinkedNode<T> insertAfter(T value) {
    _next = LinkedNode._internal(value, prev: this, next: next);
    next.next._prev = next;
    return next;
  }

  LinkedNode<T> insertBefore(T value) {
    _prev = LinkedNode._internal(value, prev: prev, next: this);
    prev.prev._next = prev;
    return prev;
  }

  LinkedNode<T> unlink() {
    prev._next = next;
    next._prev = prev;
    return this;
  }

  LinkedNode<T> move(int amount) {
    return amount == 0 ? this :
    amount < 0 ? prev.move(amount + 1)
        : next.move(amount - 1);
  }

  String listToString() {
    return this.map((e) => '$e').join(',');
  }

  @override
  String toString() => '$value';

  @override
  Iterator<T> get iterator => _LinkedIterator(this);
}

class _LinkedIterator<T> extends Iterator<T> {
  final LinkedNode<T> first;
  LinkedNode<T> _current = null;

  _LinkedIterator(this.first);

  @override
  T get current => _current == null ? null : _current.value;

  @override
  bool moveNext() {
    if (_current != null && _current.next == first) {
      _current = null;
      return false;
    }
    _current = _current == null ? first : _current.next;
    return true;
  }
}
