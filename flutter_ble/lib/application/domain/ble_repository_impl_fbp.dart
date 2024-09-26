import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_ble/utils/extra.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_util/cracking_code/bytes_converter.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/utils/flutter_blue_plus_peripheral_infrastructure.dart';

class BLERepositoryImplFBP extends BLERepository {

  late StreamSubscription<List<ScanResult>> _onScanResult;

  late final StreamController<BLEDeviceImplFBP> _onNewDeviceFounded;
  late final StreamController<BLEDeviceImplFBP> _onNewNamedDeviceFounded;

  late final StreamController<Iterable<BLEDeviceImplFBP>> _onConnectableDevicesFounded;
  late final StreamController<Iterable<BLEDeviceImplFBP>> _onScannedDevicesFounded;
  late final StreamController<Iterable<BLEDeviceImplFBP>> _onNearbyDevicesFounded;
  late final StreamController<Iterable<BLEDeviceImplFBP>> _onNamedDevicesFounded;
  late final StreamController<Iterable<BLEDeviceImplFBP>> _onAllDevicesFounded;

  final List<(BLEDevice, StreamSubscription<bool>)> _onConnectingStreamSubscriptions = [];
  final List<(BLEDevice, StreamSubscription<bool>)> _onDisconnectingStreamSubscriptions = [];
  final List<(BLEDevice, StreamSubscription<bool>)> _onConnectionStateChangeStreamSubscriptions = [];

  late final StreamController<(BLEDevice, int)> _onRssiChangeController;
  final List<(BLEDevice, Timer)> _readingRssiTimers = [];

  late final StreamController<(BLEDevice, bool)> _onDiscoveringServicesStateChangeController;
  late final StreamController<(BLEDevice, Iterable<BLEService>)> _onNewServicesDiscoveredController;

  static BLERepositoryImplFBP? _instance;
  static BLERepositoryImplFBP getInstance() {
    _instance ??= BLERepositoryImplFBP._();
    return _instance!;
  }

  BLERepositoryImplFBP._() {
    _onScanResult = FlutterBluePlus.scanResults.listen(_updateDevices);

    _onNewDeviceFounded = StreamController.broadcast();
    _onNewNamedDeviceFounded = StreamController.broadcast();

    _onConnectableDevicesFounded = StreamController.broadcast();
    _onScannedDevicesFounded = StreamController.broadcast();
    _onNearbyDevicesFounded = StreamController.broadcast();
    _onNamedDevicesFounded = StreamController.broadcast();
    _onAllDevicesFounded = StreamController.broadcast();

    _onRssiChangeController = StreamController.broadcast();

    _onDiscoveringServicesStateChangeController = StreamController.broadcast();
    _onNewServicesDiscoveredController = StreamController.broadcast();
  }

  @override
  bool get isBluetoothOn => FlutterBluePlus.adapterStateNow == BluetoothAdapterState.on;
  @override
  bool get isScanning => FlutterBluePlus.isScanningNow;
  @override
  Iterable<BLEDeviceImplFBP> get connectableDevices => allDevices
      .where((element) => element._result != null && element._result!.advertisementData.connectable);
  @override
  Iterable<BLEDeviceImplFBP> get connectedDevices => allDevices
      .where((element) => element.isConnected);
  @override
  Iterable<BLEDeviceImplFBP> get scannedDevices => scanResults
      .map((e) => BLEDeviceImplFBP._byScanResult(this, e));
  @override
  Iterable<BLEDeviceImplFBP> get nearbyDevices => allDevices
      .where((element) => element.isNearby);
  @override
  Iterable<BLEDeviceImplFBP> get namedDevices => allDevices
      .where((element) => element.name.isNotEmpty);
  @override
  Iterable<BLEDeviceImplFBP> get allDevices => systemDevices
      .map((e) => BLEDeviceImplFBP._bySystemDevice(this, e.$1));

  // device, isServicesDiscovered, services
  final List<(BluetoothDevice, RestorableBool, List<BluetoothService>)> systemDevices = [];
  List<ScanResult> scanResults = [];

