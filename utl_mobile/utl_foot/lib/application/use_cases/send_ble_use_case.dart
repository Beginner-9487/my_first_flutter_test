import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/infrastructure/ble_connection_task.dart';
import 'package:flutter_ble/application/infrastructure/ble_packet_handler.dart';
import 'package:utl_foot/resources/ble_uuid.dart';
import 'package:utl_foot/resources/global_variables.dart';

class SendBLEUseCase {
  BLECommandSentPacketHandlerImplFBP bleCommandSentPacketHandlerImplFBP = BLECommandSentPacketHandlerImplFBP();
  static const String MODE_1 = "63";
  static const String MODE_2 = "64";
  final GlobalVariables _globalVariables;
  BLERepository get _bleRepository => _globalVariables.bleRepository;
  SendBLEUseCase(this._globalVariables) {
    _bleConnectionTask = BLEConnectionTask(
        bleRepository: _bleRepository,
        onConnectionDevice: onConnectionDevice
    );
  }
  late final BLEConnectionTask _bleConnectionTask;
  changePacketMode(BLEDevice device) {
    _list
        .where((element) => element.device.address == device.address)
        .firstOrNull
        ?.changePacketMode();
  }
  final List<_DTO> _list = [];
  onConnectionDevice(BLEDevice device, bool isConnected) {
    if(!isConnected) {
      return;
    }
    if(_list
        .where((element) => element.device.address == device.address)
        .isEmpty
    ) {
      _list.add(_DTO(this, device));
    }
  }
}

class _DTO {
  SendBLEUseCase sendBLEUseCase;
  BLEDevice device;
  _DTO(this.sendBLEUseCase, this.device);
  int currentMode = 0;
  changePacketMode() {
    String command = (currentMode == 0) ? SendBLEUseCase.MODE_2 : SendBLEUseCase.MODE_1;
    BLECharacteristic? bleCharacteristic = device.findCharacteristicByUUID(INPUT_UUID);
    if(bleCharacteristic == null) {
        return;
    }
    sendBLEUseCase
        .bleCommandSentPacketHandlerImplFBP
        .sentCommandToCharacteristic(bleCharacteristic, command);
  }
}