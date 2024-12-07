import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bt/bt.dart';

import 'ble_repository_event.dart';
import 'ble_repository_state.dart';

class BLERepositoryBloc extends Bloc<BLERepositoryEvent, BLERepositoryState> {

  BLERepositoryBloc(this._provider) : super(initialState) {
    on<BLEInit>((event, emit) {
      _refreshUI();
    });
    on<BLETurnOn>((event, emit) {
      _provider.turnOn();
      _refreshUI();
    });
    on<BLETurnOff>((event, emit) {
      _provider.turnOff();
      _refreshUI();
    });
    on<BLEScanOn>((event, emit) {
      _provider.scanOn();
      _refreshUI();
    });
    on<BLEScanOff>((event, emit) {
      _provider.scanOff();
      _refreshUI();
    });
    on<BLEUpdate>((event, emit) {
      _refreshUI();
    });
    on<BLEError>((event, emit) {
      _refreshUI();
    });
    on<BLEDispose>((event, emit) {
      _onBLESwitchChange.cancel();
      _onBLEScanningChange.cancel();
      _onNewDeviceFounded.cancel();
      emit(BLEDisposeState());
    });

    _onBLESwitchChange = _provider.onAdapterStateChange((bool state) {
      _refreshUI();
    });
    _onBLEScanningChange = _provider.onScanningStateChange((bool state) {
      _refreshUI();
    });
    _onNewDeviceFounded = _provider.onFoundNewDevice((BT_Device result) {
      _refreshUI();
    });
  }

  final BT_Provider _provider;

  bool get isBluetoothOn => _provider.isBluetoothOn;
  bool get isScanning => _provider.isScanning;
  Iterable<BT_Device> get devices => _provider.devices;

  late StreamSubscription<bool> _onBLESwitchChange;
  late StreamSubscription<bool> _onBLEScanningChange;
  late StreamSubscription<BT_Device> _onNewDeviceFounded;

  @override
  static BLERepositoryState get initialState => BLENormalState();

  _refreshUI() {
    emit(BLENormalState());
  }
}
