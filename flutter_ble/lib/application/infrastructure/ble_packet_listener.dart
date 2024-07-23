import 'dart:async';

import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/infrastructure/ble_connection_task.dart';

class BLEPacketListener {
  late final BLEConnectionTask bleConnectionTask;

  final String outputCharacteristicUUID;
  final void Function(BLECharacteristic, BLEPacket packet) onReceivedPacket;
  final List<(BLEDevice, StreamSubscription<BLEPacket>)> _onReceivedPacketSubscriptions = [];

  BLEPacketListener({
    required bleRepository,
    required this.outputCharacteristicUUID,
    required this.onReceivedPacket,
  }) {
    bleConnectionTask = BLEConnectionTask(
      bleRepository: bleRepository,
      onConnectionDevice: _onConnectDevice,
    );
  }

  _onConnectDevice(BLEDevice device, bool isConnected) async {
    await device.discoverServices();
    if(isConnected) {
      BLECharacteristic? characteristic = device.findCharacteristicByUUID(outputCharacteristicUUID);
      if(characteristic != null) {
        if(!characteristic.isNotified) {
          await characteristic.setNotify(true);
        }
        if(_onReceivedPacketSubscriptions.where((element) => element.$1 == device).isEmpty) {
            _onReceivedPacketSubscriptions.add((
              device,
              characteristic.onReadNotifiedData((packet) {
                onReceivedPacket(characteristic, packet);
              }),
            ));
        }
      }
    }
  }
}