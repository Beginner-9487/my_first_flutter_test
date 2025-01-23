import 'dart:typed_data';

class ElectrochemicalSensorReceivedPacket {
  const ElectrochemicalSensorReceivedPacket({
    required this.deviceName,
    required this.deviceId,
    required this.data,
  });
  final String deviceName;
  final String deviceId;
  final Uint8List data;
}

class HeaderReceivedPacket extends ElectrochemicalSensorReceivedPacket {
  HeaderReceivedPacket({
    required super.deviceName,
    required super.deviceId,
    required super.data,
  }) {
    ByteData byteData = ByteData.sublistView(data);
    temperature = byteData.getInt32(2, Endian.little);
  }

  static bool check(Uint8List data) {
    return data.length == 6 && data[0] == 0x02 && data[1] == 0x01;
  }

  late final int temperature;

  factory HeaderReceivedPacket.getByUtlPacket(ElectrochemicalSensorReceivedPacket packet) {
    return HeaderReceivedPacket(
      data: packet.data,
      deviceName: packet.deviceName,
      deviceId: packet.deviceId,
    );
  }
}

class DataReceivedPacket extends ElectrochemicalSensorReceivedPacket {
  DataReceivedPacket({
    required super.deviceName,
    required super.deviceId,
    required super.data,
  }) {
    ByteData byteData = ByteData.sublistView(data);
    index = byteData.getInt16(2, Endian.little);
    time = byteData.getInt32(4, Endian.little);
    voltage = byteData.getInt32(8, Endian.little);
    current = byteData.getInt32(12, Endian.little);
  }

  factory DataReceivedPacket.getByUtlPacket(ElectrochemicalSensorReceivedPacket packet) {
    return DataReceivedPacket(
      data: packet.data,
      deviceName: packet.deviceName,
      deviceId: packet.deviceId,
    );
  }

  static bool check(Uint8List data) {
    return data.length == 16 && data[0] == 0x02 && data[1] == 0x02;
  }

  late final int index;
  late final int time;
  late final int voltage;
  late final int current;
}