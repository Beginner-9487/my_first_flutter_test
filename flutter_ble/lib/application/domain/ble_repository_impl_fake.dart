import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_util/cracking_code/bytes_converter.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';

class BLERepositoryImplFake extends BLERepository {

  late final StreamController<bool> _onSwitchChange;

  late final StreamController<BLEDeviceImplFake> _onNewDeviceFounded;
  late final StreamController<BLEDeviceImplFake> _onNewNamedDeviceFounded;

  late final StreamController<Iterable<BLEDeviceImplFake>> _onSConnectableDevicesFounded;
  late final StreamController<Iterable<BLEDeviceImplFake>> _onScannedDevicesFounded;
  late final StreamController<Iterable<BLEDeviceImplFake>> _onNearbyDevicesFounded;
  late final StreamController<Iterable<BLEDeviceImplFake>> _onNamedDevicesFounded;
  late final StreamController<Iterable<BLEDeviceImplFake>> _onAllDevicesFounded;

  final List<(BLEDevice, StreamSubscription<bool>)> _onConnectingStreamSubscriptions = [];
  final List<(BLEDevice, StreamSubscription<bool>)> _onDisconnectingStreamSubscriptions = [];

  late final StreamController<(BLEDevice, int)> _onRssiChangeController;

  final List<(BLEDevice, Timer)> _readingRssiTimers = [];

  late final StreamController<(BLEDevice, bool)> _onDiscoveringServicesStateChangeController;
  late final StreamController<(BLEDevice, Iterable<BLEService>)> _onNewServicesDiscoveredController;

  late final StreamController<(BLEDevice, int)> _onMtuChangeController;
  late final StreamController<(BLEDevice, bool)> _onConnectingController;
  late final StreamController<(BLEDevice, bool)> _onDisconnectingController;
  late final StreamController<(BLEDevice, bool)> _onConnectionStateChangeController
  ;
  late final StreamController<(BLEDevice, BLEPacketImplFake)> _onReceivedPacketController;

  static BLERepositoryImplFake? _instance;
  static BLERepositoryImplFake getInstance() {
    _instance ??= BLERepositoryImplFake._();
    return _instance!;
  }

  BLERepositoryImplFake._() {
    _onSwitchChange = StreamController.broadcast();

    _onNewDeviceFounded = StreamController.broadcast();
    _onNewNamedDeviceFounded = StreamController.broadcast();
    _onSConnectableDevicesFounded = StreamController.broadcast();
    _onScannedDevicesFounded = StreamController.broadcast();
    _onNearbyDevicesFounded = StreamController.broadcast();
    _onNamedDevicesFounded = StreamController.broadcast();
    _onAllDevicesFounded = StreamController.broadcast();
    _onRssiChangeController = StreamController.broadcast();
    _onDiscoveringServicesStateChangeController = StreamController.broadcast();
    _onNewServicesDiscoveredController = StreamController.broadcast();

    _onMtuChangeController = StreamController.broadcast();
    _onConnectingController = StreamController.broadcast();
    _onDisconnectingController = StreamController.broadcast();
    _onConnectionStateChangeController = StreamController.broadcast();
    _onReceivedPacketController = StreamController.broadcast();
  }

  @override
  bool get isBluetoothOn => true;
  @override
  bool isScanning = false;
  @override
  Iterable<BLEDeviceImplFake> get connectableDevices => allDevices;
  @override
  Iterable<BLEDeviceImplFake> get connectedDevices => allDevices.where((element) => element.isConnected);
  @override
  Iterable<BLEDeviceImplFake> scannedDevices = [];
  @override
  Iterable<BLEDeviceImplFake> get nearbyDevices => allDevices.where((element) => element.isNearby);
  @override
  Iterable<BLEDeviceImplFake> get namedDevices => allDevices.where((element) => element.name.isNotEmpty);
  @override
  Iterable<BLEDeviceImplFake> allDevices = [];

