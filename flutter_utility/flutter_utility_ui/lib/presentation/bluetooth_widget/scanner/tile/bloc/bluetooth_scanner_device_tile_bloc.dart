import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/bloc/bluetooth_scanner_device_tile_event.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/bloc/bluetooth_scanner_device_tile_state.dart';

abstract class BluetoothScannerDeviceTileController {
  String get name;
  String get id;
  int get rssi;
  bool get isConnectable;
  bool get isConnected;
  Future<bool> connect();
  Future<bool> disconnect();
  Stream<bool> get onConnectableStateChange;
  Stream<bool> get onConnectionStateChange;
  Stream<int> get onRssiChange;
}

class BluetoothScannerDeviceTileBloc extends Bloc<BluetoothScannerDeviceTileEvent, BluetoothScannerDeviceTileState> {
  BluetoothScannerDeviceTileBloc({
    required BluetoothScannerDeviceTileController device,
  }) : _device = device, super(BluetoothScannerDeviceTileStateInit()) {
    _onConnectableStateChange = _device.onConnectableStateChange.listen((isConnectable) => _stateControl());
    _onConnectionStateChange = _device.onConnectionStateChange.listen((isConnected) => _stateControl());
    _onRssiChange = _device.onRssiChange.listen((rssi) => _stateControl());

    on<BluetoothScannerDeviceTileEventConnection>(
          (event, emit) {
        if(event is BluetoothScannerDeviceTileEventToggleConnection) {
          _toggleConnection();
        }
        return;
      },
    );

    _stateControl();
  }

  late final BluetoothScannerDeviceTileController _device;

  late final StreamSubscription<void> _onConnectableStateChange;
  late final StreamSubscription<void> _onConnectionStateChange;
  late final StreamSubscription<void> _onRssiChange;

  void _toggleConnection() async {
    _device.connect();
  }

  void _stateControl() {
    emit(BluetoothScannerDeviceTileStateNormal(
      name: _device.name,
      id: _device.id,
      isConnectable: _device.isConnectable,
      isConnected: _device.isConnected,
      rssi: _device.rssi,
    ));
    return;
  }

  @override
  Future<void> close() {
    _onConnectableStateChange.cancel();
    _onConnectionStateChange.cancel();
    _onRssiChange.cancel();
    return super.close();
  }
}