  _handleNewDeviceInScanResults(ScanResult result) {
    BluetoothDevice device = result.device;
    RestorableBool bool = RestorableBool(false);
    FormFieldState().registerForRestoration(bool, 'isServicesDiscovered');
    systemDevices.add((device, bool, []));
    scanResults.add(result);

    var deviceImplFBP = BLEDeviceImplFBP._byScanResult(this, result);
    _onNewDeviceFounded.add(deviceImplFBP);
    if(deviceImplFBP.name.isNotEmpty) {
      _onNewNamedDeviceFounded.add(deviceImplFBP);
    }

    _onConnectingStreamSubscriptions.add((
      deviceImplFBP,
      device.isConnecting.listen((event) {
        deviceImplFBP.isConnecting = event;
      }),
    ));

    _onDisconnectingStreamSubscriptions.add((
      deviceImplFBP,
      device.isDisconnecting.listen((event) {
        deviceImplFBP.isDisconnecting = event;
      }),
    ));

    _onConnectionStateChangeStreamSubscriptions.add((
      deviceImplFBP,
      deviceImplFBP.onConnectStateChange((isConnected) {
        if(!isConnected) {
          deviceImplFBP._clearOldServices();
        }
      }),
    ));
  }
  _handleOldDeviceInScanResults(ScanResult result) {}

  _updateDevices(List<ScanResult> results) async {
    scanResults.clear();
    scanResults = results;
    for(int i=0; i<results.length; i++) {
      bool isExisted = false;
      for(BluetoothDevice device in systemDevices.map((e) => e.$1)) {
        if(device == results[i].device) {
          isExisted = true;
          break;
        }
      }
      if(isExisted) {
        _handleOldDeviceInScanResults(results[i]);
      } else {
        _handleNewDeviceInScanResults(results[i]);
      }
    }
    _onScannedDevicesFounded.add(scannedDevices);
    _onAllDevicesFounded.add(allDevices);

    _onConnectableDevicesFounded.add(connectedDevices);
    _onNearbyDevicesFounded.add(nearbyDevices);
    _onNamedDevicesFounded.add(namedDevices);

    // debugPrint("BLERepositoryImplFBP.connectableDevices: ${connectableDevices.length}");
    // debugPrint("BLERepositoryImplFBP.connectedDevices: ${connectedDevices.length}");
    // debugPrint("BLERepositoryImplFBP.scannedDevices: ${scannedDevices.length}");
    // debugPrint("BLERepositoryImplFBP.nearbyDevices: ${nearbyDevices.length}");
    // debugPrint("BLERepositoryImplFBP.namedDevices: ${namedDevices.length}");
    // debugPrint("BLERepositoryImplFBP.allDevices: ${allDevices.length}");
  }
  _isNearbyDevice(ScanResult? result) {
    return (result != null) ? false : ((result!.advertisementData.txPowerLevel != null) ? true : false);  // TODO 不確定這樣是否正確
  }

