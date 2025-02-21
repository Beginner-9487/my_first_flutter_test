import 'dart:async';

import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_persist_devices_util.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/bluetooth/bluetooth_devices_handler.dart';
import 'package:utl_mobile/utl_bluetooth/utl_bluetooth_resources.dart';

class BluetoothResource {
  BluetoothResource._();
  static final List<String> sentUuids = [
    "6e400002-b5a3-f393-e0a9-e50e24dcca9e",
  ];
  static final List<String> receivedUuids = [
    "6e400003-b5a3-f393-e0a9-e50e24dcca9e",
  ];
  static void turnOnBluetooth() => UtlBluetoothResources.turnOnBluetooth();
  static late final UtlBluetoothDevicesWidgetProvider<FlutterBluePlusPersistDeviceUtil> bluetoothDevicesWidgetProvider;
  static late final BluetoothDevicesHandler bluetoothDevicesHandler;
  static late final Timer readRssiTimer;
}
