import 'dart:async';
import 'dart:typed_data';

import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_device.dart';
import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_received_packet.dart';
import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_sent_packet.dart';
import 'package:utl_mobile/utl_bluetooth/utl_bluetooth_handler.dart';

abstract class BluetoothDevicesService {
  Iterable<FbpBluetoothDevice> get devices;
  sendBytes(Uint8List bytes);
  sendHexString(String string);
  Stream<HeaderReceivedPacket> get onReceiveHeaderPacket;
  Stream<DataReceivedPacket> get onReceivedDataPacket;
  Future startCa(CaSentPacket packet);
  Future startCv(CvSentPacket packet);
  Future startDpv(DpvSentPacket packet);
}

class ConcreteBluetoothDevicesService implements BluetoothDevicesService {
  UtlBluetoothHandler<FbpBluetoothDevice> handler;
  @override
  Iterable<FbpBluetoothDevice> get devices => handler.devices;
  ConcreteBluetoothDevicesService({
    required this.handler,
  }) {
    _onReceivePacket = handler.onReceivePacket.listen((packet) {
      
    });
  }
  @override
  sendBytes(Uint8List bytes) {
    handler.sendBytes(bytes);
  }
  @override
  sendHexString(String string) {
    handler.sendHexString(string);
  }
  final StreamController<HeaderReceivedPacket> _headerController = StreamController();
  final StreamController<DataReceivedPacket> _dataController = StreamController();
  late final StreamSubscription<UtlReceivedBluetoothPacket> _onReceivePacket;
  @override
  Stream<HeaderReceivedPacket> get onReceiveHeaderPacket => _headerController.stream;
  @override
  Stream<DataReceivedPacket> get onReceivedDataPacket => _dataController.stream;

  @override
  Future startCa(CaSentPacket packet) async {
    sendBytes(packet.data);
  }

  @override
  Future startCv(CvSentPacket packet) async {
    sendBytes(packet.data);
  }

  @override
  Future startDpv(DpvSentPacket packet) async {
    sendBytes(packet.data);
  }
}