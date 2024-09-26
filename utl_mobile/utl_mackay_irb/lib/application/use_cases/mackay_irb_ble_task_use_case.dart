import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/use_cases/ble_send_packet_use_case.dart';
import 'package:utl_mackay_irb/application/services/ble_mackay_irb_data_setter.dart';
import 'package:utl_mackay_irb/resources/ble_uuid.dart';

class MackayIRBBLETaskUseCase {
  BLEDevice bleDevice;
  BLEMackayIRBDataSetter bleMackayIRBService;
  BLESendPacketUseCase bleSendPacketUseCase = BLESendPacketUseCase(
      inputCharacteristicUUID: INPUT_UUID,
  );
  MackayIRBBLETaskUseCase(
      this.bleDevice,
      this.bleMackayIRBService,
      );
  startMackayIRB() {
    _sendCommandToDevice(_BLEMackayIRBCommand.start);
  }
  setName(String name) {
    bleMackayIRBService.setName(bleDevice, name);
  }
  String getName() {
    return bleMackayIRBService.getName(bleDevice);
  }
  _sendCommandToDevice(_BLEMackayIRBCommand command) {
    String code = "";
    switch(command) {
      case _BLEMackayIRBCommand.start:
        code = "60";
        break;
    }
    bleSendPacketUseCase.sentCommandToCharacteristic(bleDevice, code);
  }
}

enum _BLEMackayIRBCommand {
  start,
}