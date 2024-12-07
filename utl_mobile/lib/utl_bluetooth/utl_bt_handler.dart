import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bt/bt.dart';

abstract class UTL_BT_Handler {
  UTL_BT_Handler({
    required BT_Provider provider,
    Iterable<String> input_UUID = const [],
    Iterable<String> output_UUID = const [],
  });
  BT_Provider get bt_provider;
  Future connect(BT_Device device);
  Future disconnect(BT_Device device);
  Future sendBytes(Uint8List bytes);
  Future sendHexString(String hexString);
  StreamSubscription<BT_Packet_Characteristic> onReceivePacket(void Function(BT_Packet_Characteristic packet) onReceivedPacket);
}