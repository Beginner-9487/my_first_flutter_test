import 'dart:async';

import 'package:flutter_bt/fake/bt_device_impl_fake.dart';

import '../bt.dart';

class BT_Provider_Impl_Fake implements BT_Provider {
  static BT_Provider_Impl_Fake? _instance;
  static BT_Provider_Impl_Fake getInstance() {
    _instance ??= BT_Provider_Impl_Fake._();
    return _instance!;
  }
  BT_Provider_Impl_Fake._() {
    _onScannedDevicesFounded = StreamController.broadcast();
    _onScanningStateChange = StreamController.broadcast();
    _onAdapterStateChange = StreamController.broadcast();
  }

  late final StreamController<BT_Device> _onNesDevicesFounded;
  late final StreamController<Iterable<BT_Device>> _onScannedDevicesFounded;
  late final StreamController<bool> _onScanningStateChange;
  late final StreamController<bool> _onAdapterStateChange;

  @override
  List<BT_Device_Impl_Fake> devices = [];

  @override
  bool get isBluetoothOn => true;

  @override
  bool isScanning = false;

  @override
  StreamSubscription<BT_Device> onFoundNewDevice(void Function(BT_Device results) onFoundNewDevice) {
    return _onNesDevicesFounded.stream.listen(onFoundNewDevice);
  }

  @override
  StreamSubscription<Iterable<BT_Device>> onScanDevices(void Function(Iterable<BT_Device> results) onScanDevices) {
    return _onScannedDevicesFounded.stream.listen(onScanDevices);
  }

  @override
  StreamSubscription<bool> onScanningStateChange(void Function(bool state) onScanningStateChange) {
    return _onScanningStateChange.stream.listen(onScanningStateChange);
  }

  @override
  StreamSubscription<bool> onAdapterStateChange(void Function(bool state) onAdapterStateChange) {
    return _onAdapterStateChange.stream.listen(onAdapterStateChange);
  }

  Timer? _scanClock;
  Timer? _scanMain;

  @override
  Future<void> scanOff() {
    _scanClock?.cancel();
    _scanMain?.cancel();
    return Future(() => null);
  }

  @override
  Future<void> scanOn({double duration = 15}) {
    _scanClock = Timer(Duration(seconds: duration.toInt()), () { scanOff(); });
    _scanMain = Timer.periodic(const Duration(seconds: 1), (timer) {
      BT_Device_Impl_Fake device = BT_Device_Impl_Fake(
        "address",
        "data",
        0,
        "name",
        this,
        Iterable.generate(0),
      );
      devices.add(device);
      _onNesDevicesFounded.add(device);
    });
    return Future(() => null);
  }

  @override
  Future<void> turnOff() {
    return Future(() => null);
  }

  @override
  Future<void> turnOn() {
    return Future(() => null);
  }

}