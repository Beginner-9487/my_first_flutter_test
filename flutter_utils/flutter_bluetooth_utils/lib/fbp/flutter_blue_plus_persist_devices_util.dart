import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class FlutterBluePlusPersistBluetoothDevicesChangeNotifier extends ChangeNotifier {
  final FlutterBluePlusPersistBluetoothDevices _persist;
  FlutterBluePlusPersistBluetoothDevicesChangeNotifier(this._persist) {
    _persist._devicesChangeNotifiers.add(this);
  }
  Iterable<BluetoothDevice> get devices => _persist.devices;
  @override
  void notifyListeners() => super.notifyListeners();
  @override
  void dispose() {
    _persist._devicesChangeNotifiers.remove(this);
    super.dispose();
  }
}

class FlutterBluePlusPersistBluetoothDevices {
  final List<BluetoothDevice> _devices;
  Iterable<BluetoothDevice> get devices => _devices;
  late final StreamSubscription _subscription;
  FlutterBluePlusPersistBluetoothDevices({
    required List<BluetoothDevice> devices,
  }) : _devices = devices {
    _subscription = FlutterBluePlus.scanResults.listen(_updateResults);
  }
  void _updateResults(List<ScanResult> results) {
    for (var result in results) {
      var device = devices
          .where((device) => device == result.device)
          .firstOrNull;
      if(device != null) return;
      _devices.add(result.device);
      for(var notifier in _devicesChangeNotifiers) {
        notifier.notifyListeners();
      }
    }
  }
  final List<FlutterBluePlusPersistBluetoothDevicesChangeNotifier> _devicesChangeNotifiers = [];
  FlutterBluePlusPersistBluetoothDevicesChangeNotifier createDevicesChangeNotifier() {
    return FlutterBluePlusPersistBluetoothDevicesChangeNotifier(this);
  }
  void dispose() {
    for(var notifier in _devicesChangeNotifiers) {
      notifier.dispose();
    }
    _devicesChangeNotifiers.clear();
    _subscription.cancel();
  }
}

class FlutterBluePlusPersistBluetoothDevicesToDevicesChangeNotifier<Device> extends ChangeNotifier {
  final FlutterBluePlusPersistBluetoothDevicesToDevices<Device> _persist;
  FlutterBluePlusPersistBluetoothDevicesToDevicesChangeNotifier(this._persist) {
    _persist._devicesChangeNotifiers.add(this);
  }
  Iterable<Device> get devices => _persist.devices;
  @override
  void notifyListeners() => super.notifyListeners();
  @override
  void dispose() {
    _persist._devicesChangeNotifiers.remove(this);
    super.dispose();
  }
}

class FlutterBluePlusPersistBluetoothDevicesToDevices<Device> {
  final List<Device> _devices;
  Iterable<Device> get devices => _devices;
  late final StreamSubscription _subscription;
  final Device Function(ScanResult result) addNewDeviceHandler;
  final Function(ScanResult result, Device oldDevice)? existingDeviceHandler;
  final bool Function(ScanResult result, Device device) isExistingDevice;
  FlutterBluePlusPersistBluetoothDevicesToDevices({
    required List<Device> devices,
    required this.isExistingDevice,
    required this.addNewDeviceHandler,
    this.existingDeviceHandler,
  }) : _devices = devices {
    _subscription = FlutterBluePlus.scanResults.listen(_updateResults);
  }
  void _updateResults(List<ScanResult> results) {
    for (var result in results) {
      var device = devices
          .where((device) => isExistingDevice(result, device))
          .firstOrNull;
      if(device == null) {
        _devices.add(addNewDeviceHandler(result));
        for(var notifier in _devicesChangeNotifiers) {
          notifier.notifyListeners();
        }
      } else {
        existingDeviceHandler?.call(result, device);
      }
    }
  }
  final List<FlutterBluePlusPersistBluetoothDevicesToDevicesChangeNotifier> _devicesChangeNotifiers = [];
  FlutterBluePlusPersistBluetoothDevicesToDevicesChangeNotifier<Device> createDevicesChangeNotifier() {
    return FlutterBluePlusPersistBluetoothDevicesToDevicesChangeNotifier(this);
  }
  void dispose() {
    for(var notifier in _devicesChangeNotifiers) {
      notifier.dispose();
    }
    _devicesChangeNotifiers.clear();
    _subscription.cancel();
  }
}

