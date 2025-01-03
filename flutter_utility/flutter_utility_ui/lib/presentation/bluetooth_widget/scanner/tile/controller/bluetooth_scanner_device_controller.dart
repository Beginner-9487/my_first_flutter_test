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