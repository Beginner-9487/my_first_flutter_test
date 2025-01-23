import 'dart:async';

import 'package:utl_electrochemical_tester/infrastructure/source/bluetooth/bluetooth_packet_handler.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/bluetooth/bluetooth_received_packet.dart';
import 'package:utl_electrochemical_tester/resources/bluetooth_resources.dart';
import 'package:utl_mobile/utl_bluetooth/fbp_utl_bluetooth_handler.dart';

class _Resources extends FbpUtlBluetoothSharedResources<UtlBluetoothDevice, BluetoothReceivedPacket> {
  _Resources({
    required super.sentUuid,
    required super.receivedUuid,
  }) : super(
    toPacket: (device, data) => BluetoothReceivedPacket(
      data: data,
      deviceName: device.bluetoothDevice.platformName,
      deviceId: device.bluetoothDevice.remoteId.str,
    ),
  );
}

class BluetoothDevicesHandler extends FbpUtlBluetoothHandler<UtlBluetoothDevice, BluetoothReceivedPacket, _Resources>  {
  final BluetoothPacketHandler bluetoothPacketHandler;
  BluetoothDevicesHandler({
    required super.devices,
    required this.bluetoothPacketHandler,
  }) : super(
    resources: _Resources(
      sentUuid: BluetoothResources.sentUuids,
      receivedUuid: BluetoothResources.receivedUuids,
    ),
    bluetoothDeviceToDevice: (resource, bluetoothDevice) => UtlBluetoothDevice(
      resource: resource,
      bluetoothDevice: bluetoothDevice,
    ),
    resultToDevice: (resource, result) => UtlBluetoothDevice(
      resource: resource,
      bluetoothDevice: result.device,
    ),
  ) {
    _receivePacket = onReceivePacket.listen((packet) {
      bluetoothPacketHandler.handleReceivedPacket(packet: packet);
    });
  }
  late final StreamSubscription<BluetoothReceivedPacket> _receivePacket;
  @override
  void dispose() {
    _receivePacket.cancel();
    super.dispose();
  }
}
