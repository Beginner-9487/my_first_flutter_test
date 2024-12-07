import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bt/bt.dart';
import 'package:flutter_bt/bt_impl.dart';

class BT_Characteristic_Impl_Fake implements BT_Characteristic {
  BT_Characteristic_Impl_Fake(
      this.descriptors, 
      this.device,
      this.provider,
      this.service,
      this.uuid,
      );

  final StreamController<BT_Characteristic> _controller = StreamController.broadcast();

  final StreamController<BT_Packet_Characteristic> onReadAllDataController = StreamController.broadcast();
  final StreamController<BT_Packet_Characteristic> onReadNotifiedDataController = StreamController.broadcast();

  @override
  Future<bool> changeNotify() {
    return Future(() => true);
  }

  @override
  Iterable<BT_Descriptor> descriptors;

  @override
  BT_Device device;

  @override
  bool get isNotified => true;

  @override
  StreamSubscription<BT_Packet_Characteristic> onReceiveAllPacket(void Function(BT_Packet_Characteristic packet) onReceiveAllPacket) {
    return onReadAllDataController.stream.listen(onReceiveAllPacket);
  }

  @override
  StreamSubscription<BT_Packet_Characteristic> onReceiveNotifiedPacket(void Function(BT_Packet_Characteristic packet) onReceiveNotifiedPacket) {
    return onReadNotifiedDataController.stream.listen(onReceiveNotifiedPacket);
  }

  @override
  BT_Characteristic_Properties get properties => BT_Characteristic_PropertiesImpl_Fake(this);

  @override
  BT_Provider provider;

  BT_Packet_Characteristic getPacket(Uint8List bytes) {
    return BT_Packet_Characteristic_Impl_Base(
      bytes,
      provider,
      device,
      service,
      this,
    );
  }

  @override
  Future<BT_Packet_Characteristic> read() {
    return Future(() => getPacket(Uint8List(0)));
  }

  @override
  BT_Service service;

  @override
  Future<bool> setNotify(bool value) {
    return Future(() => true);
  }

  @override
  String uuid;

  @override
  Future<bool> write(BT_Packet packet) {
    return Future(() => true);
  }

  @override
  StreamSubscription<BT_Characteristic> onNotificationStageChange(void Function(BT_Characteristic characteristic) doSomething) {
    return _controller.stream.listen(doSomething);
  }
}

class BT_Characteristic_PropertiesImpl_Fake implements BT_Characteristic_Properties {
  BT_Characteristic_PropertiesImpl_Fake(this.characteristic);

  @override
  BT_Provider get provider => characteristic.provider;

  @override
  BT_Device get device => characteristic.device;

  @override
  BT_Service get service => characteristic.service;

  @override
  BT_Characteristic characteristic;

  @override
  bool get authenticatedSignedWrites => true;

  @override
  bool get broadcast => true;

  @override
  bool get extendedProperties => true;

  @override
  bool get indicate => true;

  @override
  bool get indicateEncryptionRequired => true;

  @override
  bool get notify => true;

  @override
  bool get notifyEncryptionRequired => true;

  @override
  bool get read => true;

  @override
  bool get write => true;

  @override
  bool get writeWithoutResponse => true;
  
}