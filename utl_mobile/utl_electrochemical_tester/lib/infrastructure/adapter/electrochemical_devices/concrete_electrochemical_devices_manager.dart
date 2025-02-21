import 'package:utl_electrochemical_tester/adapter/electrochemical_devices/dto/electrochemical_device_received_dto.dart';
import 'package:utl_electrochemical_tester/adapter/electrochemical_devices/dto/electrochemical_device_sent_dto.dart';
import 'package:utl_electrochemical_tester/adapter/electrochemical_devices/electrochemical_devices_manager.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/bluetooth/bluetooth_devices_handler.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/bluetooth/bluetooth_sent_packet.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/bluetooth/electrochemical_bluetooth_buffer.dart';
import 'package:utl_mobile/utl_bluetooth/fbp_utl_bluetooth_handler.dart';

class ConcreteElectrochemicalDevice implements ElectrochemicalDevice {
  final ConcreteBluetoothDevice concreteBluetoothDevice;
  ConcreteElectrochemicalDevice({
    required this.concreteBluetoothDevice,
  });
  static bool isConcreteElectrochemicalDevice(ConcreteBluetoothDevice device) {
    return device.bluetoothDevice.isConnected;
  }

  @override
  String get deviceId => concreteBluetoothDevice.deviceId;

  @override
  Future<bool> startCa({required CaElectrochemicalDeviceSentDto dto}) {
    ElectrochemicalBluetoothBuffer.setBuffer(
      dataName: dto.dataName,
      deviceId: deviceId,
      parameters: dto.electrochemicalParameters,
    );
    return concreteBluetoothDevice.write(BluetoothSentPacket.fromCa(dto: dto).data).then((value) => true);
  }

  @override
  Future<bool> startCv({required CvElectrochemicalDeviceSentDto dto}) {
    ElectrochemicalBluetoothBuffer.setBuffer(
      dataName: dto.dataName,
      deviceId: deviceId,
      parameters: dto.electrochemicalParameters,
    );
    return concreteBluetoothDevice.write(BluetoothSentPacket.fromCv(dto: dto).data).then((value) => true);
  }

  @override
  Future<bool> startDpv({required DpvElectrochemicalDeviceSentDto dto}) {
    ElectrochemicalBluetoothBuffer.setBuffer(
      dataName: dto.dataName,
      deviceId: deviceId,
      parameters: dto.electrochemicalParameters,
    );
    return concreteBluetoothDevice.write(BluetoothSentPacket.fromDpv(dto: dto).data).then((value) => true);
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
      .map((device) => ConcreteElectrochemicalDevice(concreteBluetoothDevice: device));
}
