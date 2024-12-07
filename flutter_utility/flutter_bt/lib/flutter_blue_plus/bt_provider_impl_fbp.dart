import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bt/bt.dart';
import 'package:flutter_bt/flutter_blue_plus/bt_device_impl_fbp.dart';

class BT_Provider_Impl_FBP implements BT_Provider {
  BT_Provider_Impl_FBP._();
  static late final BT_Provider_Impl_FBP _instance;
  static BT_Provider_Impl_FBP init() {
    _instance = BT_Provider_Impl_FBP._();

    _onScanResult = FlutterBluePlus.scanResults.listen(_scanResultOnData);

    _onFoundNewDevice = StreamController.broadcast();
    _onScanDevices = StreamController.broadcast();

    FlutterBluePlus.systemDevices.then((value) async {
      systemDevices = value.map((e) => BT_Device_Impl_FBP(
          provider: _instance,
          device: e,
      )).toList();
    });

    return _instance;
  }

  static List<ScanResult> scanResults = [];
  static late StreamSubscription<List<ScanResult>> _onScanResult;
  static void _scanResultOnData(List<ScanResult> results) async {
    scanResults = results;
    final List<BT_Device_Impl_FBP> devices = [];
    for (var result in results) {
      BT_Device_Impl_FBP? systemDevice = systemDevices
          .where((element) => element.device == result.device)
          .firstOrNull;
      systemDevice?.updateIsConnectable(result.advertisementData.connectable);
      systemDevice?.updateRssi(result.rssi);
      if(systemDevice == null) {
        systemDevice = BT_Device_Impl_FBP(
          provider: _instance,
          device: result.device,
          isConnectable: result.advertisementData.connectable,
          rssi: result.rssi,
        );
        systemDevices.add(systemDevice);
        _onFoundNewDevice.add(systemDevice);
      }
      devices.add(systemDevice);
    }
    _onScanDevices.add(devices);
  }

  static late final StreamController<BT_Device_Impl_FBP> _onFoundNewDevice;
  static late final StreamController<Iterable<BT_Device_Impl_FBP>> _onScanDevices;

  @override
  bool get isBluetoothOn => FlutterBluePlus.adapterStateNow == BluetoothAdapterState.on;
  @override
  bool get isScanning => FlutterBluePlus.isScanningNow;

  static late final List<BT_Device_Impl_FBP> systemDevices;
  @override
  Iterable<BT_Device_Impl_FBP> get devices => systemDevices;

  @override
  Future<void> turnOn() async {
    return FlutterBluePlus.turnOn();
  }
  @override
  Future<void> turnOff() async {
    return FlutterBluePlus.turnOff();
  }
  @override
  Future<void> scanOn({double duration = 15}) async {
    if(FlutterBluePlus.isScanningNow) {return;}
    try {
      // android is slow when asking for all advertisements,
      // so instead we only ask for 1/8 of them
      int divisor = Platform.isAndroid ? 8 : 1;
      return FlutterBluePlus.startScan(
          timeout: Duration(
              microseconds: (duration * 1000000).toInt(),
          ),
          continuousUpdates: true,
          continuousDivisor: divisor
      );
    } catch (e) {
      debugPrint("ERROR: scanOn: $e");
    }
  }
  @override
  Future<void> scanOff() async {
    try {
      return FlutterBluePlus.stopScan();
    } catch (e) {
      debugPrint("ERROR: scanOff: $e");
    }
  }
  @override
  StreamSubscription<bool> onAdapterStateChange(
      void Function(bool state) onAdapterStateChange
  ) {
    return FlutterBluePlus
        .adapterState
        .map((event) => event == BluetoothAdapterState.on)
        .listen(onAdapterStateChange);
  }
  @override
  StreamSubscription<bool> onScanningStateChange(
      void Function(bool state) onScanningStateChange
  ) {
    return FlutterBluePlus
        .isScanning
        .listen(onScanningStateChange);
  }
  @override
  StreamSubscription<BT_Device> onFoundNewDevice(void Function(BT_Device device) onNewDevicesFounded) {
    return _onFoundNewDevice
        .stream
        .listen(onNewDevicesFounded);
  }
  @override
  StreamSubscription<Iterable<BT_Device_Impl_FBP>> onScanDevices(
      void Function(Iterable<BT_Device_Impl_FBP> devices) onScannedDevicesFounded
  ) {
    return _onScanDevices
        .stream
        .listen(onScannedDevicesFounded);
  }
}
