import 'dart:async';

import 'package:flutter_bt/bt.dart';
import 'package:flutter_utility/bytes_converter.dart';
import 'package:utl_hands/application/domain/hand_repository.dart';
import 'package:utl_hands/application/domain/hand_repository_impl.dart';
import 'package:utl_mobile/utl_bluetooth_handler.dart';

class BT_Packet_To_Hand {
  static String get OUTPUT_UUID => "6e400003-b5a3-f393-e0a9-e50e24dcca9e";
  BT_Packet_To_Hand(
      this.utl_bt_controller,
      this.initTime,
      this.handRepository,
  ) {
    onReceived = utl_bt_controller.onReceived(addToRepository);
  }
  UTL_BT_Controller utl_bt_controller;
  DateTime initTime;
  HandRepositoryImpl handRepository;
  late StreamSubscription<BT_Packet_Characteristic> onReceived;
  addToRepository(BT_Packet_Characteristic packet) {
    bool isRight = packet.raw.first == 0x0B;
    double time = (DateTime.now().microsecondsSinceEpoch - initTime.microsecondsSinceEpoch) / 1000000.0;
    double x0 = BytesConverter.byteArrayToUint16([packet.raw.skip(1).first, packet.raw.skip(2).first], little: false).toDouble();
    double y0 = BytesConverter.byteArrayToUint16([packet.raw.skip(3).first, packet.raw.skip(4).first], little: false).toDouble();
    double z0 = BytesConverter.byteArrayToUint16([packet.raw.skip(5).first, packet.raw.skip(6).first], little: false).toDouble();
    double x1 = BytesConverter.byteArrayToUint16([packet.raw.skip(7).first, packet.raw.skip(8).first], little: false).toDouble();
    double y1 = BytesConverter.byteArrayToUint16([packet.raw.skip(9).first, packet.raw.skip(10).first], little: false).toDouble();
    double z1 = BytesConverter.byteArrayToUint16([packet.raw.skip(11).first, packet.raw.skip(12).first], little: false).toDouble();
    handRepository.add(isRight, time, x0, y0, z0, x1, y1, z1);
  }
}