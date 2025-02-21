import 'dart:async';

import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_persist_devices_util.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_util.dart';
import 'package:flutter_bluetooth_utils/permission_handler_util/permission_handler_bluetooth_util.dart';

class UtlBluetoothIsScanningChangeNotifier extends FlutterBluePlusIsScanningChangeNotifier {}

class UtlBluetoothIsOnChangeNotifier extends FlutterBluePlusIsOnChangeNotifier {}

class UtlBluetoothDevicesWidgetProvider<Device extends FlutterBluePlusPersistDeviceUtil> extends FlutterBluePlusPersistDeviceUtils<Device> {
  UtlBluetoothDevicesWidgetProvider({
    required super.devices,
    required super.addNewDeviceHandler,
  });
}

class UtlBluetoothResources {
  UtlBluetoothResources._();
  static Future<bool> requestPermission() => PermissionHandlerBluetoothUtil.requestPermission();
  static void turnOnBluetooth() => FlutterBluePlusUtil.turnOn(requestPermission: requestPermission);
  static Duration scanDuration = const Duration(seconds: 15);
  static Duration readRssiDuration = const Duration(milliseconds: 300);
  static Future<void> rescan() => FlutterBluePlusUtil.rescan(requestPermission: requestPermission, scanDuration: scanDuration);
  static Timer createReadRssiTimer({
    required FlutterBluePlusPersistDeviceUtils utils,
  }) {
    return utils.readRssi(
      duration: readRssiDuration,
    );
  }
}
