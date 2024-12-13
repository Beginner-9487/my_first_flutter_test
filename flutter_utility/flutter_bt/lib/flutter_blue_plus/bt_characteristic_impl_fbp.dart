import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bt/bt.dart';
import 'package:flutter_bt/bt_impl.dart';
import 'package:flutter_bt/flutter_blue_plus/bt_descriptor_impl_fbp.dart';
import 'package:flutter_bt/flutter_blue_plus/bt_device_impl_fbp.dart';
import 'package:flutter_bt/flutter_blue_plus/bt_provider_impl_fbp.dart';
import 'package:flutter_bt/flutter_blue_plus/bt_service_impl_fbp.dart';
import 'package:flutter_utility/general_utils.dart';

class BT_Characteristic_Impl_FBP extends BT_Characteristic {
  final BluetoothCharacteristic characteristic;
  BT_Characteristic_Impl_FBP(this.provider, this.device, this.service, this.characteristic);

  @override
  BT_Provider_Impl_FBP provider;
  @override
  BT_Device_Impl_FBP device;
  @override
  BT_Service_Impl_FBP service;
  @override
  Iterable<BT_Descriptor_Impl_FBP> get descriptors => characteristic
      .descriptors
      .map(
          (item) => BT_Descriptor_Impl_FBP(
            provider,
            device,
            service,
            this,
            item,
          ));

  @override
  String get uuid => characteristic.uuid.str128;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is BT_Characteristic_Impl_FBP && other.uuid == uuid);

  @override
  int get hashCode => uuid.hashCode;

  @override
  bool get isNotified => characteristic.isNotifying;
  @override
  Future<bool> changeNotify() async {
    return setNotify(!characteristic.isNotifying);
  }
  @override
  Future<bool> setNotify(bool value) async {
    return characteristic
        .setNotifyValue(value)
        .then((value) {
          device.onNotificationChangeController.add(this);
          return value;
        });
  }
  @override
  StreamSubscription<BT_Characteristic> onNotificationStageChange(void Function(BT_Characteristic characteristic) onNotificationStageChange) {
    return device.onNotificationChangeController.stream.map((event) => this).listen(onNotificationStageChange);
  }

  @override
  BT_Characteristic_Properties get properties => BT_Characteristic_Properties_Impl_FBP(this);

  BT_Packet_Characteristic_Impl_Base getPacket(Uint8List bytes) {
    return BT_Packet_Characteristic_Impl_Base(
      bytes,
      provider,
      device,
      service,
      this,
    );
  }

  @override
  Future<BT_Packet_Characteristic> read() async {
    try {
      return characteristic.read().then((value) => getPacket(value.asUint8List()));
    } catch (e) {
      return getPacket(Uint8List(0));
    }
  }

  @override
  Future<bool> write(BT_Packet packet) async {
    try {
      return characteristic.write(packet.bytes.toList()).then((value) => true);
    } catch (e) {
      return false;
    }
  }

  @override
  StreamSubscription<BT_Packet_Characteristic> onReceiveNotifiedPacket(void Function(BT_Packet_Characteristic packet) onReceiveNotifiedPacket) {
    return characteristic
        .onValueReceived
        .map((event) => getPacket(event.asUint8List()))
        .listen(onReceiveNotifiedPacket);
  }

  @override
  StreamSubscription<BT_Packet_Characteristic> onReceiveAllPacket(void Function(BT_Packet_Characteristic packet) onReceiveAllPacket) {
    return characteristic
        .lastValueStream
        .map((event) => getPacket(event.asUint8List()))
        .listen(onReceiveAllPacket);
  }
}

class BT_Characteristic_Properties_Impl_FBP extends BT_Characteristic_Properties_Impl {
  @override
  BT_Provider get provider => characteristic.provider;
  @override
  BT_Device get device => characteristic.device;
  @override
  BT_Service get service => characteristic.service;
  @override
  BT_Characteristic_Impl_FBP characteristic;
  CharacteristicProperties get p => characteristic.characteristic.properties;
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
  BT_Characteristic_Properties_Impl_FBP(this.characteristic);
}