  /// ==========================================================================
  /// Bluetooth Switch, Scan
  @override
  turnOn() async {}
  @override
  turnOff() async {}
  @override
  scanOn() {
    if(allDevices.isEmpty) {
      BLEDeviceImplFake deviceImplFake = BLEDeviceImplFake(this, "name", "address", "platformName", 0, 0, "manufacturerData");
      allDevices = [
        deviceImplFake,
      ];
      _onNewDeviceFounded.sink.add(deviceImplFake);
      _onNewNamedDeviceFounded.sink.add(deviceImplFake);
      _onSConnectableDevicesFounded.sink.add(connectableDevices);
      _onScannedDevicesFounded.sink.add(scannedDevices);
      _onNearbyDevicesFounded.sink.add(nearbyDevices);
      _onNamedDevicesFounded.sink.add(namedDevices);
      _onAllDevicesFounded.sink.add(allDevices);
    }
  }
  @override
  scanOff() {}
  @override
  StreamSubscription<bool> onSwitchChange(void Function(bool state) doSomething) {
    return _onSwitchChange.stream.listen(doSomething);
  }
  @override
  StreamSubscription<bool> onScanningStateChange(void Function(bool state) doSomething) {
    return FlutterBluePlus.isScanning.listen(doSomething);
  }
  @override
  StreamSubscription<BLEDeviceImplFake> onNewDeviceFounded(void Function(BLEDeviceImplFake result) doSomething) {
    return _onNewDeviceFounded.stream.listen(doSomething);
  }
  @override
  StreamSubscription<BLEDeviceImplFake> onNewNamedDeviceFounded(void Function(BLEDeviceImplFake result) doSomething) {
    return _onNewNamedDeviceFounded.stream.listen(doSomething);
  }
  @override
  StreamSubscription<Iterable<BLEDeviceImplFake>> onConnectableDevicesFounded(void Function(Iterable<BLEDeviceImplFake> results) doSomething) {
    return _onSConnectableDevicesFounded.stream.listen(doSomething);
  }
  @override
  StreamSubscription<Iterable<BLEDeviceImplFake>> onScannedDevicesFounded(void Function(Iterable<BLEDeviceImplFake> results) doSomething) {
    return _onScannedDevicesFounded.stream.listen(doSomething);
  }
  @override
  StreamSubscription<Iterable<BLEDeviceImplFake>> onNearbyDevicesFounded(void Function(Iterable<BLEDeviceImplFake> results) doSomething) {
    return _onNearbyDevicesFounded.stream.listen(doSomething);
  }
  @override
  StreamSubscription<Iterable<BLEDeviceImplFake>> onNamedDevicesFounded(void Function(Iterable<BLEDeviceImplFake> results) doSomething) {
    return _onNamedDevicesFounded.stream.listen(doSomething);
  }
  @override
  StreamSubscription<Iterable<BLEDeviceImplFake>> onAllDevicesFounded(void Function(Iterable<BLEDeviceImplFake> results) doSomething) {
    return _onAllDevicesFounded.stream.listen(doSomething);
  }
}

class BLEDeviceImplFake extends BLEDevice {
  BLEDeviceImplFake(
      this.repository,
      this.name,
      this.address,
      this.platformName,
      this.rssi,
      this.mtuSize,
      this.manufacturerData,
  );

  @override
  BLERepositoryImplFake repository;
  @override
  Iterable<BLEServiceImplFake> services = [];

  @override
  String name;
  @override
  String address;
  @override
  String platformName;
  @override
  int rssi;
  @override
  int mtuSize;
  @override
  bool get connectable => true;
  @override
  bool get isNearby => true;

  /// ==========================================================================
  /// Manufacturer Data
  @override
  String manufacturerData;

  /// ==========================================================================
  /// Rssi
  @override
  onRssiChange(void Function(int rssi) doSomething) {
    return repository._onRssiChangeController.stream
        .where((event) => event.$1 == this)
        .map((event) => event.$2)
        .listen(doSomething);
  }

  @override
  readRssi({int timeout = 15}) async {}

  @override
  readingRssi(bool isReading, {int delayMilliseconds = 1000}) {}

  /// ==========================================================================
  /// Mtu

  @override
  onMtuChange(void Function(int mtu) doSomething) {
    return repository._onMtuChangeController.stream
        .where((event) => event.$1.address == address)
        .map((event) => event.$2)
        .listen(doSomething);
  }

  @override
  readMtu({int timeout = 15}) async {}

  @override
  readingMtu(bool isReading, {int delayMilliseconds = 1000}) {}

  /// ==========================================================================
  /// Connecting

  @override
  bool isConnecting = false;
  @override
  onConnecting (void Function(bool isConnecting) doSomething) {
    return repository._onConnectingController.stream
        .where((event) => event.$1.address == address)
        .map((event) => event.$2)
        .listen(doSomething);
  }

  @override
  bool isDisconnecting = false;
  @override
  onDisconnecting (void Function(bool value) doSomething) {
    return repository._onDisconnectingController.stream
        .where((event) => event.$1.address == address)
        .map((event) => event.$2)
        .listen(doSomething);
  }

  /// ==========================================================================
  /// Connect
  @override
  StreamSubscription<bool> onConnectStateChange(void Function(bool isConnected) doSomething) {
    return repository._onConnectionStateChangeController.stream
        .where((event) => event.$1.address == address)
        .map((event) => event.$2)
        .listen(doSomething);
  }
  @override
  bool get isConnected => true;
  @override
  Future<bool> connect() async {
    return true;
  }
  @override
  Future<bool> cancel() async {
    return true;
  }
  @override
  Future<bool> disconnect() async {
    return true;
  }

  /// ==========================================================================
  /// Services
  @override
  bool get isServicesDiscovered => true;

  @override
  bool isDiscoveringServices = false;

  @override
  Future<bool> discoverServices() async {
    if(services.isEmpty) {
      services = [BLEServiceImplFake(repository, this)];
    }
    return true;
  }

  /// ==========================================================================
  /// Discovering Services
  @override
  onDiscoveringServicesStateChange(void Function(bool isDiscoveringServices) doSomething) {
    return repository._onDiscoveringServicesStateChangeController.stream
        .where((event) => event.$1 == this)
        .map((event) => event.$2)
        .listen((isDiscoveringServices) {
      doSomething(isDiscoveringServices);
    });
  }

