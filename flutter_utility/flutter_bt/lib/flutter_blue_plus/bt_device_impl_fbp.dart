import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bt/bt.dart';
import 'package:flutter_bt/flutter_blue_plus/bt_provider_impl_fbp.dart';
import 'package:flutter_bt/flutter_blue_plus/bt_service_impl_fbp.dart';

class BT_Device_Impl_FBP implements BT_Device {
  @override
  BT_Provider_Impl_FBP provider;
  ScanResult? get result => BT_Provider_Impl_FBP
      .scanResults
      .where((element) => element.device == device)
      .firstOrNull;
  BluetoothDevice device;

  BT_Device_Impl_FBP({
    required this.provider,
    required this.device,
    this.isConnectable = false,
    this.isPaired = false,
    this.rssi = 0,
  }) {
    _onConnectionStateStreamSubscriptions = device.connectionState.listen((state) {
      if(state == BluetoothConnectionState.disconnected) {
        clearDiscoveredServices();
      }
    });
    _bondStateSubscriptions = device.bondState.listen((event) {
      isPaired = event == BluetoothBondState.bonded;
      _onPairingStateChangeController.sink.add(this);
    });
  }

  late final StreamSubscription<BluetoothConnectionState> _onConnectionStateStreamSubscriptions;
  late final StreamSubscription<BluetoothBondState> _bondStateSubscriptions;
  final StreamController<BT_Device> _onPairingStateChangeController = StreamController.broadcast();
  final StreamController<BT_Device> _onDiscoveryStateChangeController = StreamController.broadcast();
  final StreamController<BT_Device> _onRssiChangeController = StreamController.broadcast();
  final StreamController<BT_Device> _onMtuChangeController = StreamController.broadcast();
  final StreamController<BT_Characteristic> onNotificationChangeController = StreamController.broadcast();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BT_Device_Impl_FBP && other.device == device);

  @override
  int get hashCode => device.hashCode;

  List<BluetoothService> _bluetoothServices = [];

  @override
  Iterable<BT_Service_Impl_FBP> get services => _bluetoothServices
      .map((e) => BT_Service_Impl_FBP(
        provider,
        this,
        e,
      ));

  @override
  String get name => device.platformName;
  @override
  String get address => device.remoteId.str;
  @override
  bool isConnectable;
  void updateIsConnectable(bool isConnectable) {
    this.isConnectable = isConnectable;
    return;
  }
  @override
  bool get isScanned => result != null;

  /// ==========================================================================
  /// Manufacturer Data
  @override
  String get manufacturerData => (result != null) ? _getNiceManufacturerData(result!.advertisementData.manufacturerData) : "";
  String _getNiceManufacturerData(Map<int, List<int>> data) {
    return data.entries
        .map((entry) => '${entry.key.toRadixString(16)}: ${_getNiceHexArray(entry.value)}')
        .join(', ')
        .toUpperCase();
  }
  String _getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]';
  }

  /// ==========================================================================
  /// Rssi
  @override
  int rssi;

  @override
  StreamSubscription<BT_Device> onRssiChange(void Function(BT_Device device) onRssiChange) {
    return _onRssiChangeController
        .stream
        .map((event) => this)
        .listen(onRssiChange);
  }

  void updateRssi(int value) {
    rssi = value;
    _onRssiChangeController.sink.add(this);
    return;
  }

  @override
  Future<int> fetchRssi({int timeout = 15}) async {
    try{
      return device
        .readRssi(timeout: timeout)
        .then((value) {
          updateRssi(value);
          return value;
        });
    } catch(e) {
      return rssi;
    }
  }

  /// ==========================================================================
  /// Mtu
  @override
  int get mtu => device.mtuNow;

  @override
  StreamSubscription<BT_Device> onMtuChange(void Function(BT_Device device) onMtuChange) {
    return _onMtuChangeController
        .stream
        .map((event) => this)
        .listen(onMtuChange);
  }

  @override
  Future<int> requestMtu(int mtu, {int timeout = 15}) async {
    try{
      return device.requestMtu(mtu)
        .then((value) {
          _onMtuChangeController.sink.add((this));
        return value;
      });
    } catch(e) {
      return mtu;
    }
  }

  /// ==========================================================================
  /// Connection
  @override
  StreamSubscription<BT_Device> onConnectionStateChange(void Function(BT_Device device) onConnectionStateChange) {
    return device.connectionState
        .map((event) => this)
        .listen(onConnectionStateChange);
  }
  @override
  bool get isConnected => device.isConnected;
  @override
  Future<bool> connect() async {
    try {
      return device
          .connect()
          .then((value) => true);
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
  Future<bool> disconnect() async {
    try {
      return device
          .disconnect()
          .then((value) => true);
    } catch (e) {
      debugPrint("ERROR: Disconnect: $e");
      return false;
    }
  }
  @override
  Future<bool> cancel() async {
    return disconnect();
  }

  /// ==========================================================================
  /// Services

  @override
  bool isDiscovered = false;

  @override
  Future<bool> discover() async {
    if(isDiscovered) {return true;}
    return device.discoverServices().then((value) {
      _bluetoothServices = value;
      isDiscovered = true;
      _onDiscoveryStateChangeController.add(this);
      return true;
    });
  }

  void clearDiscoveredServices() {
    _bluetoothServices.clear();
    isDiscovered = false;
    _onDiscoveryStateChangeController.add(this);
  }

  /// ==========================================================================
  /// Discovering Services
  @override
  StreamSubscription<BT_Device> onDiscoveryStateChange(void Function(BT_Device device) onDiscoveringStateChange) {
    return _onDiscoveryStateChangeController
        .stream
        .listen(onDiscoveringStateChange);
  }

  @override
  bool isPaired;

  @override
  StreamSubscription<BT_Device> onPairingStateChange(void Function(BT_Device device) onPairingStateChange) {
    return _onPairingStateChangeController.stream.listen(onPairingStateChange);
  }

  @override
  Future<bool> pair() async {
    try{
      return device
          .createBond()
          .then((value) {
            isPaired = true;
            _onPairingStateChangeController.sink.add(this);
            return isPaired;
          });
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> unpair() async {
    try{
      return device
          .removeBond()
          .then((value) {
            isPaired = false;
            _onPairingStateChangeController.sink.add(this);
            return isPaired;
          });
    } catch (e) {
      return false;
    }
  }
}