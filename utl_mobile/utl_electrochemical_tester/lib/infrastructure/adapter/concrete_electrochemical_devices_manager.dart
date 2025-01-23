import 'package:utl_electrochemical_tester/adapter/dto/electrochemical_device_received_dto.dart';
import 'package:utl_electrochemical_tester/adapter/dto/electrochemical_device_sent_dto.dart';
import 'package:utl_electrochemical_tester/adapter/electrochemical_devices_manager.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/bluetooth/bluetooth_devices_handler.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/bluetooth/bluetooth_sent_packet.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/bluetooth/electrochemical_bluetooth_buffer.dart';
import 'package:utl_mobile/utl_bluetooth/fbp_utl_bluetooth_handler.dart';

class ConcreteElectrochemicalDevice implements ElectrochemicalDevice {
  final UtlBluetoothDevice utlBluetoothDevice;
  ConcreteElectrochemicalDevice({
    required this.utlBluetoothDevice,
  });
  static bool isConcreteElectrochemicalDevice(UtlBluetoothDevice device) {
    return true;
  }

  @override
  String get deviceId => utlBluetoothDevice.deviceId;

  @override
  Future<bool> startCa({required CaElectrochemicalDeviceSentDto dto}) {
    ElectrochemicalBluetoothBuffer.setBuffer(
      dataName: dto.dataName,
      deviceId: deviceId,
      parameters: dto.electrochemicalParameters,
    );
    return utlBluetoothDevice.write(BluetoothSentPacket.fromCa(dto: dto).data).then((value) => true);
  }

  @override
  Future<bool> startCv({required CvElectrochemicalDeviceSentDto dto}) {
    ElectrochemicalBluetoothBuffer.setBuffer(
      dataName: dto.dataName,
      deviceId: deviceId,
      parameters: dto.electrochemicalParameters,
    );
    return utlBluetoothDevice.write(BluetoothSentPacket.fromCv(dto: dto).data).then((value) => true);
  }

  @override
  Future<bool> startDpv({required DpvElectrochemicalDeviceSentDto dto}) {
    ElectrochemicalBluetoothBuffer.setBuffer(
      dataName: dto.dataName,
      deviceId: deviceId,
      parameters: dto.electrochemicalParameters,
    );
    return utlBluetoothDevice.write(BluetoothSentPacket.fromDpv(dto: dto).data).then((value) => true);
  }
}

class ConcreteElectrochemicalDevicesManager implements ElectrochemicalDevicesManager {
  final BluetoothDevicesHandler bluetoothHandler;
  ConcreteElectrochemicalDevicesManager({
    required this.bluetoothHandler,
  });

  @override
  Stream<ElectrochemicalDeviceReceivedDataDto> get dataStream => bluetoothHandler.bluetoothPacketHandler.electrochemicalDataStream;

  @override
  Stream<ElectrochemicalDeviceReceivedHeaderDto> get headerStream => bluetoothHandler.bluetoothPacketHandler.electrochemicalHeaderStream;

  @override
  Iterable<ConcreteElectrochemicalDevice> get devices => bluetoothHandler.devices
      .where(ConcreteElectrochemicalDevice.isConcreteElectrochemicalDevice)
      .map((device) => ConcreteElectrochemicalDevice(utlBluetoothDevice: device));
}
