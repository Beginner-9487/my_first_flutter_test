class IteratorProcessor<T> {
  late Iterator<T> _iterator;
  int counter = 0;

  IteratorProcessor(Iterable<T> iterable) {
    _iterator = iterable.iterator;
    _iterator.moveNext();
  }

  T get current => _iterator.current!;

  bool moveNext() {
    counter++;
    return _iterator.moveNext();
  }

  T takeOut() {
    if (_iterator.current! == null) {
      throw Exception("IteratorProcessor.takeOut(): error occur, current counter is: $counter");
    }
    T currentValue = current;
    moveNext();
    return currentValue;
  }

  List<T> takeOutList(int length) {
    List<T> list = [];
    for(int i=0; i<length; i++) {
      list.add(takeOut());
    }
    return list;
  }

  List<T> takeOutReversedList(int length) {
    return takeOutList(length).reversed.toList();
  }
}