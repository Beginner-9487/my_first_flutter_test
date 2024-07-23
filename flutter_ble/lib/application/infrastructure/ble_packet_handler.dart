import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/domain/ble_repository_impl_fbp.dart';

abstract class BLECommandSentPacketHandler {
  sentCommandToCharacteristic(BLECharacteristic bleCharacteristic, String command);
  sentCommandToDescriptor(BLEDescriptor descriptor, String command);
}

class BLECommandSentPacketHandlerImplFBP implements BLECommandSentPacketHandler {
  @override
  sentCommandToCharacteristic(BLECharacteristic bleCharacteristic, String command) {
    bleCharacteristic.writeData(BLEPacketImplFBP.createByHexString(command));
  }
  @override
  sentCommandToDescriptor(BLEDescriptor descriptor, String command) {
    descriptor.writeData(BLEPacketImplFBP.createByHexString(command));
  }
}

abstract class BLEReceivedPacketHandler<Packet extends BLEPacket, Output> {
  Output parsePacketFromCharacteristic(BLECharacteristic bleCharacteristic, Packet receivedPacket);
  Output parsePacketFromDescriptor(BLEDescriptor descriptor, Packet receivedPacket);
}