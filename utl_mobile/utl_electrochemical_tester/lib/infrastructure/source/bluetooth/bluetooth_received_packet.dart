import 'dart:typed_data';

import 'package:utl_electrochemical_tester/adapter/electrochemical_devices/dto/electrochemical_device_received_dto.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/bluetooth/electrochemical_bluetooth_buffer.dart';

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
  ElectrochemicalDeviceReceivedHeaderDto? mapToHeader() {
    var dataName = ElectrochemicalBluetoothBuffer.getDataName(deviceId: deviceId);
    if(dataName == null) return null;
    var parameters = ElectrochemicalBluetoothBuffer.getParameters(deviceId: deviceId);
    if(parameters == null) return null;
    if(data.length != 6) return null;
    if(data[0] != 0x02) return null;
    if(data[1] != 0x01) return null;
    ByteData byteData = ByteData.sublistView(data);
    int temperature = byteData.getInt32(2, Endian.little);
    return ElectrochemicalDeviceReceivedHeaderDto(
      dataName: dataName,
      deviceId: deviceId,
      deviceName: deviceName,
      createdTime: DateTime.now(),
      parameters: parameters,
      temperature: temperature,
    );
  }
  ElectrochemicalDeviceReceivedDataDto? mapToData() {
    var entityId = ElectrochemicalBluetoothBuffer.getEntityId(deviceId: deviceId);
    if(entityId == null) return null;
    if(data.length != 16) return null;
    if(data[0] != 0x02) return null;
    if(data[1] != 0x02) return null;
    ByteData byteData = ByteData.sublistView(data);
    int index = byteData.getInt16(2, Endian.little);
    int time = byteData.getInt32(4, Endian.little);
    int voltage = byteData.getInt32(8, Endian.little);
    int current = byteData.getInt32(12, Endian.little);
    return ElectrochemicalDeviceReceivedDataDto(
      entityId: entityId,
      index: index,
      time: time,
      voltage: voltage,
      current: current,
    );
  }
}
