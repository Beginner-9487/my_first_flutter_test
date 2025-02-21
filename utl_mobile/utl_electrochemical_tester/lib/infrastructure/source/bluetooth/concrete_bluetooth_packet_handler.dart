import 'dart:async';

import 'package:synchronized/synchronized.dart';
import 'package:utl_electrochemical_tester/adapter/electrochemical_devices/dto/electrochemical_device_received_dto.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/bluetooth/bluetooth_packet_handler.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/bluetooth/bluetooth_received_packet.dart';

class ConcreteBluetoothPacketHandler extends BluetoothPacketHandler {
  final Lock _packetsLock = Lock();
  ConcreteBluetoothPacketHandler();
  @override
  void handleReceivedPacket({
    required BluetoothReceivedPacket packet,
  }) async {
    return _packetsLock.synchronized(() async {
      var headerBuffer = packet.mapToHeader();
      if(headerBuffer != null) _validPacketStreamController.add(headerBuffer);
      var dataBuffer = packet.mapToData();
      if(dataBuffer != null) _validPacketStreamController.add(dataBuffer);
      return;
    });
  }
  final StreamController _validPacketStreamController = StreamController.broadcast();
  void dispose() {
    _validPacketStreamController.close();
  }

  @override
  Stream<ElectrochemicalDeviceReceivedDataDto> get electrochemicalDataStream =>
      _validPacketStreamController
          .stream
          .where((packet) => packet is ElectrochemicalDeviceReceivedDataDto)
          .map((packet) => packet as ElectrochemicalDeviceReceivedDataDto);

  @override
  Stream<ElectrochemicalDeviceReceivedHeaderDto> get electrochemicalHeaderStream =>
      _validPacketStreamController
          .stream
          .where((packet) => packet is ElectrochemicalDeviceReceivedHeaderDto)
          .map((packet) => packet as ElectrochemicalDeviceReceivedHeaderDto);
}