  @override
  onNewServicesDiscovered(void Function(Iterable<BLEService> services) doSomething) {
    return repository._onNewServicesDiscoveredController.stream
        .where((event) => event.$1 == this)
        .map((event) => event.$2)
        .listen((services) {
          doSomething(services);
        });
  }
}

class BLEServiceImplFake extends BLEService {
  BLEServiceImplFake(this.repository, this.device) {
    characteristics = [
      BLECharacteristicImplFake(
        repository,
        device,
        this,
      )
    ];
  }

  @override
  BLERepositoryImplFake repository;
  @override
  BLEDeviceImplFake device;

  @override
  String get uuid => "${device.address} - s";

  @override
  late Iterable<BLECharacteristicImplFake> characteristics;
}

class BLECharacteristicImplFake extends BLECharacteristic {
  BLECharacteristicImplFake(this.repository, this.device, this.service) {
    descriptors = [
      BLEDescriptorImplFake(
        repository,
        device,
        service,
        this,
      )
    ];
    properties = BLECharacteristicPropertiesImplFake(
        broadcast: true,
        read: true,
        writeWithoutResponse: true,
        write: true,
        notify: true,
        indicate: true,
        authenticatedSignedWrites: true,
        extendedProperties: true,
        notifyEncryptionRequired: true,
        indicateEncryptionRequired: true,
    );
  }

  @override
  BLERepositoryImplFake repository;
  @override
  BLEDeviceImplFake device;
  @override
  BLEServiceImplFake service;
  @override
  late Iterable<BLEDescriptorImplFake> descriptors;

  @override
  String get uuid => "${service.uuid} - c";

  // ===========================================================================
  // Notify
  @override
  bool get isNotified => true;
  @override
  Future<bool> changeNotify() async {
    return true;
  }
  @override
  Future<bool> setNotify(bool value) async {
    return true;
  }

  /// ==========================================================================
  /// Properties
  @override
  late BLECharacteristicProperties properties;

  @override
  readData() async {
    return BLEPacketImplFake.createByRaw([]);
  }

  @override
  writeData(BLEPacket packet, {int delay = 100}) async {}

  @override
  onReadNotifiedData(void Function(BLEPacketImplFake packet) doSomething) {
    return repository._onReceivedPacketController.stream
        .where((event) => event.$1.address == device.address)
        .map((event) => event.$2)
        .listen(doSomething);
  }

  @override
  onReadAllData(void Function(BLEPacketImplFake packet) doSomething) {
    return repository._onReceivedPacketController.stream
        .where((event) => event.$1.address == device.address)
        .map((event) => event.$2)
        .listen(doSomething);
  }
}

class BLEDescriptorImplFake extends BLEDescriptor {
  BLEDescriptorImplFake(this.repository, this.device, this.service, this.characteristic);

  @override
  BLERepositoryImplFake repository;
  @override
  BLEDeviceImplFake device;
  @override
  BLEServiceImplFake service;
  @override
  BLECharacteristicImplFake characteristic;

  @override
  String get uuid => "${characteristic.uuid} - d";

  @override
  readData() async {
    return BLEPacketImplFake.createByRaw([]);
  }

  @override
  writeData(BLEPacket packet, {int delay = 100}) async {}

  @override
  onReadNotifiedData(void Function(BLEPacketImplFake packet) doSomething) {
    return repository._onReceivedPacketController.stream
        .where((event) => event.$1.address == device.address)
        .map((event) => event.$2)
        .listen(doSomething);
  }

  @override
  onReadAllData(void Function(BLEPacketImplFake packet) doSomething) {
    return repository._onReceivedPacketController.stream
        .where((event) => event.$1.address == device.address)
        .map((event) => event.$2)
        .listen(doSomething);
  }
}

class BLECharacteristicPropertiesImplFake extends BLECharacteristicProperties {
  @override
  bool broadcast;
  @override
  bool read;
  @override
  bool writeWithoutResponse;
  @override
  bool write;
  @override
  bool notify;
  @override
  bool indicate;
  @override
  bool authenticatedSignedWrites;
  @override
  bool extendedProperties;
  @override
  bool notifyEncryptionRequired;
  @override
  bool indicateEncryptionRequired;
  BLECharacteristicPropertiesImplFake({
    required this.broadcast,
    required this.read,
    required this.writeWithoutResponse,
    required this.write,
    required this.notify,
    required this.indicate,
    required this.authenticatedSignedWrites,
    required this.extendedProperties,
    required this.notifyEncryptionRequired,
    required this.indicateEncryptionRequired,
  });
}

class BLEPacketImplFake implements BLEPacket {
  @override
  List<int> raw;
  BLEPacketImplFake._(this.raw);
  factory BLEPacketImplFake.createByRaw(List<int> raw) {
    return BLEPacketImplFake._(raw);
  }
  factory BLEPacketImplFake.createByHexString(String hexString) {
    return BLEPacketImplFake._(BytesConverter.hexStringToByteArray(hexString));
  }
}