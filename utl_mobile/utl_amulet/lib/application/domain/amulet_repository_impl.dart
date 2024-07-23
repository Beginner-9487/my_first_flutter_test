import 'dart:async';

import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_util/cracking_code/bytes_converter.dart';
import 'package:utl_amulet/application/domain/amulet_repository.dart';

class AmuletRepositoryImpl extends AmuletRepository {
  static const int NORMAL_PACKET_LENGTH = 34;
  static const int _MAX_STORAGE_TIME_SECONDS = 5;

  static AmuletRepositoryImpl? _instance;
  static AmuletRepositoryImpl getInstance() {
    _instance ??= AmuletRepositoryImpl._();
    return _instance!;
  }
  AmuletRepositoryImpl._() {
    _onAddController = StreamController.broadcast();
  }

  /// Device, Id, Time, Raw
  final List<(BLEDevice, List<(int, double, List<int>)>)> _rawData = [];
  int _idCounter = 0;

  @override
  Iterable<AmuletRow> get idRows => devicesRows
    .map((e) => e.$2)
    .reduce((value, element) => value.followedBy(element))
    .toList()
    ..sort((AmuletRow a, AmuletRow b) {
      if(a.id > b.id) {
        return 1;
      } else if(a.id < b.id) {
        return -1;
      }
      return 0;
    });
  @override
  Iterable<(BLEDevice, Iterable<AmuletRow>)> get devicesRows => _rawData
      .map((device) => (
        device.$1,
        device.$2
          .indexed
          .map((e) => AmuletRowImpl(this, device.$1, e.$1)),
      ));
  @override
  Iterable<AmuletRow> deviceRows(BLEDevice device) {
    return _rawData
        .where((element) => element.$1 == device)
        .indexed
        .map((e) => AmuletRowImpl(this, device, e.$1));
  }

  _isRawCorrect(List<int> raw) {
    return raw.length == NORMAL_PACKET_LENGTH;
  }
  _removeOldRows(double currentTime) {
    for(var deviceRows in devicesRows) {
      var rows = deviceRows.$2;
      while(rows.isNotEmpty && (currentTime - rows.first.time) > _MAX_STORAGE_TIME_SECONDS) {
        delete(
          rows.first.device,
          start: 0,
          end: 1,
        );
      }
    }
  }
  List<(int, double, List<int>)>? _findRaw(BLEDevice device) {
    return _rawData
        .where((element) => element.$1 == device)
        .map((e) => e.$2)
        .firstOrNull;
  }
  @override
  delete(BLEDevice device, {int start = 0, int end = -1}) {
    var raw = _findRaw(device);
    if(raw == null) {
      return;
    }
    if(end == -1) {
      end = raw.length - 1;
    }
    raw.removeRange(start, end);
  }
  add({
    required double time,
    required BLEDevice device,
    required List<int> raw,
  }) {
    if(!_isRawCorrect(raw)) {
      return;
    }
    var currentRaw = _findRaw(device);
    if(currentRaw == null) {
      (BLEDevice, List<(int, double, List<int>)>) newRaw = (
        device,
        [],
      );
      currentRaw = newRaw.$2;
      _rawData.add(newRaw);
    }
    currentRaw
        .add((
          _idCounter++,
          time,
          raw,
        ));
    AmuletRow newestRow = deviceRows(device).last;
    _removeOldRows(newestRow.time);
    _onAddController.add(newestRow);
  }

  late final StreamController<AmuletRow> _onAddController;
  @override
  StreamSubscription<AmuletRow> onAdd(void Function(AmuletRow row) doSomething) {
    return _onAddController.stream.listen(doSomething);
  }
}

class AmuletRowImpl extends AmuletRow {
  AmuletRowImpl(this._repositoryImpl, this.device, this.rowIndex);
  final AmuletRepositoryImpl _repositoryImpl;
  @override
  BLEDevice device;
  @override
  int rowIndex;
  (int, double, List<int>) get _rawData {
    var item = _repositoryImpl
        ._findRaw(device);
    if(item != null && rowIndex < item.length) {
      return item[rowIndex];
    }
    return (0, 0, List.filled(AmuletRepositoryImpl.NORMAL_PACKET_LENGTH, 0));
  }
  @override
  int get id => _rawData.$1;
  @override
  double get time => _rawData.$2;
  List<int> get _raw => _rawData.$3;
  @override
  int get deviceIndex => _repositoryImpl._rawData
      .indexed
      .where((element) => element.$2.$1 == device)
      .first
      .$1;
  @override
  double get accX => BytesConverter.byteArrayToSignedInt([
    _raw[1],
    _raw[0],
  ]).toDouble();
  @override
  double get accY => BytesConverter.byteArrayToSignedInt([
    _raw[3],
    _raw[2],
  ]).toDouble();
  @override
  double get accZ => BytesConverter.byteArrayToSignedInt([
    _raw[5],
    _raw[4],
  ]).toDouble();
  @override
  double get gyroX => BytesConverter.byteArrayToSignedInt([
    _raw[7],
    _raw[6],
  ]).toDouble();
  @override
  double get gyroY => BytesConverter.byteArrayToSignedInt([
    _raw[9],
    _raw[8],
  ]).toDouble();
  @override
  double get gyroZ => BytesConverter.byteArrayToSignedInt([
    _raw[11],
    _raw[10],
  ]).toDouble();
  @override
  double get magX => BytesConverter.byteArrayToSignedInt([
    _raw[13],
    _raw[12],
  ]).toDouble();
  @override
  double get magY => BytesConverter.byteArrayToSignedInt([
    _raw[15],
    _raw[14],
  ]).toDouble();
  @override
  double get magZ => BytesConverter.byteArrayToSignedInt([
    _raw[17],
    _raw[16],
  ]).toDouble();
  @override
  double get pitch => BytesConverter.byteArrayToFloat([
    _raw[18],
    _raw[19],
    _raw[20],
    _raw[21],
  ]).toDouble();
  @override
  double get roll => BytesConverter.byteArrayToFloat([
    _raw[22],
    _raw[23],
    _raw[24],
    _raw[25],
  ]).toDouble();
  @override
  double get yaw => BytesConverter.byteArrayToFloat([
    _raw[26],
    _raw[27],
    _raw[28],
    _raw[29],
  ]).toDouble();
  @override
  double get gValue => BytesConverter.byteArrayToFloat([
    _raw[30],
    _raw[31],
    _raw[32],
    _raw[33],
  ]).toDouble();
}