  /// ==========================================================================
  /// Bluetooth Switch, Scan
  @override
  turnOn() async {
    FlutterBluePlusPeripheralInfrastructure.turnOn();
  }
  @override
  turnOff() async {
    FlutterBluePlusPeripheralInfrastructure.turnOff();
  }
  @override
  scanOn({int duration = 15}) {
    FlutterBluePlusPeripheralInfrastructure.scanOn(duration: duration);
  }
  @override
  scanOff() {
    FlutterBluePlusPeripheralInfrastructure.scanOff();
  }
  @override
  StreamSubscription<bool> onSwitchChange(void Function(bool state) doSomething) {
    return FlutterBluePlus.adapterState
        .map((event) => event == BluetoothAdapterState.on)
        .listen(doSomething);
  }
  @override
  StreamSubscription<bool> onScanningStateChange(void Function(bool state) doSomething) {
    return FlutterBluePlus.isScanning
        .listen(doSomething);
  }
  @override
  StreamSubscription<BLEDeviceImplFBP> onNewDeviceFounded(void Function(BLEDeviceImplFBP result) doSomething) {
    return _onNewDeviceFounded.stream
        .listen(doSomething);
  }
  @override
  StreamSubscription<BLEDeviceImplFBP> onNewNamedDeviceFounded(void Function(BLEDeviceImplFBP result) doSomething) {
    return _onNewNamedDeviceFounded.stream
        .listen(doSomething);
  }
  @override
  StreamSubscription<Iterable<BLEDeviceImplFBP>> onConnectableDevicesFounded(void Function(Iterable<BLEDeviceImplFBP> results) doSomething) {
    return _onConnectableDevicesFounded.stream
        .listen(doSomething);
  }
  @override
  StreamSubscription<Iterable<BLEDeviceImplFBP>> onScannedDevicesFounded(void Function(Iterable<BLEDeviceImplFBP> results) doSomething) {
    return _onScannedDevicesFounded.stream
        .listen(doSomething);
  }
  @override
  StreamSubscription<Iterable<BLEDeviceImplFBP>> onNearbyDevicesFounded(void Function(Iterable<BLEDeviceImplFBP> results) doSomething) {
    return _onNearbyDevicesFounded.stream
        .listen(doSomething);
  }
  @override
  StreamSubscription<Iterable<BLEDeviceImplFBP>> onNamedDevicesFounded(void Function(Iterable<BLEDeviceImplFBP> results) doSomething) {
    return _onNamedDevicesFounded.stream
        .listen(doSomething);
  }
  @override
  StreamSubscription<Iterable<BLEDeviceImplFBP>> onAllDevicesFounded(void Function(Iterable<BLEDeviceImplFBP> results) doSomething) {
    return _onAllDevicesFounded.stream
        .listen(doSomething);
  }
}

class BLEDeviceImplFBP extends BLEDevice {

  ScanResult? _result;
  BluetoothDevice _device;
  (BluetoothDevice, RestorableBool, List<BluetoothService>) get _deviceWithServices => repository.systemDevices
      .where((element) => element.$1 == _device)
      .first;

  factory BLEDeviceImplFBP._bySystemDevice(BLERepositoryImplFBP repository, BluetoothDevice device) {
    return BLEDeviceImplFBP._(repository, device: device);
  }
  factory BLEDeviceImplFBP._byScanResult(BLERepositoryImplFBP repository, ScanResult result) {
    return BLEDeviceImplFBP._(repository, result: result, device: result.device);
  }

  BLEDeviceImplFBP._(
      this.repository,
      {
        ScanResult? result,
        required BluetoothDevice device
      }
  ) : _result = result, _device = device;

  @override
  BLERepositoryImplFBP repository;
  @override
  Iterable<BLEServiceImplFBP> get services => _deviceWithServices
      .$3
      .map((e) => BLEServiceImplFBP(
          repository,
          this,
          e,
      ));

  @override
  String get name => _device.platformName;
  @override
  String get address => _device.remoteId.str;
  @override
  String get platformName => _device.platformName;
  @override
  int get rssi => ((_result != null) ? _result!.rssi : 0);
  @override
  int get mtuSize => _device.mtuNow;
  @override
  bool get connectable => (_result != null) ? _result!.advertisementData.connectable : true;
  @override
  bool get isNearby => repository._isNearbyDevice(_result);

