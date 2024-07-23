import 'package:flutter/cupertino.dart';
import 'package:flutter_ble/application/domain/ble_repository_impl_fbp.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// DeviceName, DeviceAddress, ServicesUUID, SecondaryServiceUuid, CharacteristicUUID, DescriptorUUID
final List<(String, String, List<(Guid, Guid, List<(Guid, BmCharacteristicProperties, List<Guid>)>)>)> _uuidList = [
  (
    "Fake Device",
    "Fake Device - address",
    [
      (
        Guid("6e400000-b5a3-f393-e0a9-e50e24dcca9e"),
        Guid("6e400001-b5a3-f393-e0a9-e50e24dcca9e"),
        [
          (
            Guid("6e400010-b5a3-f393-e0a9-e50e24dcca9e"),
            BmCharacteristicProperties(
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
            ),
            [
              Guid("6e400110-b5a3-f393-e0a9-e50e24dcca9e"),
            ],
          )
        ],
      ),
      (
        Guid("6e400110-b5a3-f393-e0a9-e50e24dcca9e"),
        Guid("6e410110-b5a3-f393-e0a9-e50e24dcca9e"),
        [
          (
            Guid("6e420110-b5a3-f393-e0a9-e50e24dcca9e"),
            BmCharacteristicProperties(
              broadcast: false,
              read: true,
              writeWithoutResponse: false,
              write: true,
              notify: true,
              indicate: false,
              authenticatedSignedWrites: false,
              extendedProperties: false,
              notifyEncryptionRequired: false,
              indicateEncryptionRequired: false,
            ),
            [],
          )
        ],
      ),
    ],
  )
];

class BLERepositoryImplFBPTrueWithFake {
  final BLERepositoryImplFBP _bleRepositoryImplFBP;
  static BLERepositoryImplFBPTrueWithFake? _instance;
  static BLERepositoryImplFBPTrueWithFake getInstance(BLERepositoryImplFBP bleRepositoryImplFBP) {
    _instance ??= BLERepositoryImplFBPTrueWithFake._(bleRepositoryImplFBP);
    return _instance!;
  }
  BLERepositoryImplFBPTrueWithFake._(this._bleRepositoryImplFBP) {
    RestorableBool bool = RestorableBool(false);
    FormFieldState().registerForRestoration(bool, 'isServicesDiscovered');
    _bleRepositoryImplFBP.systemDevices.add((
      BluetoothDeviceFake(0),
      bool,
      [],
    ));
  }
}

class BluetoothDeviceFake extends BluetoothDevice {
  int index;
  (String, String, List<(Guid, Guid, List<(Guid, BmCharacteristicProperties, List<Guid>)>)>) get _uuid => _uuidList[index];
  BluetoothDeviceFake(this.index) : super(
      remoteId: DeviceIdentifier(_uuidList[index].$2),
  );

  @override
  String get platformName => _uuid
      .$1;
  Iterable<Guid> get _servicesUUID => _uuid
      .$3
      .map((e) => e.$1);
  List<(Guid, Guid, List<(Guid, BmCharacteristicProperties, List<Guid>)>)> get _services => _uuid.$3;

  @override
  bool isConnected = false;

  @override
  Future<void> connect({
    Duration timeout = const Duration(seconds: 35),
    int? mtu = 512,
    bool autoConnect = false,
  }) async {
    isConnected = true;
  }

  @override
  Future<void> disconnect({
    int timeout = 35,
    bool queue = true,
  }) async {
    isConnected = false;
  }

  @override
  Future<List<BluetoothService>> discoverServices({
    bool subscribeToServicesChanged = true,
    int timeout = 15,
  }) async {
    return _services
        .map((s) => BluetoothService.fromProto(
          BmBluetoothService(
            serviceUuid: s.$1,
            remoteId: remoteId,
            isPrimary: true,
            characteristics: s
                .$3
                .map((c) => BmBluetoothCharacteristic(
                  remoteId: remoteId,
                  serviceUuid: s.$1,
                  secondaryServiceUuid: s.$2,
                  characteristicUuid: c.$1,
                  descriptors: c
                      .$3
                      .map((d) => BmBluetoothDescriptor(
                        remoteId: remoteId,
                        serviceUuid: s.$1,
                        characteristicUuid: c.$1,
                        descriptorUuid: d,
                      ))
                      .toList(),
                  properties: c.$2,
                ))
                .toList(),
            includedServices: [],
          ),
        ))
        .toList();
  }
}