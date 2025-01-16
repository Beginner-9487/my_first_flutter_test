import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth_utils/bluetooth_widget_util.dart';

class FlutterBluePlusWidgetUtil {
  const FlutterBluePlusWidgetUtil._();
  static Future<void> rescan({
    required Duration scanDuration,
  }) async {
    await scanOff();
    await scanOn(scanDuration: scanDuration);
    return;
  }
  static Future<bool> toggleScan({
    required bool isScanning,
    required Duration scanDuration,
  }) async {
    if(!await BluetoothWidgetUtil.requestPermission()) return false;
    return (FlutterBluePlus.isScanningNow)
      ? scanOff()
      : scanOn(scanDuration: scanDuration);
  }
  static Future<bool> scanOn({
    required Duration scanDuration,
  }) async {
    if(!await BluetoothWidgetUtil.requestPermission()) return false;
    if(FlutterBluePlus.isScanningNow) return false;
    try {
      // android is slow when asking for all advertisements,
      // so instead we only ask for 1/8 of them
      int divisor = Platform.isAndroid ? 8 : 1;
      await FlutterBluePlus.startScan(
        timeout: scanDuration,
        continuousUpdates: true,
        continuousDivisor: divisor,
      );
      return true;
    } catch (e) {
      debugPrint("ERROR: scanOn: $e");
      return false;
    }
  }
  static Future<bool> scanOff() async {
    if(!await BluetoothWidgetUtil.requestPermission()) return false;
    try {
      await FlutterBluePlus.stopScan();
      return true;
    } catch (e) {
      debugPrint("ERROR: scanOff: $e");
      return false;
    }
  }
  static Future<bool> toggleConnection({
    required BluetoothDevice device,
  }) {
    return (device.isConnected)
        ? disconnect(device: device)
        : connect(device: device);
  }
  static Future<bool> connect({
    required BluetoothDevice device,
    int timeout = 35,
  }) async {
    try {
      debugPrint("FBP: connect start");
      await device.connect(
        timeout: Duration(seconds: timeout),
      );
      debugPrint("FBP: connect finish");
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
  static Future<bool> disconnect({
    required BluetoothDevice device,
    int timeout = 35,
  }) async {
    try {
      debugPrint("FBP: disconnect start");
      await device.disconnect(
        timeout: timeout,
      );
      debugPrint("FBP: disconnect finish");
      return true;
    } catch (e) {
      debugPrint("ERROR: Disconnect: $e");
      return false;
    }
  }
  static Widget buildScanningWidget({
    required Widget Function(BuildContext context, bool isScanning) builder,
  }) {
    return StreamBuilder(
      initialData: FlutterBluePlus.isScanningNow,
      stream: FlutterBluePlus.isScanning,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return builder(context, snapshot.data ?? FlutterBluePlus.isScanningNow);
      },
    );
  }
  static Widget buildScanResultsWidget({
    required Widget Function(BuildContext context, List<ScanResult> results) builder,
  }) {
    return StreamBuilder(
      stream: FlutterBluePlus.scanResults,
      builder: (BuildContext context, AsyncSnapshot<List<ScanResult>> snapshot) => builder(context, snapshot.data ?? []),
    );
  }
  static Widget buildScanResultsList({
    required Widget? Function(BuildContext context, ScanResult result) builder,
    bool Function(ScanResult result)? filter,
  }) {
    filter = filter ?? (result) => true;
    return buildScanResultsWidget(
      builder: (context, results) {
        Iterable<ScanResult> list = results.where(filter!);
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) => builder(context, list.skip(index).first),
        );
      }
    );
  }
  static Widget buildIsEnabledWidget({
    required Widget Function(BuildContext context, bool isEnabled) builder,
  }) {
    return StreamBuilder(
      initialData: FlutterBluePlus.adapterStateNow,
      stream: FlutterBluePlus.adapterState,
      builder: (context, snapshot) => builder(
        context,
        (snapshot.data ?? FlutterBluePlus.adapterStateNow) == BluetoothAdapterState.on,
      ),
    );
  }
  static Widget buildIsConnectedWidget({
    required BluetoothDevice bluetoothDevice,
    required Widget Function(BuildContext context, bool isConnected) builder,
  }) {
    return StreamBuilder(
      initialData: bluetoothDevice.isConnected,
      stream: bluetoothDevice.connectionState,
      builder: (context, snapshot) => builder(
        context,
        (snapshot.data ?? bluetoothDevice.isConnected) == BluetoothConnectionState.connected,
      ),
    );
  }
}