  /// ==========================================================================
  /// Manufacturer Data
  @override
  String get manufacturerData => (_result != null) ? _getNiceManufacturerData(_result!.advertisementData.manufacturerData) : "";
  String _getNiceManufacturerData(Map<int, List<int>> data) {
    return data.entries
        .map((entry) => '${entry.key.toRadixString(16)}: ${_getNiceHexArray(entry.value)}')
        .join(', ')
        .toUpperCase();
  }
  String _getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]';
  }

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
  readRssi({int timeout = 15}) async {
    try{
      await _device.readRssi(timeout: timeout);
      repository._onRssiChangeController.sink.add((this, rssi));
    } catch(e) {}
  }

  @override
  readingRssi(bool isReading, {int delayMilliseconds = 1000}) {
    for(var bt in repository._readingRssiTimers) {
      if(bt.$1 == this) {
        bt.$2.cancel();
        repository._readingRssiTimers.remove(bt);
        return;
      }
    }
    if(isReading) {
      repository._readingRssiTimers.add((
          this,
          Timer.periodic(
              Duration(milliseconds: delayMilliseconds),
              (timer) async {
                await readRssi();
              },
          ),
      ));
    }
  }

  /// ==========================================================================
  /// Mtu

  @override
  onMtuChange(void Function(int mtu) doSomething) {
    return _device.mtu.listen(doSomething);
  }

  @override
  readMtu({int timeout = 15}) async {
    try{
      await _device.requestMtu(223);
      repository._onRssiChangeController.sink.add((this, rssi));
    } catch(e) {}
  }

  @override
  readingMtu(bool isReading, {int delayMilliseconds = 1000}) {
    for(var bt in repository._readingRssiTimers) {
      if(bt.$1 == this) {
        bt.$2.cancel();
        repository._readingRssiTimers.remove(bt);
        return;
      }
    }
    if(isReading) {
      repository._readingRssiTimers.add((
      this,
      Timer.periodic(
        Duration(milliseconds: delayMilliseconds),
            (timer) async {
          await readRssi();
        },
      ),
      ));
    }
  }

  /// ==========================================================================
  /// Connecting

  @override
  bool isConnecting = false;
  @override
  onConnecting (void Function(bool isConnecting) doSomething) {
    return _device.isConnecting.listen(doSomething);
  }

  @override
  bool isDisconnecting = false;
  @override
  onDisconnecting (void Function(bool value) doSomething) {
    return _device.isDisconnecting.listen(doSomething);
  }

  /// ==========================================================================
  /// Connect
  @override
  StreamSubscription<bool> onConnectStateChange(void Function(bool isConnected) doSomething) {
    return _device.connectionState
        .map((event) => event == BluetoothConnectionState.connected)
        .listen(doSomething);
  }
  @override
  bool get isConnected => _device.isConnected;
  @override
  Future<bool> connect() async {
    return await FlutterBluePlusPeripheralInfrastructure.connect(_device);
  }
  @override
  Future<bool> cancel() async {
    return await FlutterBluePlusPeripheralInfrastructure.disconnect(_device);
  }
  @override
  Future<bool> disconnect() async {
    return await FlutterBluePlusPeripheralInfrastructure.disconnect(_device);
  }

  /// ==========================================================================
  /// Services
  @override
  bool isDiscoveringServices = false;
  _updateServices() async {
    _deviceWithServices
    .$3..clear()..addAll(await _device.discoverServices());
    _deviceWithServices.$2.value = true;
  }

  _clearOldServices() {
    if(_deviceWithServices.$2.value) {
      _deviceWithServices.$2.value = false;
      _deviceWithServices.$3.clear();
    }
  }

  @override
  bool get isServicesDiscovered => _deviceWithServices
      .$2.value;

  @override
  Future<bool> discoverServices() async {
    if(isServicesDiscovered) {return true;}

    isDiscoveringServices = true;
    repository._onDiscoveringServicesStateChangeController.sink.add((
      this,
      isDiscoveringServices,
    ));

    bool success = false;
    try {
      await _updateServices();
      success = true;
    } catch (e) {
      debugPrint("ERROR: discoverServices: $e");
    }

    isDiscoveringServices = false;
    repository._onDiscoveringServicesStateChangeController.sink.add((
      this,
      isDiscoveringServices,
    ));

    repository._onNewServicesDiscoveredController.sink.add((
      this,
      services,
    ));

    return success;
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

class BLEServiceImplFBP extends BLEService {
  final BluetoothService _service;
  BLEServiceImplFBP(this.repository, this.device, this._service);

  @override
  BLERepositoryImplFBP repository;
  @override
  BLEDeviceImplFBP device;

  @override
  String get uuid => _service.uuid.str128;

  @override
  Iterable<BLECharacteristicImplFBP> get characteristics => _service.characteristics
      .map((item) => BLECharacteristicImplFBP(
        repository,
        device,
        this,
        item,
      ));
}

class BLECharacteristicImplFBP extends BLECharacteristic {
  final BluetoothCharacteristic _characteristic;
  BLECharacteristicImplFBP(this.repository, this.device, this.service, this._characteristic);

  @override
  BLERepositoryImplFBP repository;
  @override
  BLEDeviceImplFBP device;
  @override
  BLEServiceImplFBP service;
  @override
  Iterable<BLEDescriptorImplFBP> get descriptors => _characteristic
      .descriptors
      .map(
          (item) => BLEDescriptorImplFBP(
        repository,
        device,
        service,
        this,
        item,
      ));

  @override
  String get uuid => _characteristic.uuid.str128;

  // ===========================================================================
  // Notify
  @override
  bool get isNotified => _characteristic.isNotifying;
  @override
  Future<bool> changeNotify() async {
    await _characteristic.setNotifyValue(!_characteristic.isNotifying);
    return true;
  }
  @override
  Future<bool> setNotify(bool value) async {
    await _characteristic.setNotifyValue(value);
    return true;
  }

  /// ==========================================================================
  /// Properties
  @override
  BLECharacteristicProperties get properties => BLECharacteristicPropertiesImplFBP(_characteristic);

  @override
  readData() async {
    return BLEPacketImplFBP.createByRaw(await _characteristic.read());
  }

  @override
  writeData(BLEPacket packet) async {
    _characteristic.write(packet.raw);
  }

  @override
  onReadNotifiedData(void Function(BLEPacket packet) doSomething) {
    return _characteristic.onValueReceived
        .map((event) => BLEPacketImplFBP.createByRaw(event))
        .listen(doSomething);
  }

  @override
  onReadAllData(void Function(BLEPacket packet) doSomething) {
    return _characteristic.lastValueStream
        .map((event) => BLEPacketImplFBP.createByRaw(event))
        .listen(doSomething);
  }
}

class BLEDescriptorImplFBP extends BLEDescriptor {
  BluetoothDescriptor descriptor;
  BLEDescriptorImplFBP(this.repository, this.device, this.service, this.characteristic, this.descriptor);

  @override
  BLERepositoryImplFBP repository;
  @override
  BLEDeviceImplFBP device;
  @override
  BLEServiceImplFBP service;
  @override
  BLECharacteristicImplFBP characteristic;

  @override
  String get uuid => descriptor.uuid.str128;

  @override
  readData() async {
    return BLEPacketImplFBP.createByRaw(await descriptor.read());
  }

  @override
  writeData(BLEPacket packet) async {
    descriptor.write(packet.raw);
  }

  @override
  onReadNotifiedData(void Function(BLEPacket packet) doSomething) {
    return descriptor.onValueReceived
        .map((event) => BLEPacketImplFBP.createByRaw(event))
        .listen(doSomething);
  }

  @override
  onReadAllData(void Function(BLEPacket packet) doSomething) {
    return descriptor.lastValueStream
        .map((event) => BLEPacketImplFBP.createByRaw(event))
        .listen(doSomething);
  }
}

class BLECharacteristicPropertiesImplFBP extends BLECharacteristicProperties {
  @override
  bool get broadcast => p.broadcast;
  @override
  bool get read => p.read;
  @override
  bool get writeWithoutResponse => p.writeWithoutResponse;
  @override
  bool get write => p.write;
  @override
  bool get notify => p.notify;
  @override
  bool get indicate => p.indicate;
  @override
  bool get authenticatedSignedWrites => p.authenticatedSignedWrites;
  @override
  bool get extendedProperties => p.extendedProperties;
  @override
  bool get notifyEncryptionRequired => p.notifyEncryptionRequired;
  @override
  bool get indicateEncryptionRequired => p.indicateEncryptionRequired;
  BluetoothCharacteristic characteristic;
  CharacteristicProperties get p => characteristic.properties;
  BLECharacteristicPropertiesImplFBP(this.characteristic);
}

class BLEPacketImplFBP implements BLEPacket {
  @override
  List<int> raw;
  BLEPacketImplFBP._(this.raw);
  factory BLEPacketImplFBP.createByRaw(List<int> raw) {
    return BLEPacketImplFBP._(raw);
  }
  factory BLEPacketImplFBP.createByHexString(String hexString) {
    return BLEPacketImplFBP._(BytesConverter.hexStringToByteArray(hexString));
  }
}