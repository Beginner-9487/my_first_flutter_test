import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class _DevicesValueNotifier<T> extends ValueNotifier<T> {
  _DevicesValueNotifier(super.value);
  void forceUpdate() {
    notifyListeners();
  }
}

class FlutterBluePlusPersistDevicesUtil<Device> {
  final List<Device> devices;
  final bool Function(ScanResult result, Device device) checkDeviceExisted;
  final Device Function(ScanResult result) resultToDevice;
  final void Function(ScanResult result, Device device)? handleExistedResult;
  FlutterBluePlusPersistDevicesUtil({
    required this.checkDeviceExisted,
    required this.devices,
    required this.resultToDevice,
    this.handleExistedResult,
  }) :
        _onScanResult = FlutterBluePlus.scanResults.listen((result) {}),
        _devicesValueNotifier = _DevicesValueNotifier(devices)
  {
    _onScanResult.onData(_updateResults);
  }
  final StreamSubscription<List<ScanResult>> _onScanResult;
  final _DevicesValueNotifier<List<Device>> _devicesValueNotifier;
  void _updateResults(List<ScanResult> results) async {
    for (var result in results) {
      Device? device = devices
        .where((device) => checkDeviceExisted(result, device))
        .firstOrNull;
      if(device == null) {
        device = resultToDevice(result);
        devices.add(device as Device);
        _devicesValueNotifier.forceUpdate();
      } else {
        handleExistedResult?.call(result, device);
      }
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
  void dispose() {
    _onScanResult.cancel();
    _devicesValueNotifier.dispose();
  }
}
