import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/bloc/bluetooth_scanner_bloc.dart';

class FbpBluetoothScannerController<Device> implements BluetoothScannerController<Device> {
  static late final Iterable<BluetoothDevice> Function() _getDevices;
  static final StreamController<ScanResult> _onFoundNewDevice = StreamController();
  static void init({
    required Iterable<BluetoothDevice> Function() getDevices,
  }) {
    _getDevices = getDevices;
  }
  static void updateDevice(ScanResult result) {
    _onFoundNewDevice.add(result);
  }
  FbpBluetoothScannerController({
    required this.scanDuration,
    required this.bluetoothDeviceToDevice,
    required this.scanResultToDevice,
  });
  final Device Function(BluetoothDevice) bluetoothDeviceToDevice;
  final Device Function(ScanResult) scanResultToDevice;
  Duration scanDuration;
  @override
  Iterable<Device> get devices => _getDevices().map(bluetoothDeviceToDevice);
  @override
  bool get isEnable => FlutterBluePlus.adapterStateNow == BluetoothAdapterState.on;
  @override
  bool get isScanning => FlutterBluePlus.isScanningNow;
  @override
  Future<void> scanRefresh() async {
    return scanOff().then((data) => scanOn());
  }
  @override
  Future<void> scanOn() async {
    if(FlutterBluePlus.isScanningNow) {return;}
    try {
      // android is slow when asking for all advertisements,
      // so instead we only ask for 1/8 of them
      int divisor = Platform.isAndroid ? 8 : 1;
      return FlutterBluePlus.startScan(
          timeout: scanDuration,
          continuousUpdates: true,
          continuousDivisor: divisor
      );
    } catch (e) {
      debugPrint("ERROR: scanOn: $e");
      return;
    }
  }
  @override
  Future<void> scanOff() async {
    try {
      return FlutterBluePlus.stopScan();
    } catch (e) {
      debugPrint("ERROR: scanOff: $e");
      return;
    }
  }
  @override
  Stream<bool> get onEnableStateChange => FlutterBluePlus
      .adapterState
      .map((event) => event == BluetoothAdapterState.on);

  @override
  Stream<Device> get onFoundNewDevice => _onFoundNewDevice
      .stream
      .map(scanResultToDevice);

  @override
  Stream<bool> get onScanningStateChange => FlutterBluePlus
      .isScanning;

}