class FlutterBluePlusPersistDeviceUtilRssiChangeNotifier extends ChangeNotifier {
  final FlutterBluePlusPersistDeviceUtil _util;
  int get rssi => _util.rssi;
  FlutterBluePlusPersistDeviceUtilRssiChangeNotifier({
    required FlutterBluePlusPersistDeviceUtil util,
  }) : _util = util {
    _util._rssiChangeNotifiers.add(this);
  }
  @override
  void notifyListeners() => super.notifyListeners();
  @override
  void dispose() {
    _util._rssiChangeNotifiers.remove(this);
    super.dispose();
  }
}

class FlutterBluePlusPersistDeviceUtilIsConnectableChangeNotifier extends ChangeNotifier {
  final FlutterBluePlusPersistDeviceUtil _util;
  bool get isConnectable => _util.isConnectable;
  FlutterBluePlusPersistDeviceUtilIsConnectableChangeNotifier({
    required FlutterBluePlusPersistDeviceUtil util,
  }) : _util = util {
    _util._isConnectableChangeNotifiers.add(this);
  }
  @override
  void notifyListeners() => super.notifyListeners();
  @override
  void dispose() {
    _util._isConnectableChangeNotifiers.remove(this);
    super.dispose();
  }
}

class FlutterBluePlusPersistDeviceUtil {
  factory FlutterBluePlusPersistDeviceUtil.resultToDevice(ScanResult result) {
    return FlutterBluePlusPersistDeviceUtil(
      bluetoothDevice: result.device,
      isConnectable: result.advertisementData.connectable,
      rssi: result.rssi,
    );
  }
  FlutterBluePlusPersistDeviceUtil({
    required this.bluetoothDevice,
    this.existingDeviceHandler,
    bool isConnectable = false,
    int rssi = 0,
  }) :
        _rssi = rssi,
        _isConnectable = isConnectable;
  final BluetoothDevice bluetoothDevice;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is FlutterBluePlusPersistDeviceUtil && runtimeType == other.runtimeType && bluetoothDevice == other.bluetoothDevice);

  int _rssi;
  int get rssi => _rssi;
  set rssi(int rssi) {
    _rssi = rssi;
    for(var notifier in _rssiChangeNotifiers) {
      notifier.notifyListeners();
    }
  }
  final List<FlutterBluePlusPersistDeviceUtilRssiChangeNotifier> _rssiChangeNotifiers = [];
  FlutterBluePlusPersistDeviceUtilRssiChangeNotifier createRssiChangeNotifier() {
    return FlutterBluePlusPersistDeviceUtilRssiChangeNotifier(util: this);
  }

  bool _isConnectable;
  bool get isConnectable => _isConnectable;
  set isConnectable(bool isConnectable) {
    _isConnectable = isConnectable;
    for(var notifier in _isConnectableChangeNotifiers) {
      notifier.notifyListeners();
    }
  }
  final List<FlutterBluePlusPersistDeviceUtilIsConnectableChangeNotifier> _isConnectableChangeNotifiers = [];
  FlutterBluePlusPersistDeviceUtilIsConnectableChangeNotifier createIsConnectableChangeNotifier() {
    return FlutterBluePlusPersistDeviceUtilIsConnectableChangeNotifier(util: this);
  }

  String get deviceName => bluetoothDevice.platformName;
  String get deviceId => bluetoothDevice.remoteId.str;
  bool isExistingDevice(ScanResult result) {
    return result.device == bluetoothDevice;
  }
  final void Function(ScanResult result)? existingDeviceHandler;
  void _updateExistingDevice(ScanResult result) {
    rssi = result.rssi;
    isConnectable = result.advertisementData.connectable;
    existingDeviceHandler?.call(result);
  }
  void dispose() {
    for(var notifier in _rssiChangeNotifiers) {
      notifier.dispose();
    }
    _rssiChangeNotifiers.clear();
    for(var notifier in _isConnectableChangeNotifiers) {
      notifier.dispose();
    }
    _isConnectableChangeNotifiers.clear();
  }
}

class FlutterBluePlusPersistDeviceUtils<Device extends FlutterBluePlusPersistDeviceUtil> extends FlutterBluePlusPersistBluetoothDevicesToDevices<Device> {
  FlutterBluePlusPersistDeviceUtils({
    required super.devices,
    required super.addNewDeviceHandler,
    void Function(ScanResult, Device)? existingDeviceHandler,
  }) : super(
    isExistingDevice: (result, device) => device.isExistingDevice(result),
    existingDeviceHandler: (result, device) {
      device._updateExistingDevice(result);
      existingDeviceHandler?.call(result, device);
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
  @override
  void dispose() {
    for(var device in devices) {
      device.dispose();
    }
    super.dispose();
  }
}
