import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_ble/utils/extra.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class FlutterBluePlusPeripheralInfrastructure {

  /// ==========================================================================
  /// Bluetooth switch
  static turnOn() async {
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }
  }
  static turnOff() async {}

  /// ==========================================================================
  /// Bluetooth device
  static List<BluetoothDevice> systemDevices = [];
  static scanOn({int duration = 15}) async {
    if(FlutterBluePlus.isScanningNow) {return;}
    try {
      systemDevices = await FlutterBluePlus.systemDevices;

      // android is slow when asking for all advertisements,
      // so instead we only ask for 1/8 of them
      int divisor = Platform.isAndroid ? 8 : 1;
      await FlutterBluePlus.startScan(
          timeout: Duration(seconds: duration),
          continuousUpdates: true,
          continuousDivisor: divisor
      );
    } catch (e) {
      debugPrint("ERROR: scanOn: $e");
    }
  }
  static scanOff() {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {
      debugPrint("ERROR: scanOff: $e");
    }
  }
  static List<ScanResult> scanResults = [];
  static late StreamSubscription<List<ScanResult>> _onScanResults;

  /// ==========================================================================
  /// connectedDevices
  static List<BluetoothDevice> connectedDevices = FlutterBluePlus.connectedDevices;

  /// ==========================================================================
  /// Connect device
  @override
  static Future<bool> connect(BluetoothDevice device) async {
    try {
      await device.connectAndUpdateStream();
      return true;
    } catch (e) {
      if (e is FlutterBluePlusException && e.code == FbpErrorCode.connectionCanceled.index) {
        // ignore connections canceled by the user
      } else {
        debugPrint("ERROR: Connect: $e");
      }
      return false;
    }
  }
  @override
  static Future<bool> disconnect(BluetoothDevice device) async {
    try {
      await device.disconnectAndUpdateStream();
      return true;
    } catch (e) {
      debugPrint("ERROR: Disconnect: $e");
      return false;
    }
  }
}