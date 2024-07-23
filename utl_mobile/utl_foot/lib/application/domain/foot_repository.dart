import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class FootRepository<RowData> {
  Iterable<FootEntity> get entities;
  add(RowData rowData);
  delete(int bodyPart, {int start, int end});
  StreamSubscription<FootEntity> onNewRowAdded(void Function(FootEntity entity) doSomething);
  StreamSubscription<FootRow> onNewRowAddedRow(void Function(FootRow row) doSomething);
  StreamSubscription<FootEntity> onNewRowFinished(void Function(FootEntity entity) doSomething);
  StreamSubscription<FootRow> onNewRowFinishedRow(void Function(FootRow row) doSomething);
  FootEntity findEntityByBodyPart(int bodyPart);
}

abstract class FootEntity extends Equatable {
  int get bodyPart;
  Iterable<FootRow> get rows;
  Iterable<FootRow> get rowsFinished;
  @override
  List<int> get props => [bodyPart];
}

abstract class FootRow {
  bool get isMagToAIFinished;
  bool get isAllCalculateFinished;
  bool get isAllInitFinished;
  FootEntity get entity;
  int get bodyPart;
  int get rowId;
  int get rowIndex;
  double get time;
  double get accX;
  double get accY;
  double get accZ;
  double get gyroX;
  double get gyroY;
  double get gyroZ;
  double get magX;
  double get magY;
  double get magZ;
  double get pitch;
  double get roll;
  double get yaw;
  List<FootSensorData> get sensorsData;
  Point get sensorPressureCenter;
  double get sensorPressureAverage;
  Point get sensorTemperatureCenter;
  double get sensorTemperatureAverage;
}

abstract class FootSensorData {
  FootEntity get entity;
  int get bodyPart;
  FootRow get row;
  int get rowId;
  int get rowIndex;
  int get sensorIndex;
  double get magX;
  double get magY;
  double get magZ;
  double get temperature;
  double get shearForceX;
  double get shearForceY;
  double get shearForceTotal;
  double get shearForceRadians => atan2(shearForceY, shearForceX);
  double get pressure;
  Point<double> get position;
}

class BodyPart {
  static const int NULL = 0x00;
  static const int LEFT_FOOT = 0x0A;
  static const int RIGHT_FOOT = 0x0B;
}