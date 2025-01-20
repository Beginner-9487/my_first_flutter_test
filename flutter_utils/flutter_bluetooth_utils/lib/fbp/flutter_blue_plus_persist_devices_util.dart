import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class _DevicesValueNotifier<Device> extends ValueNotifier<List<Device>> {
  _DevicesValueNotifier(super.value);
  @override
  void notifyListeners() => super.notifyListeners();
}

class FlutterBluePlusPersistDevicesProvider<Device> {
  final _DevicesValueNotifier<Device> _devicesValueNotifier;
  ValueNotifier<List<Device>> get devicesValueNotifier => _devicesValueNotifier;
  List<Device> get devices => _devicesValueNotifier.value;
  final bool Function(ScanResult result, Device device) isExistingDevice;
  final Device Function(ScanResult result) resultToDevice;
  final void Function(ScanResult result, Device device)? onNewDeviceDetected;
  final void Function(ScanResult result, Device device)? onExistingDeviceUpdated;
  final void Function(List<Device> updatedDevices)? onFinalUpdate;
  FlutterBluePlusPersistDevicesProvider({
    required List<Device> devices,
    required this.isExistingDevice,
    required this.resultToDevice,
    this.onNewDeviceDetected,
    this.onExistingDeviceUpdated,
    this.onFinalUpdate,
  }) :
        _devicesValueNotifier = _DevicesValueNotifier(devices),
        _onScanResult = FlutterBluePlus.scanResults.listen((results) {})
  {
    _onScanResult.onData(_updateResults);
  }
  final StreamSubscription<List<ScanResult>> _onScanResult;
  void _updateResults(List<ScanResult> results) {
    for (var result in results) {
      Device? device = devices
        .where((device) => isExistingDevice(result, device))
        .firstOrNull;
      if(device == null) {
        device = resultToDevice(result);
        devices.add(device as Device);
        onNewDeviceDetected?.call(result, device);
        _devicesValueNotifier.notifyListeners();
      } else {
        onExistingDeviceUpdated?.call(result, device);
      }
      onFinalUpdate?.call(devices);
    }
  }
  Widget buildDevicesList({
    required Widget? Function(BuildContext context, Device device) builder,
    bool Function(Device device)? filter,
  }) {
    filter = filter ?? (device) => true;
    return ValueListenableBuilder(
      valueListenable: _devicesValueNotifier,
      builder: (BuildContext context, List<Device> devices, Widget? child) {
        Iterable<Device> list = devices.where(filter!);
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) => builder(context, list.skip(index).first),
        );
      },
    );
  }
  @mustCallSuper
  void dispose() {
    _onScanResult.cancel();
    _devicesValueNotifier.dispose();
  }
}
