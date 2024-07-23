import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/infrastructure/ble_packet_handler.dart';

class BLESendPacketUseCase {
  final String inputCharacteristicUUID;
  final BLECommandSentPacketHandler _bleCommandSentPacketHandler = BLECommandSentPacketHandlerImplFBP();
  BLESendPacketUseCase({
    required this.inputCharacteristicUUID,
  });
  sentCommandToCharacteristic(BLEDevice bleDevice, String command) {
    for(var service in bleDevice.services) {
      for(var characteristic in service.characteristics.where((element) => element.uuid == inputCharacteristicUUID)) {
        _bleCommandSentPacketHandler.sentCommandToCharacteristic(characteristic, command);
      }
    }
  }
}