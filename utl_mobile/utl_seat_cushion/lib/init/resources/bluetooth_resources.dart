import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_persist_devices_util.dart';
import 'package:utl_mobile/utl_bluetooth/utl_bluetooth_resources.dart';
import 'package:utl_seat_cushion/infrastructure/bluetooth/bluetooth_handler.dart';

class BluetoothResources {
  BluetoothResources._();
  static final List<String> sentUuids = [
    "6e400002-b5a3-f393-e0a9-e50e24dcca9e",
  ];
  static final List<String> receivedUuids = [
    "6e400003-b5a3-f393-e0a9-e50e24dcca9e",
  ];
  static final VoidCallback turnOnBluetooth = FlutterBluePlus.turnOn;
  static late final UtlBluetoothDevicesWidgetProvider<FlutterBluePlusPersistDeviceUtil> bluetoothDevicesWidgetProvider;
  static late final BluetoothHandler bluetoothHandler;
  static late final Timer readRssiTimer;
}