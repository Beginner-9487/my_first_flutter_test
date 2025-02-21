import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class FlutterBluePlusDeviceRssiChangeNotifier extends ChangeNotifier {
  int _rssi;
  FlutterBluePlusDeviceRssiChangeNotifier({
    required int rssi,
  }) : _rssi = rssi;
  int get rssi => _rssi;
  set rssi(int rssi) {
    _rssi = rssi;
    notifyListeners();
  }
}

class FlutterBluePlusDeviceIsConnectableChangeNotifier extends ChangeNotifier {
  bool _isConnectable;
  FlutterBluePlusDeviceIsConnectableChangeNotifier({
    required bool isConnectable,
  }) : _isConnectable = isConnectable;
  bool get isConnectable => _isConnectable;
  set isConnectable(bool isConnectable) {
    _isConnectable = isConnectable;
    notifyListeners();
  }
}

class FlutterBluePlusDeviceIsConnectedChangeNotifier extends ChangeNotifier {
  bool isConnected;
  late final StreamSubscription _subscription;
  FlutterBluePlusDeviceIsConnectedChangeNotifier({
    required BluetoothDevice bluetoothDevice,
  }) : isConnected = bluetoothDevice.isConnected {
    _subscription = bluetoothDevice.connectionState.listen((connectionState) {
      isConnected = connectionState == BluetoothConnectionState.connected;
      notifyListeners();
    });
  }
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class FlutterBluePlusDeviceUtil {
  const FlutterBluePlusDeviceUtil._();
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
      // debugPrint("FBP: connect start");
      await device.connect(
        timeout: Duration(seconds: timeout),
      );
      // debugPrint("FBP: connect finish");
      return true;
    } catch (e) {
      if (e is FlutterBluePlusException && e.code == FbpErrorCode.connectionCanceled.index) {
        // ignore connections canceled by the user
      } else {
        // debugPrint("ERROR: Connect: $e");
      }
      return false;
    }
  }
  static Future<bool> disconnect({
    required BluetoothDevice device,
    int timeout = 35,
  }) async {
    try {
      // debugPrint("FBP: disconnect start");
      await device.disconnect(
        timeout: timeout,
      );
      // debugPrint("FBP: disconnect finish");
      return true;
    } catch (e) {
      // debugPrint("ERROR: Disconnect: $e");
      return false;
    }
  }
}
