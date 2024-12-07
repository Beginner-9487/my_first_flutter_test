import 'dart:async';
import 'dart:typed_data';

abstract class BT_Provider {
  bool get isBluetoothOn;
  bool get isScanning;
  Iterable<BT_Device> get devices;

  Future<void> turnOn();
  Future<void> turnOff();
  Future<void> scanOn({double duration = 15});
  Future<void> scanOff();

  StreamSubscription<bool> onAdapterStateChange(void Function(bool state) onAdapterStateChange);
  StreamSubscription<bool> onScanningStateChange(void Function(bool state) onScanningStateChange);
  StreamSubscription<BT_Device> onFoundNewDevice(void Function(BT_Device device) onFoundNewDevice);
  StreamSubscription<Iterable<BT_Device>> onScanDevices(void Function(Iterable<BT_Device> devices) onScanDevices);
}

abstract class BT_Device {
  BT_Provider get provider;
  Iterable<BT_Service> get services;

  String get name;
  String get address;
  String get manufacturerData;
  bool get isConnectable;
  bool get isScanned;
  bool get isConnected;
  Future<bool> connect();
  Future<bool> disconnect();
  Future<bool> cancel();
  StreamSubscription<BT_Device> onConnectionStateChange(void Function(BT_Device device) onConnectionStateChange);

  bool get isPaired;
  Future<bool> pair();
  Future<bool> unpair();
  StreamSubscription<BT_Device> onPairingStateChange(void Function(BT_Device device) onPairingStateChange);

  bool get isDiscovered;
  Future<bool> discover();
  StreamSubscription<BT_Device> onDiscoveryStateChange(void Function(BT_Device device) onDiscoveryStateChange);

  int get rssi;
  Future<int> fetchRssi({int timeout = 15});
  StreamSubscription<BT_Device> onRssiChange(void Function(BT_Device device) onRssiChange);

  int get mtu;
  Future<int> requestMtu(int mtu, {int timeout = 15});
  StreamSubscription<BT_Device> onMtuChange(void Function(BT_Device device) onMtuChange);
}

abstract class BT_Service {
  BT_Provider get provider;
  BT_Device get device;
  Iterable<BT_Characteristic> get characteristics;
  String get uuid;
}

abstract class BT_Characteristic {
  BT_Provider get provider;
  BT_Device get device;
  BT_Service get service;
  Iterable<BT_Descriptor> get descriptors;

  String get uuid;

  bool get isNotified;
  Future<bool> changeNotify();
  Future<bool> setNotify(bool value);
  StreamSubscription<BT_Characteristic> onNotificationStageChange(void Function(BT_Characteristic characteristic) onNotificationStageChange);

  BT_Characteristic_Properties get properties;

  Future<BT_Packet_Characteristic> read();
  Future<bool> write(BT_Packet packet);

  StreamSubscription<BT_Packet_Characteristic> onReceiveNotifiedPacket(void Function(BT_Packet_Characteristic packet) onReceiveNotifiedPacket);
  StreamSubscription<BT_Packet_Characteristic> onReceiveAllPacket(void Function(BT_Packet_Characteristic packet) onReceiveAllPacket);
}

abstract class BT_Descriptor {
  BT_Provider get provider;
  BT_Device get device;
  BT_Service get service;
  BT_Characteristic get characteristic;

  String get uuid;

  Future<BT_Packet_Descriptor> read();
  Future<bool> write(BT_Packet packet);

  StreamSubscription<BT_Packet_Descriptor> onReceiveNotifiedPacket(void Function(BT_Packet_Descriptor packet) onReceiveNotifiedPacket);
  StreamSubscription<BT_Packet_Descriptor> onReceiveAllPacket(void Function(BT_Packet_Descriptor packet) onReceiveAllPacket);
}

abstract class BT_Characteristic_Properties {
  BT_Provider get provider;
  BT_Device get device;
  BT_Service get service;
  BT_Characteristic get characteristic;
  bool get broadcast;
  bool get read;
  bool get writeWithoutResponse;
  bool get write;
  bool get notify;
  bool get indicate;
  bool get authenticatedSignedWrites;
  bool get extendedProperties;
  bool get notifyEncryptionRequired;
  bool get indicateEncryptionRequired;
}

abstract class BT_Packet {
  Uint8List get bytes;
}

abstract class BT_Packet_Characteristic implements BT_Packet {
  BT_Provider get provider;
  BT_Device get device;
  BT_Service get service;
  BT_Characteristic get characteristic;
}

abstract class BT_Packet_Descriptor implements BT_Packet_Characteristic {
  BT_Descriptor get descriptor;
}
