import 'dart:async';
import 'dart:typed_data';

class UtlReceivedBluetoothPacket {
  const UtlReceivedBluetoothPacket({
    required this.deviceName,
    required this.deviceId,
    required this.data,
  });
  final String deviceName;
  final String deviceId;
  final Uint8List data;
}

abstract class UtlBluetoothHandler<Device> {
  UtlBluetoothHandler({
    Iterable<String> inputUuid = const [],
    Iterable<String> outputUuid = const [],
  });
  Iterable<Device> get devices;
  sendBytes(Uint8List bytes);
  sendHexString(String string);
  Stream<UtlReceivedBluetoothPacket> get onReceivePacket;
}
