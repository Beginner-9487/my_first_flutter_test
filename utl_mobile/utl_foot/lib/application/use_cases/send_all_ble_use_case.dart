import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/infrastructure/ble_packet_handler.dart';
import 'package:utl_foot/resources/ble_uuid.dart';
import 'package:utl_foot/resources/global_variables.dart';

class SendAllBLEUseCase {
  BLECommandSentPacketHandlerImplFBP bleCommandSentPacketHandlerImplFBP = BLECommandSentPacketHandlerImplFBP();
  final GlobalVariables _globalVariables;
  BLERepository get _bleRepository => _globalVariables.bleRepository;
  SendAllBLEUseCase(this._globalVariables);
  sendCommand(String command) {
    for(var device in _bleRepository.connectedDevices) {
      var characteristic = device.findCharacteristicByUUID(INPUT_UUID);
      if(characteristic != null) {
        bleCommandSentPacketHandlerImplFBP.sentCommandToCharacteristic(characteristic, command);
      }
    }
  }
}