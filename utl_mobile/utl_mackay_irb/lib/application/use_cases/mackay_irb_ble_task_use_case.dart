import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/use_cases/ble_send_packet_use_case.dart';
import 'package:utl_mackay_irb/application/services/ble_mackay_irb_service.dart';
import 'package:utl_mackay_irb/resources/ble_uuid.dart';

class MackayIRBBLETaskUseCase {
  BLEDevice bleDevice;
  BLEMackayIRBService bleMackayIRBService;
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
  setNextName(String name) {
    bleMackayIRBService.setDataNameBuffer(bleDevice, name);
  }
  _sendCommandToDevice(_BLEMackayIRBCommand command) {
    String code = "";
    switch(command) {
      case _BLEMackayIRBCommand.start:
        code = "6001";
        break;
    }
    bleSendPacketUseCase.sentCommandToCharacteristic(bleDevice, code);
  }
}

enum _BLEMackayIRBCommand {
  start,
}