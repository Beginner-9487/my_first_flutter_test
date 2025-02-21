import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class FlutterBluePlusAdapterStateChangeNotifier extends ChangeNotifier {
  BluetoothAdapterState _adapterState = FlutterBluePlus.adapterStateNow;
  BluetoothAdapterState get adapterState => _adapterState;
  late final StreamSubscription _subscription;
  FlutterBluePlusAdapterStateChangeNotifier() {
    _subscription = FlutterBluePlus.adapterState.listen((adapterState) {
      _adapterState = adapterState;
      notifyListeners();
    });
  }
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class FlutterBluePlusIsOnChangeNotifier extends ChangeNotifier {
  BluetoothAdapterState _adapterState = FlutterBluePlus.adapterStateNow;
  bool get isOn => _adapterState == BluetoothAdapterState.on;
  late final StreamSubscription _subscription;
  FlutterBluePlusIsOnChangeNotifier() {
    _subscription = FlutterBluePlus.adapterState.listen((adapterState) {
      _adapterState = adapterState;
      notifyListeners();
    });
  }
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class FlutterBluePlusIsScanningChangeNotifier extends ChangeNotifier {
  bool _isScanning = FlutterBluePlus.isScanningNow;
  bool get isScanning => _isScanning;
  late final StreamSubscription _subscription;
  FlutterBluePlusIsScanningChangeNotifier() {
    _subscription = FlutterBluePlus.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      notifyListeners();
    });
  }
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class FlutterBluePlusScanResultsChangeNotifier extends ChangeNotifier {
  List<ScanResult> _scanResults = [];
  Iterable<ScanResult> get scanResults => _scanResults;
  late final StreamSubscription _subscription;
  FlutterBluePlusScanResultsChangeNotifier() {
    _subscription = FlutterBluePlus.scanResults.listen((scanResults) {
      _scanResults = scanResults;
      notifyListeners();
    });
  }
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class FlutterBluePlusScannedResultsToDeviceChangeNotifier<Device> extends ChangeNotifier {
  List<Device> _scanResults = [];
  Iterable<Device> get scanResults => _scanResults;
  late final StreamSubscription _subscription;
  FlutterBluePlusScannedResultsToDeviceChangeNotifier({
    required Device Function(ScanResult result) resultToDevice,
  }) {
    _subscription = FlutterBluePlus.scanResults.listen((scanResults) {
      _scanResults = scanResults.map(resultToDevice).toList();
      notifyListeners();
    });
  }
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class FlutterBluePlusUtil {
  const FlutterBluePlusUtil._();
  static Future<bool> turnOn({
    required Future<bool> Function() requestPermission,
  }) async {
    if(!await requestPermission()) return false;
    await FlutterBluePlus.turnOn();
    return true;
  }
  static Future<void> rescan({
    required Future<bool> Function() requestPermission,
    required Duration scanDuration,
  }) async {
    if(!await requestPermission()) return;
    await scanOff(requestPermission: requestPermission);
    await scanOn(requestPermission: requestPermission, scanDuration: scanDuration);
    return;
  }
  static Future<bool> toggleScan({
    required Future<bool> Function() requestPermission,
    required bool isScanning,
    required Duration scanDuration,
  }) async {
    if(!await requestPermission()) return false;
    return (FlutterBluePlus.isScanningNow)
        ? scanOff(requestPermission: requestPermission)
        : scanOn(requestPermission: requestPermission, scanDuration: scanDuration);
  }
  static Future<bool> scanOn({
    required Future<bool> Function() requestPermission,
    required Duration scanDuration,
  }) async {
    if(!await requestPermission()) return false;
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
  static Future<bool> scanOff({
    required Future<bool> Function() requestPermission,
  }) async {
    if(!await requestPermission()) return false;
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
}
