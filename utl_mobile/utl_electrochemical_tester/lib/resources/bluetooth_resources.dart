import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_device_widget_util.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/bluetooth/bluetooth_devices_handler.dart';

class BluetoothResources {
  BluetoothResources._();
  static final List<String> sentUuids = [
    "6e400002-b5a3-f393-e0a9-e50e24dcca9e",
  ];
  static final List<String> receivedUuids = [
    "6e400003-b5a3-f393-e0a9-e50e24dcca9e",
  ];
  static final VoidCallback turnOnBluetooth = FlutterBluePlus.turnOn;
  static late final FlutterBluePlusPersistDeviceWidgetUtilsProvider<FlutterBluePlusDeviceWidgetUtil> bluetoothWidgetsProvider;
  static late final BluetoothDevicesHandler bluetoothDevicesHandler;
  static late final Timer readRssiTimer;
}
