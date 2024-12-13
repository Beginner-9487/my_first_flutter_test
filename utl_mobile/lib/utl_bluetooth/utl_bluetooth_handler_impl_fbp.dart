import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bt/bt.dart';
import 'package:flutter_bt/bt_impl.dart';
import 'package:utl_mobile/utl_bluetooth/utl_bluetooth_handler.dart';

class UtlBluetoothHandlerImplFBP<Data> implements UtlBluetoothHandler<BluetoothDevice, Data> {
  static late final Timer readingRssi;
  static late final List<BluetoothDevice> _devices;
  static late final StreamSubscription<List<ScanResult>> _scanResults;
  static void init({
    required List<BluetoothDevice> devices,
    required Duration readRssiDelay,
    required void Function(BluetoothDevice device, bool isConnectable) onConnectable,
    required void Function(BluetoothDevice device, int rssi) onRssiChange,
  }) {
    _devices = devices;
    _scanResults = FlutterBluePlus.scanResults.listen((results) {
      for (var result in results) {
        BluetoothDevice? device = _devices.where((device) => device == result.device).firstOrNull;
        if(device == null) {
          device = BluetoothScannerTileDeviceImplFbp.create(bluetoothDevice: result.device);
          devices.add(result.device);
        }
        onConnectable(result.device, result.advertisementData.connectable);
        onRssiChange(result.device, result.rssi);
      }
    });
    readingRssi = Timer.periodic(readRssiDelay, (timer) {
      for (var device in _devices) {
        device.readRssi().then((rssi) => onRssiChange(device, rssi));
      }
    });
  }
  UtlBluetoothHandlerImplFBP({
    required this.dataEncoder,
    required Duration readRssiDelay,
    Iterable<String> inputUuid = const [],
    Iterable<String> outputUuid = const [],
  }) {

  }
  Data Function(UtlBluetoothPacket packet) dataEncoder;

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

  @override
  Data Function(UtlBluetoothPacket packet) dataEncoder;

  @override
  StreamSubscription<Data> onReceiveData(void Function(Data data) onReceiveData) {
    // TODO: implement onReceiveData
    throw UnimplementedError();
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
