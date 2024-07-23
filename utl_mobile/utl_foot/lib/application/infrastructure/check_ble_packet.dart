import 'package:flutter_ble/application/domain/ble_repository.dart';

class CheckBLEPacketFoot {
  static const int TYPE1_LENGTH = 242;
  static const int TYPE2_LENGTH = 25;
  static bool isPacketCorrect(BLEPacket packet) {
    return packet.raw.length == TYPE1_LENGTH || packet.raw.length == TYPE2_LENGTH;
  }
}