import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_device.dart';
import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_sent_packet.dart';

abstract class ReceivedPacket implements Packet {
  BluetoothDevice get device;
}

class HeaderReceivedPacket extends ReceivedPacket {
  HeaderReceivedPacket({
    required this.data,
    required this.device,
  });

  @override
  Uint8List data;

  @override
  BluetoothDevice device;

  int get temperature => throw UnimplementedError();
}

class DataReceivedPacket extends ReceivedPacket {
  DataReceivedPacket({
    required this.data,
    required this.device,
  });

  @override
  Uint8List data;

  @override
  BluetoothDevice device;

  int get current => throw UnimplementedError();
  int get index => throw UnimplementedError();
  int get time => throw UnimplementedError();
  int get voltage => throw UnimplementedError();
}