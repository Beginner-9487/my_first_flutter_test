import 'dart:async';

import 'package:utl_hands/application/domain/hand_repository.dart';

class HandRepositoryImpl implements HandRepository {
  static HandRepositoryImpl? _instance;
  static HandRepositoryImpl getInstance() {
    _instance ??= HandRepositoryImpl._();
    _onAdd = StreamController.broadcast();
    return _instance!;
  }
  HandRepositoryImpl._();
  static late StreamController<(bool, HandRow)> _onAdd;
  @override
  List<HandRowImpl> leftHandRows = [];
  @override
  List<HandRowImpl> rightHandRows = [];
  static int _idCounter = 0;
  add(
      bool isRight,
      double time,
      double x0,
      double y0,
      double z0,
      double x1,
      double y1,
      double z1,
  ) {
    HandRowImpl row = HandRowImpl(
        this,
        isRight,
        _idCounter++,
        time,
        x0, y0, z0, x1, y1, z1,
    );
    if(isRight) {
      rightHandRows.add(row);
    } else {
      leftHandRows.add(row);
    }
    _deleteOldData(time);
    _onAdd.sink.add((isRight, row));
  }
  static const double _REMOVE_TIME_SECOND = 5;
  _deleteOldData(double time) {
    leftHandRows.removeWhere((element) => time - element.time > _REMOVE_TIME_SECOND);
    rightHandRows.removeWhere((element) => time - element.time > _REMOVE_TIME_SECOND);
  }
  @override
  StreamSubscription<(bool, HandRow)> onAdd(void Function(bool isRight, HandRow row) doSomething) {
    return _onAdd.stream.listen((event) {doSomething(event.$1, event.$2);});
  }
}

class HandRowImpl implements HandRow {
  HandRowImpl(
      this.repository,
      this.isRight,
      this.id,
      this.time,
      this.x0,
      this.y0,
      this.z0,
      this.x1,
      this.y1,
      this.z1,
  );
  HandRepository repository;
  @override
  bool isRight;
  @override
  int id;
  @override
  double time;
  @override
  double x0;
  @override
  double y0;
  @override
  double z0;
  @override
  double x1;
  @override
  double y1;
  @override
  double z1;
}