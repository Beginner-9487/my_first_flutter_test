import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/controller/bluetooth_scanner_controller.dart';

abstract class FbpBluetoothScannerControllerDevice {
  BluetoothDevice get bluetoothDevice;
}

class FbpBluetoothScannerController<Device extends FbpBluetoothScannerControllerDevice> implements BluetoothScannerController<Device> {
  @override
  late final List<Device> devices;
  final Device Function(BluetoothDevice device, FbpBluetoothScannerController controller) bluetoothDeviceToDevice;
  final Device Function(ScanResult device, FbpBluetoothScannerController controller) scanResultToDevice;
  final StreamController<Device> _onFoundNewDevice = StreamController.broadcast();
  FbpBluetoothScannerController({
    required this.bluetoothDeviceToDevice,
    required List<BluetoothDevice> devices,
    required this.scanResultToDevice,
    required this.scanDuration,
  }) {
    this.devices = devices.map((d) => bluetoothDeviceToDevice(d, this)).toList();
    _onScanResult = FlutterBluePlus.scanResults.listen(_scanResultOnData);
  }
  late final StreamSubscription<List<ScanResult>> _onScanResult;
  void _scanResultOnData(List<ScanResult> results) async {
    for (var result in results) {
      Device? device = devices
          .where((element) => element.bluetoothDevice == result.device)
          .firstOrNull;
      if(device == null) {
        device = scanResultToDevice(result, this);
        devices.add(device);
        _onFoundNewDevice.sink.add(device);
      }
    }
  }
  Duration scanDuration;
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
      .stream;

  @override
  Stream<bool> get onScanningStateChange => FlutterBluePlus
      .isScanning;
  void dispose() {
    _onFoundNewDevice.close();
    _onScanResult.cancel();
  }
}