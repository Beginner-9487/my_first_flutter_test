import 'dart:async';

import 'package:utl_electrochemical_tester/domain/repository/electrochemical_entity_repository.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';

class _Buffer {
  int? entityId;
  String dataName;
  ElectrochemicalParameters parameters;
  final String deviceId;
  _Buffer({
    required this.dataName,
    required this.deviceId,
    required this.parameters,
  });
}

class ElectrochemicalBluetoothBuffer {
  ElectrochemicalBluetoothBuffer._();
  static final List<_Buffer> _buffers = [];
  static late final StreamSubscription _syncStreamSubscription;
  static late final StreamSubscription _removedStreamSubscription;
  static void init({
    required ElectrochemicalEntityRepository electrochemicalEntityRepository,
  }) {
    _syncStreamSubscription = electrochemicalEntityRepository.entitySyncStream.listen((entity) {
      var buffer = _buffers.where((b) => b.deviceId == entity.electrochemicalHeader.deviceId).firstOrNull;
      if(buffer == null) return;
      buffer.entityId = entity.id;
    });
    _removedStreamSubscription = electrochemicalEntityRepository.entityRemovedStream.listen((entityId) {
      var buffer = _buffers.where((b) => b.entityId == entityId).firstOrNull;
      if(buffer == null) return;
      buffer.entityId = null;
    });
  }
  static void dispose() {
    _syncStreamSubscription.cancel();
    _removedStreamSubscription.cancel();
    _buffers.clear();
  }
  static void setBuffer({
    required String dataName,
    required String deviceId,
    required ElectrochemicalParameters parameters,
  }) {
    var buffer = _buffers.where((b) => b.deviceId == deviceId).firstOrNull;
    if(buffer == null) {
      _buffers.add(
        _Buffer(
          dataName: dataName,
          deviceId: deviceId,
          parameters: parameters,
        ),
      );
    } else {
      buffer.dataName = dataName;
      buffer.parameters = parameters;
    }
  }
  static String? getDataName({
    required String deviceId,
  }) {
    return _buffers.where((b) => b.deviceId == deviceId).map((b) => b.dataName).firstOrNull;
  }
  static ElectrochemicalParameters? getParameters({
    required String deviceId,
  }) {
    return _buffers.where((b) => b.deviceId == deviceId).map((b) => b.parameters).firstOrNull;
  }
  static int? getEntityId({
    required String deviceId,
  }) {
    return _buffers.where((b) => b.deviceId == deviceId).map((b) => b.entityId).firstOrNull;
  }
}
