import 'utils.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

final Map<DeviceIdentifier, StreamControllerReEmit<bool>> _characteristicsGlobal = {};
final Map<DeviceIdentifier, StreamControllerReEmit<bool>> _descriptorsGlobal = {};

/// connect & disconnect + update stream
extension Extra on BluetoothDevice {
  // convenience
  StreamControllerReEmit<bool> get _characteristicStream {
    _characteristicsGlobal[remoteId] ??= StreamControllerReEmit(initialValue: false);
    return _characteristicsGlobal[remoteId]!;
  }

  // convenience
  StreamControllerReEmit<bool> get _descriptorStream {
    _descriptorsGlobal[remoteId] ??= StreamControllerReEmit(initialValue: false);
    return _descriptorsGlobal[remoteId]!;
  }

  // get stream
  Stream<bool> get isConnecting {
    return _characteristicStream.stream;
  }

  // get stream
  Stream<bool> get isDisconnecting {
    return _descriptorStream.stream;
  }

  // connect & update stream
  Future<void> connectAndUpdateStream() async {
    _characteristicStream.add(true);
    try {
      await connect(mtu: null);
    } finally {
      _characteristicStream.add(false);
    }
  }

  // disconnect & update stream
  Future<void> disconnectAndUpdateStream({bool queue = true}) async {
    _descriptorStream.add(true);
    try {
      await disconnect(queue: queue);
    } finally {
      _descriptorStream.add(false);
    }
  }
}
