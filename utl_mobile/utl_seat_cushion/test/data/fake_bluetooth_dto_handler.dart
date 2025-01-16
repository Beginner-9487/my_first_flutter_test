import 'dart:async';

import 'package:utl_seat_cushion/infrastructure/bluetooth/bluetooth_dto_handler.dart';
import 'package:utl_seat_cushion/infrastructure/bluetooth/bluetooth_packet.dart';
import 'package:utl_seat_cushion/domain/entities/seat_cushion_entity.dart';

class FakeBluetoothDtoHandler extends BluetoothDtoHandler {
  @override
  void addPacket({
    required BluetoothPacket packet,
  }) {
    return;
  }
  addSeatCushionEntity({
    required SeatCushionEntity entity,
  }) {
    _seatCushionDataStreamController.add(entity);
  }
  @override
  Stream<SeatCushionEntity> get seatCushionEntityStream => _seatCushionDataStreamController.stream;
  FakeBluetoothDtoHandler();
  final StreamController<SeatCushionEntity> _seatCushionDataStreamController = StreamController.broadcast();
  void dispose() {
    _seatCushionDataStreamController.close();
  }
}
