import 'package:flutter_ble/application/domain/ble_repository.dart';

class CheckBLEPacket {
  static const int TYPE1_LENGTH = 20;
  static bool isPacketCorrect(BLEPacket packet) {
    return packet.raw.length == TYPE1_LENGTH;
  }
}