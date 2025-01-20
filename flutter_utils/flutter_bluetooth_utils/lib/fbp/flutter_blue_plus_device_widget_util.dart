import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_persist_devices_util.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_widget_util.dart';

class FlutterBluePlusDeviceWidgetUtil {
  FlutterBluePlusDeviceWidgetUtil({
    required this.bluetoothDevice,
    this.handleExistedResult,
    bool isConnectable = false,
    int rssi = 0,
  })
      : isConnectableValueNotifier = ValueNotifier(isConnectable),
        rssiValueNotifier = ValueNotifier(rssi);
  final BluetoothDevice bluetoothDevice;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is FlutterBluePlusDeviceWidgetUtil && runtimeType == other.runtimeType && bluetoothDevice == other.bluetoothDevice);
  String get deviceName => bluetoothDevice.platformName;
  String get deviceId => bluetoothDevice.remoteId.str;
  set isConnectable(bool isConnectable) => isConnectableValueNotifier.value = isConnectable;
  set rssi(int rssi) => rssiValueNotifier.value = rssi;
  final ValueNotifier<bool> isConnectableValueNotifier;
  final ValueNotifier<int> rssiValueNotifier;
  factory FlutterBluePlusDeviceWidgetUtil.resultToDevice(ScanResult result) {
    return FlutterBluePlusDeviceWidgetUtil(
      bluetoothDevice: result.device,
      isConnectable: result.advertisementData.connectable,
      rssi: result.rssi,
    );
  }
  bool isExistingDevice(ScanResult result) {
    return result.device == bluetoothDevice;
  }
  final void Function(ScanResult result)? handleExistedResult;
  void _onExistingDeviceUpdated(ScanResult result) {
    isConnectable = result.advertisementData.connectable;
    rssi = result.rssi;
    handleExistedResult?.call(result);
  }
  Widget buildConnectionWidget({
    required Widget Function(BuildContext context, bool isConnectable, bool isConnected) builder,
  }) {
    return ValueListenableBuilder(
      valueListenable: isConnectableValueNotifier,
      builder: (context, isConnectable, child) {
        return FlutterBluePlusWidgetUtil.buildIsConnectedWidget(
          bluetoothDevice: bluetoothDevice,
          builder: (context, isConnected) => builder(
            context,
            isConnectable,
            isConnected,
          ),
        );
      },
    );
  }
  Widget buildRssiText() {
    return ValueListenableBuilder(
      valueListenable: rssiValueNotifier,
      builder: (context, rssi, child) {
        return Text(rssi.toString());
      },
    );
  }
  Future toggleConnection() {
    if(!isConnectableValueNotifier.value) Future.value();
    return FlutterBluePlusWidgetUtil.toggleConnection(
      device: bluetoothDevice,
    );
  }
}

class FlutterBluePlusPersistDeviceWidgetUtilsProvider<Device extends FlutterBluePlusDeviceWidgetUtil> extends FlutterBluePlusPersistDevicesProvider<Device> {
  FlutterBluePlusPersistDeviceWidgetUtilsProvider({
    required super.devices,
    required super.resultToDevice,
    super.onFinalUpdate,
    super.onNewDeviceDetected,
    void Function(ScanResult result, Device device)? onExistingDeviceUpdated,
  }) : super(
    isExistingDevice: (result, device) => device.isExistingDevice(result),
    onExistingDeviceUpdated: (result, device) {
      device._onExistingDeviceUpdated(result);
      onExistingDeviceUpdated?.call(result, device);
    },
  );
  Timer readRssi({
    required Duration duration,
    int timeout = 15,
  }) {
    return Timer.periodic(duration, (timer) {
      for(var d in devices.where((d) => d.bluetoothDevice.isConnected)) {
        Future.sync(() async {
          try {
            d.rssi = await d.bluetoothDevice.readRssi(timeout: timeout);
          } catch(e) {}
        });
      }
    });
  }
}
