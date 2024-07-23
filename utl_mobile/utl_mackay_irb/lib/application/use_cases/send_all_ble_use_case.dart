import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/infrastructure/ble_packet_handler.dart';
import 'package:utl_mackay_irb/resources/ble_uuid.dart';

class SendAllBLEUseCase {
  BLECommandSentPacketHandlerImplFBP bleCommandSentPacketHandlerImplFBP = BLECommandSentPacketHandlerImplFBP();
  SendAllBLEUseCase(this.bleRepository);
  BLERepository bleRepository;
  sendCommand(String command) {
    for(var device in bleRepository.connectedDevices) {
      var characteristic = device.findCharacteristicByUUID(INPUT_UUID);
      if(characteristic != null) {
        bleCommandSentPacketHandlerImplFBP.sentCommandToCharacteristic(characteristic, command);
      }
    }
  }
}