import 'dart:async';

import 'package:flutter_ble/application/domain/ble_repository.dart';

abstract class AmuletRepository {
  Iterable<AmuletRow> get idRows;
  Iterable<BLEDevice> get devices;
  Iterable<(BLEDevice, Iterable<AmuletRow>)> get devicesRows;
  Iterable<AmuletRow> deviceRows(BLEDevice device);
  StreamSubscription<AmuletRow> onAdd(void Function(AmuletRow row) doSomething);
  delete(BLEDevice device, {int start = 0, int end = -1});
}

abstract class AmuletRow {
  int get id;
  int get rowIndex;
  int get deviceIndex;
  BLEDevice get device;
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
  double get gValue;
  double get temperature;
  double get pressure;
  bool get posture;
}