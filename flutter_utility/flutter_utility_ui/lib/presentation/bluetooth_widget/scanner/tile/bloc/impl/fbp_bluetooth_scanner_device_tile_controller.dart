import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/bloc/bluetooth_scanner_device_tile_bloc.dart';

class FbpBluetoothScannerDeviceTileController with EquatableMixin implements BluetoothScannerDeviceTileController {
  FbpBluetoothScannerDeviceTileController({
    required this.bluetoothDevice,
    required bool isConnectable,
    required int rssi,
  })
      :
        _isConnectable = isConnectable,
        _rssi = rssi
  ;

  factory FbpBluetoothScannerDeviceTileController.createByBluetoothDevice({
    required BluetoothDevice bluetoothDevice,
    required bool isConnectable,
    required int rssi,
  }) {
    return FbpBluetoothScannerDeviceTileController(
        bluetoothDevice: bluetoothDevice,
        isConnectable: isConnectable,
        rssi: rssi,
    );
  }

  factory FbpBluetoothScannerDeviceTileController.createByScanResult({
    required ScanResult scanResult,
  }) {
    return FbpBluetoothScannerDeviceTileController(
      bluetoothDevice: scanResult.device,
      isConnectable: scanResult.advertisementData.connectable,
      rssi: scanResult.rssi,
    );
  }

  BluetoothDevice bluetoothDevice;

  final StreamController<bool> _onConnectableStateChange = StreamController();
  final StreamController<int> _onRssiChange = StreamController();

  @override
  String get id => bluetoothDevice.remoteId.str;

  @override
  String get name => bluetoothDevice.platformName;

  @override
  Future<bool> connect() {
    return bluetoothDevice.connect().then((value) => true);
  }

  @override
  Future<bool> disconnect() {
    return bluetoothDevice.disconnect().then((value) => true);
  }

  bool _isConnectable;

  @override
  bool get isConnectable => _isConnectable;

  set isConnectable(bool isConnectable) {
    _isConnectable = isConnectable;
    _onConnectableStateChange.sink.add(isConnectable);
  }

  int _rssi;

  @override
  int get rssi => _rssi;

  set rssi(int rssi) {
    _rssi = rssi;
    _onRssiChange.sink.add(rssi);
  }

  @override
  bool get isConnected => bluetoothDevice.isConnected;

  @override
  Stream<bool> get onConnectableStateChange => _onConnectableStateChange.stream;

  @override
  Stream<bool> get onConnectionStateChange => bluetoothDevice.connectionState.map((event) => event == BluetoothConnectionState.connected);

  @override
  Stream<int> get onRssiChange => _onRssiChange.stream;

  @override
  List<Object?> get props => [bluetoothDevice];

}