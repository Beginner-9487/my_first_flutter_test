import 'dart:typed_data';

import 'package:flutter_bt/bt.dart';
import 'package:flutter_utility/other_utility.dart';

class BT_Packet_Impl implements BT_Packet {
  @override
  Uint8List bytes;
  BT_Packet_Impl._(this.bytes);
  factory BT_Packet_Impl.createByBytes(Uint8List bytes) {
    return BT_Packet_Impl._(bytes);
  }
  factory BT_Packet_Impl.createByHexString(String hexString) {
    return BT_Packet_Impl._(hexString.hexToUint8List());
  }
}

abstract class BT_Characteristic_Properties_Impl implements BT_Characteristic_Properties {
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (
          other is BT_Characteristic_Properties_Impl &&
          other.broadcast == broadcast &&
          other.read == read &&
          other.writeWithoutResponse == writeWithoutResponse &&
          other.write == write &&
          other.notify == notify &&
          other.indicate == indicate &&
          other.authenticatedSignedWrites == authenticatedSignedWrites &&
          other.extendedProperties == extendedProperties &&
          other.notifyEncryptionRequired == notifyEncryptionRequired &&
          other.indicateEncryptionRequired == indicateEncryptionRequired
      );
}

class BT_Packet_Characteristic_Impl_Base implements BT_Packet_Characteristic {
  BT_Packet_Characteristic_Impl_Base(
      this.bytes,
      this.provider,
      this.device,
      this.service,
      this.characteristic,
      );
  @override
  Uint8List bytes;
  @override
  BT_Provider provider;
  @override
  BT_Device device;
  @override
  BT_Service service;
  @override
  BT_Characteristic characteristic;
}

class BT_Packet_Descriptor_Impl_Base implements BT_Packet_Descriptor {
  BT_Packet_Descriptor_Impl_Base(
      this.bytes,
      this.provider,
      this.device,
      this.service,
      this.characteristic,
      this.descriptor,
      );
  @override
  Uint8List bytes;
  @override
  BT_Provider provider;
  @override
  BT_Device device;
  @override
  BT_Service service;
  @override
  BT_Characteristic characteristic;
  @override
  BT_Descriptor descriptor;
}