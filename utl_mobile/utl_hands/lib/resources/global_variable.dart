import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:utl_hands/application/domain/hand_repository.dart';
import 'package:utl_hands/application/service/ble_packet_to_hand.dart';

class GlobalVariable {
  static init(
      DateTime initTime,
      BLERepository bleRepository,
      BLEPacketToHand blePacketToHand,
      HandRepository handRepository,
  ) {
    GlobalVariable.initTime = initTime;
    GlobalVariable.bleRepository = bleRepository;
    GlobalVariable.blePacketToHand = blePacketToHand;
    GlobalVariable.handRepository = handRepository;
  }
  static late DateTime initTime;
  static late BLERepository bleRepository;
  static late BLEPacketToHand blePacketToHand;
  static late HandRepository handRepository;
}