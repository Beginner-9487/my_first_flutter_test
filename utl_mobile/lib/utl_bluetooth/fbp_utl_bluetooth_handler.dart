import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_utility/general_utils.dart';
import 'package:utl_mobile/utl_bluetooth/utl_bluetooth_handler.dart';

class UtlBluetoothDevice {
  FbpUtlBluetoothHandler handler;
  Iterable<String> get sentUuid => handler.sentUuid;
  Iterable<String> get receivedUuid => handler.receivedUuid;
  UtlBluetoothDevice({
    required this.bluetoothDevice,
    required this.handler,
  }) {
    _onConnection = bluetoothDevice.connectionState.listen((state) {
      if(state == BluetoothConnectionState.connected) {
        bluetoothDevice.discoverServices().then(_addServices);
      } else {
        _clearServices();
      }
    });
  }
  final BluetoothDevice bluetoothDevice;
  late final StreamSubscription<BluetoothConnectionState> _onConnection;
  List<BluetoothService> services = [];
  final List<StreamSubscription<Uint8List>> _onReceivePackets = [];
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
  void _addServices(List<BluetoothService> services) {
    this.services = services;
    for (var service in this.services) {
      for (var characteristic in service.characteristics) {
        if (receivedUuid.contains(characteristic.uuid.str)) {
          characteristic.setNotifyValue(true);
          _onReceivePackets.add(characteristic.onValueReceived.map((data) => data.asUint8List()).listen((data) {
            handler._onReceivedController.add(UtlReceivedBluetoothPacket(
                deviceName: bluetoothDevice.platformName,
                deviceId: bluetoothDevice.remoteId.str,
                data: data,
            ));
          }));
        }
        for (var descriptor in characteristic.descriptors) {
          if (receivedUuid.contains(descriptor.uuid.str)) {
            _onReceivePackets.add(characteristic.onValueReceived.map((data) => data.asUint8List()).listen((data) {
              handler._onReceivedController.add(UtlReceivedBluetoothPacket(
                deviceName: bluetoothDevice.platformName,
                deviceId: bluetoothDevice.remoteId.str,
                data: data,
              ));
            }));
          }
        }
      }
    }
  }
  void _clearServices() {
    for(var r in _onReceivePackets) {
      r.cancel();
    }
    _onReceivePackets.clear();
    services = [];
  }
}

class FbpUtlBluetoothHandler<Device extends UtlBluetoothDevice> implements UtlBluetoothHandler<Device> {
  @override
  late final List<Device> devices;
  final Iterable<String> sentUuid;
  final Iterable<String> receivedUuid;
  final Device Function(BluetoothDevice device, FbpUtlBluetoothHandler handler) bluetoothDeviceToDevice;
  final Device Function(ScanResult device, FbpUtlBluetoothHandler handler) scanResultToDevice;
  FbpUtlBluetoothHandler({
    required this.bluetoothDeviceToDevice,
    required this.scanResultToDevice,
    required List<BluetoothDevice> devices,
    this.sentUuid = const [],
    this.receivedUuid = const [],
  }) {
    this.devices = devices.map((d) => bluetoothDeviceToDevice(d, this)).toList();
    _onScanResult = FlutterBluePlus.scanResults.listen(_scanResultOnData);
  }
  late final StreamSubscription<List<ScanResult>> _onScanResult;
  void _scanResultOnData(List<ScanResult> results) async {
    for (var result in results) {
      UtlBluetoothDevice? device = devices
          .where((element) => element.bluetoothDevice == result.device)
          .firstOrNull;
      if(device == null) {
        devices.add(scanResultToDevice(result, this));
      }
    }
  }
  final StreamController<UtlReceivedBluetoothPacket> _onReceivedController = StreamController();
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
  Stream<UtlReceivedBluetoothPacket> get onReceivePacket => _onReceivedController.stream;
}
