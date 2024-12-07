import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bt/bt.dart';
import 'package:flutter_bt/bt_impl.dart';

class BT_Descriptor_Impl_Fake implements BT_Descriptor {
  BT_Descriptor_Impl_Fake(
      this.characteristic,
      this.device,
      this.provider,
      this.service,
      this.uuid,
      );

  final StreamController<BT_Packet_Descriptor> onReadAllDataController = StreamController.broadcast();
  final StreamController<BT_Packet_Descriptor> onReadNotifiedDataController = StreamController.broadcast();

  @override
  BT_Device device;

  @override
  StreamSubscription<BT_Packet_Descriptor> onReceiveAllPacket(void Function(BT_Packet_Descriptor packet) onReceiveAllPacket) {
    return onReadAllDataController.stream.listen(onReceiveAllPacket);
  }

  @override
  StreamSubscription<BT_Packet_Descriptor> onReceiveNotifiedPacket(void Function(BT_Packet_Descriptor packet) onReceiveNotifiedPacket) {
    return onReadNotifiedDataController.stream.listen(onReceiveNotifiedPacket);
  }

  @override
  BT_Provider provider;

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
  Future<BT_Packet_Descriptor_Impl_Base> read() {
    return Future(() => getPacket(Uint8List(0)));
  }

  @override
  BT_Service service;

  @override
  String uuid;

  @override
  Future<bool> write(BT_Packet packet) {
    return Future(() => true);
  }

  @override
  BT_Characteristic characteristic;
}