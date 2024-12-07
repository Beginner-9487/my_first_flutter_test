import 'dart:async';

import 'package:flutter_bt/bt.dart';

class BT_Device_Impl_Fake implements BT_Device {
  BT_Device_Impl_Fake(
      this.address,
      this.manufacturerData,
      this.mtu,
      this.name,
      this.provider,
      this.services,
      );

  final StreamController _controller = StreamController.broadcast();

  @override
  String address;

  @override
  Future<bool> cancel() {
    return Future(() => true);
  }

  @override
  Future<bool> connect() {
    return Future(() => true);
  }

  @override
  bool get isConnectable => true;

  @override
  Future<bool> disconnect() {
    return Future(() => true);
  }

  @override
  Future<bool> discover() {
    return Future(() => true);
  }

  @override
  bool get isConnected => true;

  @override
  bool get isDiscovered => true;

  @override
  bool get isScanned => true;

  @override
  String manufacturerData;

  @override
  int mtu;

  @override
  String name;

  @override
  StreamSubscription<BT_Device> onConnectionStateChange(void Function(BT_Device device) onConnectionStateChange) {
    return _controller.stream.map((event) => this).listen(onConnectionStateChange);
  }

  @override
  StreamSubscription<BT_Device> onDiscoveryStateChange(void Function(BT_Device device) onDiscoveryStateChange) {
    return _controller.stream.map((event) => this).listen(onDiscoveryStateChange);
  }

  @override
  StreamSubscription<BT_Device> onMtuChange(void Function(BT_Device device) onMtuChange) {
    return _controller.stream.map((event) => this).listen(onMtuChange);
  }

  @override
  StreamSubscription<BT_Device> onRssiChange(void Function(BT_Device device) onRssiChange) {
    return _controller.stream.map((event) => this).listen(onRssiChange);
  }

  @override
  BT_Provider provider;

  @override
  Future<int> fetchRssi({int timeout = 15}) {
    return Future(() => rssi);
  }

  @override
  Future<int> requestMtu(int mtu, {int timeout = 15}) {
    return Future(() => mtu);
  }

  @override
  int get rssi => 0;

  @override
  Iterable<BT_Service> services;

  @override
  bool get isPaired => true;

  @override
  StreamSubscription<BT_Device> onPairingStateChange(void Function(BT_Device device) onPairingStateChange) {
    return _controller.stream.map((event) => this).listen(onPairingStateChange);
  }

  @override
  Future<bool> pair() {
    return Future(() => true);
  }

  @override
  Future<bool> unpair() {
    return Future(() => true);
  }

}
