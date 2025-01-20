import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_basic_utils/basic/general_utils.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_persist_devices_util.dart';
import 'package:utl_mobile/utl_bluetooth/utl_bluetooth_handler.dart';

class FbpUtlBluetoothSharedResources<Device extends UtlBluetoothDevice, Packet> extends UtlBluetoothSharedResources<Device, Packet> {
  final StreamController<Packet> _onReceivedController = StreamController();
  FbpUtlBluetoothSharedResources({
    required super.toPacket,
    required super.sentUuid,
    required super.receivedUuid,
  });
}

class UtlBluetoothDevice {
  FbpUtlBluetoothSharedResources resource;
  Iterable<String> get sentUuid => resource.sentUuid;
  Iterable<String> get receivedUuid => resource.receivedUuid;
  UtlBluetoothDevice({
    required this.resource,
    required this.bluetoothDevice,
  }) {
    _onConnection = bluetoothDevice.connectionState.listen(_handleConnectionState);
  }
  final BluetoothDevice bluetoothDevice;
  List<BluetoothService> services = [];
  late final StreamSubscription<BluetoothConnectionState> _onConnection;
  final List<StreamSubscription<Uint8List>> _onReceivePackets = [];
  void _handleConnectionState(BluetoothConnectionState state) async {
    if (state == BluetoothConnectionState.connected) {
      try {
        _addServices(await bluetoothDevice.discoverServices());
      } catch(e) {}
    } else {
      _clearServices();
    }
  }
  void write(Uint8List bytes) {
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (sentUuid.contains(characteristic.uuid.str)) {
          characteristic.write(bytes);
        }
        for (var descriptor in characteristic.descriptors) {
          if (sentUuid.contains(descriptor.uuid.str)) {
            descriptor.write(bytes);
          }
        }
      }
    }
  }
  void _addServices(List<BluetoothService> services) async {
    this.services = services;
    try {
      for (var service in this.services) {
        for (var characteristic in service.characteristics) {
          if (receivedUuid.contains(characteristic.uuid.str)) {
            await characteristic.setNotifyValue(true);
            _onReceivePackets.add(characteristic.onValueReceived.map((data) => data.asUint8List()).listen((data) {
              resource._onReceivedController.add(resource.toPacket(
                this,
                data,
              ));
            }));
          }
          for (var descriptor in characteristic.descriptors) {
            if (receivedUuid.contains(descriptor.uuid.str)) {
              _onReceivePackets.add(characteristic.onValueReceived.map((data) => data.asUint8List()).listen((data) {
                resource._onReceivedController.add(resource.toPacket(
                  this,
                  data,
                ));
              }));
            }
          }
        }
      }
    } catch(e) {}
  }
  void _clearServices() {
    for(var r in _onReceivePackets) {
      r.cancel();
    }
    _onReceivePackets.clear();
    services = [];
  }
}

class FbpUtlBluetoothHandler<
        Device extends UtlBluetoothDevice,
        Packet,
        Resources extends FbpUtlBluetoothSharedResources<Device, Packet>
    >
    extends FlutterBluePlusPersistDevicesProvider<Device>
    implements UtlBluetoothHandler<Device, Packet>
{
  final Resources resources;
  FbpUtlBluetoothHandler({
    required List<BluetoothDevice> devices,
    required this.resources,
    required Device Function(Resources, BluetoothDevice) bluetoothDeviceToDevice,
    required Device Function(Resources, ScanResult) resultToDevice,
  }) : super(
    isExistingDevice: (result, device) => result.device == device.bluetoothDevice,
    devices: devices.map((d) => bluetoothDeviceToDevice(resources, d)).toList(),
    resultToDevice: (r) => resultToDevice(resources, r),
  );
  @override
  sendBytes(Uint8List bytes) {
    for(var d in devices.where((device) => device.bluetoothDevice.isConnected)) {
      d.write(bytes);
    }
  }
  @override
  sendHexString(String hexString) {
    for(var d in devices.where((device) => device.bluetoothDevice.isConnected)) {
      d.write(hexString.hexToUint8List());
    }
  }
  @override
  Stream<Packet> get onReceivePacket => resources._onReceivedController.stream;
}
