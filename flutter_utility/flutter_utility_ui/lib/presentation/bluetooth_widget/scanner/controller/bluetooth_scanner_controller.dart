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