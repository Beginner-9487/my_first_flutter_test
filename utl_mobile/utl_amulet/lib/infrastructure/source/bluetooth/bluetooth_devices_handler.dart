import 'package:utl_amulet/infrastructure/source/bluetooth/bluetooth_received_packet.dart';
import 'package:utl_amulet/init/resources/infrastructure/bluetooth_resource.dart';
import 'package:utl_mobile/utl_bluetooth/fbp_utl_bluetooth_handler.dart';

class _Resources extends FbpUtlBluetoothSharedResources<ConcreteBluetoothDevice, BluetoothReceivedPacket> {
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

class ConcreteBluetoothDevice extends UtlBluetoothDevice<ConcreteBluetoothDevice, BluetoothReceivedPacket> {
  ConcreteBluetoothDevice({required super.resource, required super.bluetoothDevice});
}

class BluetoothDevicesHandler extends FbpUtlBluetoothHandler<ConcreteBluetoothDevice, BluetoothReceivedPacket, _Resources>  {
  BluetoothDevicesHandler({
    required super.devices,
  }) : super(
    resources: _Resources(
      sentUuid: BluetoothResource.sentUuids,
      receivedUuid: BluetoothResource.receivedUuids,
    ),
    bluetoothDeviceToDevice: (resource, bluetoothDevice) => ConcreteBluetoothDevice(
      resource: resource,
      bluetoothDevice: bluetoothDevice,
    ),
    resultToDevice: (resource, result) => ConcreteBluetoothDevice(
      resource: resource,
      bluetoothDevice: result.device,
    )
  );
}
