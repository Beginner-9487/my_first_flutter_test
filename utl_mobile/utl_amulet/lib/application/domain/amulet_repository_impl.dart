import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_util/cracking_code/bytes_converter.dart';
import 'package:utl_amulet/application/domain/amulet_repository.dart';
import 'package:utl_amulet/application/services/posture_service.dart';

class AmuletRepositoryImpl extends AmuletRepository {
  static const int NORMAL_PACKET_LENGTH = 36;
  static const int _MAX_STORAGE_TIME_SECONDS = 5;

  static AmuletRepositoryImpl? _instance;
  static AmuletRepositoryImpl getInstance() {
    _instance ??= AmuletRepositoryImpl._();
    return _instance!;
  }
  AmuletRepositoryImpl._() {
    _onAddController = StreamController.broadcast();
  }

  final List<AmuletRowImpl> _rows = [];
  int _idCounter = 0;

  @override
  Iterable<AmuletRow> get idRows => _rows;
  @override
  Iterable<BLEDevice> get devices {
    final Set<BLEDevice> uniqueDevices = HashSet<BLEDevice>();
    for (var row in _rows) {
      uniqueDevices.add(row.device);
    }
    return uniqueDevices.toList();
  }
  @override
  Iterable<(BLEDevice, Iterable<AmuletRow>)> get devicesRows {
    return devices.map((e) => (e, _rows.where((element) => element.device == e)));
  }
  @override
  Iterable<AmuletRow> deviceRows(BLEDevice device) {
    return _rows.where((element) => element.device == device);
  }
  @override
  delete(BLEDevice device, {int start = 0, int end = -1}) {
    if(end == -1) {
      _rows.removeWhere((element) => element.device == device);
      return;
    }
    Iterable<int> indexList = _rows.indexed.where((element) => element.$2.device == device).map((e) => e.$1).skip(start).take(end - start);
    for(var index in indexList) {
      _rows.removeAt(index);
    }
  }
  late final StreamController<AmuletRow> _onAddController;
  @override
  StreamSubscription<AmuletRow> onAdd(void Function(AmuletRow row) doSomething) {
    return _onAddController.stream.listen(doSomething);
  }

  _isRawCorrect(List<int> raw) {
    return raw.length == NORMAL_PACKET_LENGTH;
  }
  _removeOldRows(double currentTime) {
    _rows.removeWhere((element) => (currentTime - element.time) > _MAX_STORAGE_TIME_SECONDS);
  }

  add({
    required double time,
    required BLEDevice device,
    required List<int> raw,
  }) {
    // debugPrint("amulet_repository_impl.add.raw: $raw");
    if(!_isRawCorrect(raw)) {
      return;
    }
    AmuletRowImpl row = AmuletRowImpl(
      this,
      device,
      _idCounter++,
      time,
      raw,
      PostureService.posture,
    );
    _rows.add(row);
    _removeOldRows(row.time);
    _onAddController.add(row);
  }
}

class AmuletRowImpl extends AmuletRow {
  AmuletRowImpl(this._repositoryImpl, this.device, this.id, this.time, this.raw, this.posture);
  final AmuletRepositoryImpl _repositoryImpl;
  @override
  BLEDevice device;
  @override
  int id;
  @override
  double time;
  List<int> raw;
  @override
  int get rowIndex {
    (int, AmuletRowImpl)? row = _repositoryImpl._rows.indexed.where((element) => element.$2.id == id).firstOrNull;
    if(row == null) {
      return -1;
    } else {
      return row.$1;
    }
  }
  @override
  int get deviceIndex {
    (int, BLEDevice)? row = _repositoryImpl.devices.indexed.where((element) => element.$2 == device).firstOrNull;
    if(row == null) {
      return -1;
    } else {
      return row.$1;
    }
  }
  @override
  double get accX => BytesConverter.byteArrayToInt16([
    raw[0],
    raw[1],
  ]).toDouble();
  @override
  double get accY => BytesConverter.byteArrayToInt16([
    raw[2],
    raw[3],
  ]).toDouble();
  @override
  double get accZ => BytesConverter.byteArrayToInt16([
    raw[4],
    raw[5],
  ]).toDouble();
  @override
  double get gyroX => BytesConverter.byteArrayToInt16([
    raw[6],
    raw[7],
  ]).toDouble();
  @override
  double get gyroY => BytesConverter.byteArrayToInt16([
    raw[8],
    raw[9],
  ]).toDouble();
  @override
  double get gyroZ => BytesConverter.byteArrayToInt16([
    raw[10],
    raw[11],
  ]).toDouble();
  @override
  double get magX => BytesConverter.byteArrayToInt16([
    raw[12],
    raw[13],
  ]).toDouble();
  @override
  double get magY => BytesConverter.byteArrayToInt16([
    raw[14],
    raw[15],
  ]).toDouble();
  @override
  double get magZ => BytesConverter.byteArrayToInt16([
    raw[16],
    raw[17],
  ]).toDouble();
  @override
  double get pitch => BytesConverter.byteArrayToInt16([
    raw[18],
    raw[19],
  ]).toDouble();
  @override
  double get roll => BytesConverter.byteArrayToInt16([
    raw[20],
    raw[21],
  ]).toDouble();
  @override
  double get yaw => BytesConverter.byteArrayToInt16([
    raw[22],
    raw[23],
  ]).toDouble();
  @override
  double get gValue => BytesConverter.byteArrayToFloat([
    raw[32],
    raw[33],
    raw[34],
    raw[35],
  ]).toDouble();
  @override
  double get temperature => BytesConverter.byteArrayToFloat([
    raw[24],
    raw[25],
    raw[26],
    raw[27],
  ]).toDouble();
  @override
  double get pressure => BytesConverter.byteArrayToFloat([
    raw[28],
    raw[29],
    raw[30],
    raw[31],
  ]).toDouble();
  @override
  bool posture;
}