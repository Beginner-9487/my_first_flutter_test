import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';

import 'ble_repository_event.dart';
import 'ble_repository_state.dart';

class BLERepositoryBloc extends Bloc<BLERepositoryEvent, BLERepositoryState> {

  BLERepositoryBloc(this._bleRepository) : super(initialState) {
    on<BLEInit>((event, emit) {
      _refreshUI();
    });
    on<BLETurnOn>((event, emit) {
      _bleRepository.turnOn();
      _refreshUI();
    });
    on<BLETurnOff>((event, emit) {
      _bleRepository.turnOff();
      _refreshUI();
    });
    on<BLEScanOn>((event, emit) {
      _bleRepository.scanOn();
      _refreshUI();
    });
    on<BLEScanOff>((event, emit) {
      _bleRepository.scanOff();
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

    _onBLESwitchChange = _bleRepository.onSwitchChange((bool state) {
      debugPrint("BLERepositoryBloc._onBLESwitchChange: $state");
      _refreshUI();
    });
    _onBLEScanningChange = _bleRepository.onScanningStateChange((bool state) {
      _refreshUI();
    });
    _onNewDeviceFounded = _bleRepository.onNewDeviceFounded((BLEDevice result) {
      _refreshUI();
    });
  }

  final BLERepository _bleRepository;

  bool get isBluetoothOn => _bleRepository.isBluetoothOn;
  bool get isScanning => _bleRepository.isScanning;
  Iterable<BLEDevice> get namedDevices => _bleRepository.namedDevices;
  Iterable<BLEDevice> get allDevices => _bleRepository.allDevices;

  late StreamSubscription<bool> _onBLESwitchChange;
  late StreamSubscription<bool> _onBLEScanningChange;
  late StreamSubscription<BLEDevice> _onNewDeviceFounded;

  @override
  static BLERepositoryState get initialState => BLENormalState();

  _refreshUI() {
    emit(BLENormalState());
  }
}
