import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/bloc/bluetooth_scanner_event.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/bloc/bluetooth_scanner_state.dart';
import 'package:stream_transform/stream_transform.dart';

abstract class BluetoothScannerController<Device> {
  Iterable<Device> get devices;
  bool get isEnable;
  bool get isScanning;
  Future<void> scanRefresh();
  Future<void> scanOn();
  Future<void> scanOff();
  Stream<bool> get onEnableStateChange;
  Stream<Device> get onFoundNewDevice;
  Stream<bool> get onScanningStateChange;
}

EventTransformer<E> _throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class BluetoothScannerBloc<Device> extends Bloc<BluetoothScannerEvent, BluetoothScannerState> {
  BluetoothScannerBloc({
    required BluetoothScannerController<Device> controller,
    required Duration scanDelay,
  }) : _controller = controller, super(BluetoothScannerStateInit()) {
    _onEnableStateChange = controller.onEnableStateChange.listen((enable) => _stateControl());
    _onFoundNewDevice = controller.onFoundNewDevice.listen((device) => _stateControl());
    _onScanningStateChange = controller.onScanningStateChange.listen((state) => _stateControl());

    on<BluetoothScannerEventScanning>(
      (event, emit) {
        if(event is BluetoothScannerEventToggleScanning) {
          _toggleScanning();
        }
        if(event is BluetoothScannerEventRefreshScanning) {
          _scanRefresh();
        }
      },
      transformer: _throttleDroppable(scanDelay),
    );

    _stateControl();
  }

  final BluetoothScannerController<Device> _controller;

  Iterable<Device> get devices => _controller.devices;
  bool get isEnable => _controller.isEnable;
  bool get isScanning => _controller.isScanning;

  late final StreamSubscription<bool> _onEnableStateChange;
  late final StreamSubscription<Device> _onFoundNewDevice;
  late final StreamSubscription<bool> _onScanningStateChange;

  void _toggleScanning() {
    _controller.isScanning ? _controller.scanOff() : _controller.scanOn();
    return;
  }

  void _scanRefresh() {
    _controller.scanRefresh();
    return;
  }

  void _stateControl() {
    emit(_controller.isEnable
        ? BluetoothScannerStateEnable(
            isScanning: _controller.isScanning,
            devices: _controller.devices,
          )
        : BluetoothScannerStateDisable()
    );
    return;
  }

  @override
  Future<void> close() {
    _onEnableStateChange.cancel();
    _onFoundNewDevice.cancel();
    _onScanningStateChange.cancel();
    return super.close();
  }
}
