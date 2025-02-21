import 'dart:typed_data';

class BluetoothSentPacket {
  Uint8List data;
  BluetoothSentPacket({
    required this.data,
  });
  @override
  String toString() {
    return "BluetoothSentPacket: "
        "\n\tdata: $data"
    ;
  }
}
