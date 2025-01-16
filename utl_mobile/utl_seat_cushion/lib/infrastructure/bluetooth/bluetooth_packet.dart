import 'dart:typed_data';

class BluetoothPacket {
  final Uint8List data;
  final String deviceId;
  BluetoothPacket({
    required this.data,
    required this.deviceId,
  });
}
