import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bt/bt.dart';

import 'ble_device_event.dart';
import 'ble_device_state.dart';

class BLEDeviceBloc extends Bloc<BLEDeviceEvent, BLEDeviceState> {

  BLEDeviceBloc(this.device) : super(initialState) {
    _onRssiChange = device.onRssiChange((device) {
      _refreshUI();
    });
    _onReadMtu = device.onMtuChange((device) {
      _refreshUI();
    });
    _onConnectStateChange = device.onConnectionStateChange((device) {
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
      device.discover();
      _refreshUI();
    });
    on<BLEDeviceEventDispose>((event, emit) {
      _onRssiChange.cancel();
      _onReadMtu.cancel();
      _onConnectStateChange.cancel();
      emit(BLEDeviceStateDispose());
    });
  }

  BT_Device device;
  int get mtuSize => device.mtu;
  bool get isConnected => device.isConnected;
  bool get isConnectable => device.isConnectable;

  late StreamSubscription<BT_Device> _onRssiChange;
  late StreamSubscription<BT_Device> _onReadMtu;
  late StreamSubscription<BT_Device> _onConnectStateChange;

  static BLEDeviceState get initialState => BLEDeviceNormalState();

  _refreshUI() {
    emit(BLEDeviceNormalState());
  }
}
