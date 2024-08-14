import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utl_hands/application/domain/hand_repository.dart';
import 'package:utl_hands/application/service/ble_packet_to_hand.dart';

class GlobalVariables {
  static init(
      DateTime initTime,
      BLERepository bleRepository,
      BLEPacketToHand blePacketToHand,
      HandRepository handRepository,
      SharedPreferences sharedPreferences,
      FlutterRingtonePlayer flutterRingTonePlayer,
  ) {
    GlobalVariables.initTime = initTime;
    GlobalVariables.bleRepository = bleRepository;
    GlobalVariables.blePacketToHand = blePacketToHand;
    GlobalVariables.handRepository = handRepository;
    GlobalVariables.sharedPreferences = sharedPreferences;
    GlobalVariables.flutterRingTonePlayer = flutterRingTonePlayer;
  }
  static late DateTime initTime;
  static late BLERepository bleRepository;
  static late BLEPacketToHand blePacketToHand;
  static late HandRepository handRepository;
  static late SharedPreferences sharedPreferences;
  static late FlutterRingtonePlayer flutterRingTonePlayer;
}