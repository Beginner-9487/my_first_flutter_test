import 'dart:async';

import 'package:flutter_ble/application/domain/ble_repository.dart';

class BLEConnectionTask {
  late final StreamSubscription<BLEDevice> _onNewDeviceFoundedSubscription;
  final List<(BLEDevice, StreamSubscription<bool>)> _onConnectDeviceSubscriptions = [];
  final BLERepository bleRepository;
  final void Function(BLEDevice device, bool isConnected) onConnectionDevice;

  BLEConnectionTask({
    required this.bleRepository,
    required this.onConnectionDevice,
  }) {
    _onNewDeviceFoundedSubscription = bleRepository.onNewDeviceFounded(_onNewDeviceFounded);
  }

  _onNewDeviceFounded(BLEDevice result) async {
    _onConnectDeviceSubscriptions.add((
      result,
      result.onConnectStateChange(
          (isConnected) { onConnectionDevice(result, isConnected); }
      ),
    ));
  }
}