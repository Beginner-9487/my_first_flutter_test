import 'dart:async';

import 'package:equatable/equatable.dart';

abstract class MackayIRBRepository {
  Iterable<MackayIRBEntity> get entities;
  Iterable<MackayIRBEntity> get unfinishedEntities;
  Iterable<MackayIRBEntity> get finishedEntities;
  delete({int start, int end});
  StreamSubscription<MackayIRBEntity> onEntityCreated(void Function(MackayIRBEntity entity) doSomething);
  StreamSubscription<MackayIRBEntity> onEntityFinished(void Function(MackayIRBEntity entity) doSomething);
  StreamSubscription<MackayIRBRow> onNewRowAdded(void Function(MackayIRBRow row) doSomething);
  Iterable<MackayIRBEntity> getEntitiesByType(int type);
  MackayIRBEntity? findEntityById(int id);
}

abstract class MackayIRBEntity extends Equatable {
  int get id;
  Iterable<MackayIRBRow> get rows;
  String get name;
  int get type;
  int get numberOfData;
  bool get finished;
  StreamSubscription<MackayIRBRow> onAdded(void Function(MackayIRBRow row) doSomething);
  StreamSubscription<MackayIRBEntity> onCreated(void Function(MackayIRBEntity entity) doSomething);
  StreamSubscription<MackayIRBEntity> onFinished(void Function(MackayIRBEntity entity) doSomething);
  @override
  List<int> get props => [id];
}

abstract class MackayIRBRow {
  MackayIRBEntity get entity;
  int get index;
  double get current;
  double get voltage;
}

class MackayIRBType {
  static const int NULL = 0x00;
  static const int DPV = 0x02;
  static const int CORTISOL = 0x04;
  static const int LACTIC_ACID = 0x05;
}