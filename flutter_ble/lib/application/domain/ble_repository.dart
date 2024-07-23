import 'dart:async';

import 'package:equatable/equatable.dart';

abstract class BLERepository {
  bool get isBluetoothOn;
  bool get isScanning;
  Iterable<BLEDevice> get connectableDevices;
  Iterable<BLEDevice> get connectedDevices;
  Iterable<BLEDevice> get scannedDevices;
  Iterable<BLEDevice> get nearbyDevices;
  Iterable<BLEDevice> get namedDevices;
  Iterable<BLEDevice> get allDevices;

  turnOn();
  turnOff();
  scanOn();
  scanOff();

  StreamSubscription<bool> onSwitchChange(void Function(bool state) doSomething);
  StreamSubscription<bool> onScanningStateChange(void Function(bool state) doSomething);
  StreamSubscription<BLEDevice> onNewDeviceFounded(void Function(BLEDevice result) doSomething);
  StreamSubscription<BLEDevice> onNewNamedDeviceFounded(void Function(BLEDevice result) doSomething);
  StreamSubscription<Iterable<BLEDevice>> onConnectableDevicesFounded(void Function(Iterable<BLEDevice> results) doSomething);
  StreamSubscription<Iterable<BLEDevice>> onScannedDevicesFounded(void Function(Iterable<BLEDevice> results) doSomething);
  StreamSubscription<Iterable<BLEDevice>> onNearbyDevicesFounded(void Function(Iterable<BLEDevice> results) doSomething);
  StreamSubscription<Iterable<BLEDevice>> onNamedDevicesFounded(void Function(Iterable<BLEDevice> results) doSomething);
  StreamSubscription<Iterable<BLEDevice>> onAllDevicesFounded(void Function(Iterable<BLEDevice> results) doSomething);

  BLEDevice? findDeviceByAddress(String address) {
    for(BLEDevice device in allDevices) {
      if(device.address == address) {return device;}
    }
  }
}

abstract class BLEDevice extends Equatable {
  BLERepository get repository;
  Iterable<BLEService> get services;

  String get name;
  String get address;
  String get platformName;
  int get rssi;
  int get mtuSize;
  String get manufacturerData;
  bool get connectable;
  bool get isNearby;

  bool get isConnecting;
  bool get isDisconnecting;
  bool get isConnected;
  Future<bool> connect();
  Future<bool> cancel();
  Future<bool> disconnect();

  bool get isServicesDiscovered;
  bool get isDiscoveringServices;
  Future<bool> discoverServices();

  readRssi({int timeout});
  readingRssi(bool isReading, {int delayMilliseconds});
  StreamSubscription<int> onRssiChange(void Function(int rssi) doSomething);
  readMtu({int timeout});
  readingMtu(bool isReading, {int delayMilliseconds});
  StreamSubscription<int> onMtuChange(void Function(int mtu) doSomething);
  StreamSubscription<bool> onConnectStateChange(void Function(bool isConnected) doSomething);
  StreamSubscription<bool> onConnecting(void Function(bool isConnecting) doSomething);
  StreamSubscription<bool> onDisconnecting(void Function(bool isDisonnecting) doSomething);
  StreamSubscription<bool> onDiscoveringServicesStateChange(void Function(bool isDiscoveringServices) doSomething);
  StreamSubscription<Iterable<BLEService>> onNewServicesDiscovered(void Function(Iterable<BLEService> services) doSomething);

  @override
  List<Object?> get props => [address];

  BLEService? findServiceByUUID(String uuid) {
    for(BLEService service in services) {
      if(service.uuid == uuid) {
        return service;
      }
    }
  }
  BLECharacteristic? findCharacteristicByUUID(String uuid) {
    for(BLEService service in services) {
      for(BLECharacteristic characteristic in service.characteristics) {
        if(characteristic.uuid == uuid) {
          return characteristic;
        }
      }
    }
  }
  BLEDescriptor? findDescriptorByUUID(String uuid) {
    for(BLEService service in services) {
      for(BLECharacteristic characteristic in service.characteristics) {
        for(BLEDescriptor descriptor in characteristic.descriptors) {
          if(descriptor.uuid == uuid) {
            return descriptor;
          }
        }
      }
    }
  }
}

abstract class BLEService extends Equatable {
  BLERepository get repository;
  BLEDevice get device;
  Iterable<BLECharacteristic> get characteristics;

  String get uuid;

  @override
  List<Object?> get props => [uuid];
}

abstract class BLECharacteristic extends Equatable {
  BLERepository get repository;
  BLEDevice get device;
  BLEService get service;
  Iterable<BLEDescriptor> get descriptors;

  String get uuid;

  bool get isNotified;
  Future<bool> changeNotify();
  Future<bool> setNotify(bool value);

  BLECharacteristicProperties get properties;

  Future<BLEPacket> readData();
  writeData(BLEPacket packet, {int delay = 100});

  StreamSubscription<BLEPacket> onReadNotifiedData(void Function(BLEPacket packet) doSomething);
  StreamSubscription<BLEPacket> onReadAllData(void Function(BLEPacket packet) doSomething);

  @override
  List<Object?> get props => [uuid];
}

abstract class BLEDescriptor<Repository, Device, Service, Characteristic> extends Equatable {
  Repository get repository;
  Device get device;
  Service get service;
  Characteristic get characteristic;

  String get uuid;

  Future<BLEPacket> readData();
  writeData(BLEPacket packet, {int delay = 100});

  StreamSubscription<BLEPacket> onReadNotifiedData(void Function(BLEPacket packet) doSomething);
  StreamSubscription<BLEPacket> onReadAllData(void Function(BLEPacket packet) doSomething);

  @override
  List<Object?> get props => [uuid];
}

abstract class BLECharacteristicProperties {
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

abstract class BLEPacket {
  List<int> get raw;
}