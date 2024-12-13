import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bt/bt.dart';
import 'package:flutter_bt/bt_impl.dart';
import 'package:flutter_bt/flutter_blue_plus/bt_characteristic_impl_fbp.dart';
import 'package:flutter_bt/flutter_blue_plus/bt_device_impl_fbp.dart';
import 'package:flutter_bt/flutter_blue_plus/bt_provider_impl_fbp.dart';
import 'package:flutter_bt/flutter_blue_plus/bt_service_impl_fbp.dart';
import 'package:flutter_utility/general_utils.dart';

class BT_Descriptor_Impl_FBP extends BT_Descriptor {
  BluetoothDescriptor descriptor;
  BT_Descriptor_Impl_FBP(this.provider, this.device, this.service, this.characteristic, this.descriptor);

  @override
  BT_Provider_Impl_FBP provider;
  @override
  BT_Device_Impl_FBP device;
  @override
  BT_Service_Impl_FBP service;
  @override
  BT_Characteristic_Impl_FBP characteristic;

  @override
  String get uuid => descriptor.uuid.str128;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is BT_Descriptor_Impl_FBP && other.uuid == uuid);

  @override
  int get hashCode => uuid.hashCode;

  BT_Packet_Descriptor_Impl_Base getPacket(Uint8List bytes) {
    return BT_Packet_Descriptor_Impl_Base(
      bytes,
      provider,
      device,
      service,
      characteristic,
      this,
    );
  }

  @override
  Future<BT_Packet_Descriptor> read() async {
    try {
      return descriptor.read().then((value) => getPacket(value.asUint8List()));
    } catch (e) {
      return getPacket(Uint8List(0));
    }
  }

  @override
  Future<bool> write(BT_Packet packet) async {
    try {
      return descriptor.write(packet.bytes.toList()).then((value) => true);
    } catch (e) {
      return false;
    }
  }

  @override
  StreamSubscription<BT_Packet_Descriptor> onReceiveNotifiedPacket(void Function(BT_Packet_Descriptor packet) onReceiveNotifiedPacket) {
    return descriptor
        .onValueReceived
        .map((event) => getPacket(event.asUint8List()))
        .listen(onReceiveNotifiedPacket);
  }

  @override
  StreamSubscription<BT_Packet_Descriptor> onReceiveAllPacket(void Function(BT_Packet_Descriptor packet) onReceiveAllPacket) {
    return descriptor
        .lastValueStream
        .map((event) => getPacket(event.asUint8List()))
        .listen(onReceiveAllPacket);
  }
}