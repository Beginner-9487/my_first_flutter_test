import 'dart:async';

import 'package:async_locks/async_locks.dart';
import 'package:utl_electrochemical_tester/adapter/dto/electrochemical_device_received_dto.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/bluetooth/bluetooth_packet_handler.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/bluetooth/bluetooth_received_packet.dart';

class ConcreteBluetoothPacketHandler extends BluetoothPacketHandler {
  Lock packetsLock = Lock();
  ConcreteBluetoothPacketHandler();
  @override
  void handleReceivedPacket({
    required BluetoothReceivedPacket packet,
  }) async {
    try {
      await packetsLock.acquire();
      var headerBuffer = packet.mapToHeader();
      if(headerBuffer != null) _validPacketStreamController.add(headerBuffer);
      var dataBuffer = packet.mapToData();
      if(dataBuffer != null) _validPacketStreamController.add(dataBuffer);
      return;
    } catch(e) {
      return;
    } finally {
      packetsLock.release();
    }
  }
  final StreamController _validPacketStreamController = StreamController.broadcast();
  void dispose() {
    _validPacketStreamController.close();
    packetsLock.cancelAll();
  }

  @override
  Stream<ElectrochemicalDeviceReceivedDataDto> get electrochemicalDataStream =>
      _validPacketStreamController
          .stream
          .where((packet) => packet is ElectrochemicalDeviceReceivedDataDto) as Stream<ElectrochemicalDeviceReceivedDataDto>;

  @override
  Stream<ElectrochemicalDeviceReceivedHeaderDto> get electrochemicalHeaderStream =>
      _validPacketStreamController
          .stream
          .where((packet) => packet is ElectrochemicalDeviceReceivedHeaderDto) as Stream<ElectrochemicalDeviceReceivedHeaderDto>;
}
