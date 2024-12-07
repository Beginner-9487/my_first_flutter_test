import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bt/bt.dart';
import 'package:flutter_bt/bt_impl.dart';
import 'package:utl_mobile/utl_bluetooth/utl_bt_handler.dart';

class UTL_BT_Handler_Impl implements UTL_BT_Handler {
  static double readingRssiDelay = 0.1;
  static late final Timer readingRssi;
  static late final UTL_BT_Handler_Impl _instance;
  static UTL_BT_Handler_Impl init({
    required BT_Provider bt_provider,
    Iterable<String> input_UUID = const [],
    Iterable<String> output_UUID = const [],
  }) {
    _instance = UTL_BT_Handler_Impl._(
      bt_provider: bt_provider,
      input_UUID: input_UUID,
      output_UUID: output_UUID,
    );
    readingRssi = Timer.periodic(const Duration(microseconds: 100), (timer) {
      for (var element in bt_provider.devices) {
        element.fetchRssi();
      }
    });
    return _instance;
  }
  UTL_BT_Handler_Impl._({
    required this.bt_provider,
    this.input_UUID = const [],
    this.output_UUID = const [],
  });
  @override
  BT_Provider bt_provider;
  Iterable<String> input_UUID;
  Iterable<String> output_UUID;

  late final StreamSubscription<BT_Device> _onNewDevicesFounded;
  final StreamController<BT_Packet_Characteristic> _onReceivePacketController = StreamController.broadcast();
  @override
  StreamSubscription<BT_Packet_Characteristic> onReceivePacket(void Function(BT_Packet_Characteristic packet) onReceivedPacket) {
    return _onReceivePacketController.stream.listen(onReceivedPacket);
  }

  Future _send(BT_Packet packet) async {
    if(input_UUID.isEmpty) {
      return;
    }
    for (var device in bt_provider
        .devices
        .where((element) => element.isConnected && element.isDiscovered)
    ) {
      for (var service in device.services) {
        for (var characteristic in service.characteristics) {
          if(input_UUID.contains(characteristic.uuid)) {
            characteristic.write(packet);
          }
          for (var descriptor in characteristic.descriptors) {
            if(input_UUID.contains(descriptor.uuid)) {
              descriptor.write(packet);
            }
          }
        }
      }
    }
  }

  @override
  Future connect(BT_Device device) async {
    return device.connect().then((value) {
      device.discover().then((value) {
        _UTL_BT_Subscription.clear(device);
        if(input_UUID.isEmpty) {
          return;
        }
        for (var device in bt_provider
            .devices
            .where((element) => element.isConnected && element.isDiscovered)
        ) {
          for (var service in device.services) {
            for (var characteristic in service.characteristics) {
              if(output_UUID.contains(characteristic.uuid)) {
                characteristic.setNotify(true);
                _UTL_BT_Subscription.add(
                  device,
                  characteristic.onReceiveNotifiedPacket((packet) {
                    _onReceivePacketController.add(packet);
                  }),
                );
              }
              for (var descriptor in characteristic.descriptors) {
                if(output_UUID.contains(descriptor.uuid)) {
                  _UTL_BT_Subscription.add(
                    device,
                    descriptor.onReceiveNotifiedPacket((packet) {
                      _onReceivePacketController.add(packet);
                    }),
                  );
                }
              }
            }
          }
        }
      });
    });
  }

  @override
  Future disconnect(BT_Device device) async {
    return device.disconnect();
  }

  @override
  Future sendBytes(Uint8List bytes) {
    BT_Packet packet = BT_Packet_Impl.createByBytes(bytes);
    return _send(packet);
  }

  @override
  Future sendHexString(String hexString) {
    BT_Packet packet = BT_Packet_Impl.createByHexString(hexString);
    return _send(packet);
  }
}

class _UTL_BT_Subscription {
  _UTL_BT_Subscription._(this.device, this.event);
  static final List<_UTL_BT_Subscription> _subscriptions = [];
  static void add(BT_Device device, StreamSubscription<BT_Packet_Characteristic> event) {
    _subscriptions.add(_UTL_BT_Subscription._(
      device,
      event,
    ));
  }
  static void clear(BT_Device device) {
    _subscriptions
        .where((element) => element.device == device)
        .forEach((element) {element.event.cancel();});
    _subscriptions
        .removeWhere((element) => element.device == device);
  }
  BT_Device device;
  StreamSubscription<BT_Packet_Characteristic> event;
}
