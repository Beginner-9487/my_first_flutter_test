import 'dart:typed_data';

import 'package:utl_amulet/adapter/amulet_device/dto/amulet_device_data_dto.dart';
import 'package:utl_amulet/domain/entity/amulet_entity.dart';

class BluetoothReceivedPacket {
  const BluetoothReceivedPacket({
    required this.deviceId,
    required this.deviceName,
    required this.data,
  });
  final String deviceId;
  final String deviceName;
  final Uint8List data;
  @override
  String toString() {
    return "BluetoothReceivedPacket: "
        "\n\tdeviceId: $deviceId"
        "\n\tdeviceName: $deviceName"
        "\n\tdata: $data"
    ;
  }
  AmuletDeviceDataDto? mapToData() {
    if(data.length != 50) return null;
    final bytes = ByteData.sublistView(data);
    return AmuletDeviceDataDto(
      deviceId: deviceId,
      time: DateTime.now(),
      accX: bytes.getInt16(0, Endian.little),
      accY: bytes.getInt16(2, Endian.little),
      accZ: bytes.getInt16(4, Endian.little),
      accTotal: bytes.getUint16(6, Endian.little),
      magX: bytes.getInt16(14, Endian.little),
      magY: bytes.getInt16(16, Endian.little),
      magZ: bytes.getInt16(18, Endian.little),
      magTotal: bytes.getUint16(20, Endian.little),
      pitch: bytes.getInt16(10, Endian.little),
      roll: bytes.getInt16(8, Endian.little),
      yaw: bytes.getInt16(12, Endian.little),
      pressure: bytes.getFloat32(38, Endian.little),
      temperature: bytes.getUint16(24, Endian.little),
      posture: AmuletPostureType.values[bytes.getUint8(26)],
      adc: bytes.getInt16(30, Endian.little),
      battery: bytes.getUint8(32),
      area: bytes.getUint8(33),
      step: bytes.getInt16(34, Endian.little),
      direction: bytes.getUint8(29),
    );
  }
}
