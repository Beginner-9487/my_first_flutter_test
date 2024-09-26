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
}

abstract class MackayIRBEntity extends Equatable {
  int get id;
  String get data_name;
  int get created_time;
  int get finished_time;
  String get created_time_format;
  String get created_time_format_simple;
  String get created_time_format_for_filename;
  String get finished_time_format;
  String get finished_time_format_for_filename;
  String get device_name;
  String get type_name;
  MackayIRBType get type;
  double get temperature;
  int get number_of_data;
  Iterable<MackayIRBRow> get rows;
  bool get finished;
  MackayIRBRow get_row_by_time(double time);
  StreamSubscription<MackayIRBRow> onAdded(void Function(MackayIRBRow row) doSomething);
  StreamSubscription<MackayIRBEntity> onCreated(void Function(MackayIRBEntity entity) doSomething);
  StreamSubscription<MackayIRBEntity> onFinished(void Function(MackayIRBEntity entity) doSomething);
  @override
  List<int> get props => [id];
}

abstract class MackayIRBRow {
  MackayIRBEntity get entity;
  int get index;
  int get created_time;
  int get created_time_related_to_entity;
  double get created_time_related_to_entity_seconds;
  String get created_time_format;
  String get created_time_format_for_file;
  String get created_time_related_to_entity_format;
  String get created_time_related_to_entity_format_for_file;
  double get current;
  double get voltage;
}

abstract class MackayIRBType extends Equatable {
  int get id;
  String get name;
  @override
  List<int> get props => [id];
}