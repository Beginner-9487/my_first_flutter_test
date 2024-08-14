import 'dart:async';

abstract class HandRepository {
  Iterable<HandRow> get leftHandRows;
  Iterable<HandRow> get rightHandRows;
  StreamSubscription<(bool, HandRow)> onAdd(void Function(bool isRight, HandRow row) doSomething);
}

abstract class HandRow {
  bool get isRight;
  int get id;
  double get time;
  double get x0;
  double get y0;
  double get z0;
  double get x1;
  double get y1;
  double get z1;
}