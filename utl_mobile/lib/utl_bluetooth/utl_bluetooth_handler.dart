import 'dart:async';
import 'dart:typed_data';

abstract class UtlBluetoothHandler<Device, Packet> {
  UtlBluetoothHandler({
    Iterable<String> inputUuid = const [],
    Iterable<String> outputUuid = const [],
  });
  Iterable<Device> get devices;
  sendBytes(Uint8List bytes);
  sendHexString(String string);
  Stream<Packet> get onReceivePacket;
}

class UtlBluetoothSharedResources<Device, Packet> {
  final Iterable<String> sentUuid;
  final Iterable<String> receivedUuid;
  final Packet Function(Device, Uint8List) toPacket;
  UtlBluetoothSharedResources({
    required this.toPacket,
    required this.sentUuid,
    required this.receivedUuid,
  });
}
