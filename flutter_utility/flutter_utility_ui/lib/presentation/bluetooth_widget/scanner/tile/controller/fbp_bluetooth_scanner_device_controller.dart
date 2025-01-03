import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/controller/fbp_bluetooth_scanner_controller.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/controller/bluetooth_scanner_device_controller.dart';

class FbpBluetoothScannerTilesController extends FbpBluetoothScannerController<FbpBluetoothScannerDeviceTileController> {
  late final Timer? _readRssi;
  FbpBluetoothScannerTilesController({
    required super.devices,
    required super.scanDuration,
    Duration? readRssiDelay,
  }) : super(
    bluetoothDeviceToDevice: (bluetoothDevice, controller) => FbpBluetoothScannerDeviceTileController(
        bluetoothDevice: bluetoothDevice,
        isConnectable: false,
        rssi: 0,
    ),
    scanResultToDevice: (scanResult, controller) => FbpBluetoothScannerDeviceTileController(
        bluetoothDevice: scanResult.device,
        isConnectable: scanResult.advertisementData.connectable,
        rssi: scanResult.rssi,
    ),
  ) {
    _readRssi = (readRssiDelay != null)
      ? Timer.periodic(readRssiDelay, (timer) {
          for(var d in devices.where((d) => d.bluetoothDevice.isConnected)) {
            d.bluetoothDevice.readRssi().then((rssi) {
              d.rssi = rssi;
            });
          }
        })
      : null;
  }
  @override
  void dispose() {
    super.dispose();
    _readRssi?.cancel();
  }
}

class FbpBluetoothScannerDeviceTileController with EquatableMixin implements FbpBluetoothScannerControllerDevice, BluetoothScannerDeviceTileController {
  FbpBluetoothScannerDeviceTileController({
    required this.bluetoothDevice,
    required bool isConnectable,
    required int rssi,
  })
      :
        _isConnectable = isConnectable,
        _rssi = rssi
  {
    _scanned = FlutterBluePlus.onScanResults.listen((results) {
      for(var result in results) {
        if(result.device == bluetoothDevice) {
          this.rssi = result.rssi;
          this.isConnectable = result.advertisementData.connectable;
          return;
        }
      }
    });
  }

  @override
  BluetoothDevice bluetoothDevice;

  late final StreamSubscription<List<ScanResult>> _scanned;

  final StreamController<bool> _onConnectableChange = StreamController.broadcast();
  final StreamController<int> _onRssiChange = StreamController.broadcast();

  @override
  String get id => bluetoothDevice.remoteId.str;

  @override
  String get name => bluetoothDevice.platformName;

  @override
  Future<bool> connect() {
    return bluetoothDevice.connect().then((value) => true);
  }

  @override
  Future<bool> disconnect() {
    return bluetoothDevice.disconnect().then((value) => true);
  }

  bool _isConnectable;

  @override
  bool get isConnectable => _isConnectable;

  set isConnectable(bool isConnectable) {
    _isConnectable = isConnectable;
    _onConnectableChange.sink.add(isConnectable);
  }

  int _rssi;

  @override
  int get rssi => _rssi;

  set rssi(int rssi) {
    _rssi = rssi;
    _onRssiChange.sink.add(rssi);
  }

  @override
  bool get isConnected => bluetoothDevice.isConnected;

  @override
  Stream<bool> get onConnectableStateChange => _onConnectableChange.stream;

  @override
  Stream<bool> get onConnectionStateChange => bluetoothDevice.connectionState.map((event) => event == BluetoothConnectionState.connected);

  @override
  Stream<int> get onRssiChange => _onRssiChange.stream;

  @override
  List<Object?> get props => [bluetoothDevice];

  void dispose() {
    _onConnectableChange.close();
    _onRssiChange.close();
    _scanned.cancel();
  }
}