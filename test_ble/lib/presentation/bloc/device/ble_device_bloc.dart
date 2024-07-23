import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';

import 'ble_device_event.dart';
import 'ble_device_state.dart';

class BLEDeviceBloc extends Bloc<BLEDeviceEvent, BLEDeviceState> {

  BLEDeviceBloc(this.device) : super(initialState) {
    _onReadMtu = device.onMtuChange((int mtu) {
      _refreshUI();
    });
    _onConnectStateChange = device.onConnectStateChange((bool state) {
      _refreshUI();
    });

    on<BLEDeviceConnect>((event, emit) {
      device.connect();
      _refreshUI();
    });
    on<BLEDeviceDisconnect>((event, emit) {
      device.disconnect();
      _refreshUI();
    });
    on<BLEDeviceDiscoverServices>((event, emit) {
      device.discoverServices();
      _refreshUI();
    });
    on<BLEDeviceEventDispose>((event, emit) {
      _onReadMtu.cancel();
      _onConnectStateChange.cancel();
      emit(BLEDeviceStateDispose());
    });
  }

  BLEDevice device;
  int get mtuSize => device.mtuSize;
  bool get isConnected => device.isConnected;
  bool get isConnecting => device.isConnecting;
  bool get isDisconnecting => device.isDisconnecting;
  bool get connectable => device.connectable;

  late StreamSubscription<int> _onReadMtu;
  late StreamSubscription<bool> _onConnectStateChange;

  @override
  static BLEDeviceState get initialState => BLEDeviceNormalState();

  _refreshUI() {
    emit(BLEDeviceNormalState());
  }
}
