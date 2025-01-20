import 'package:utl_seat_cushion/infrastructure/bluetooth/bluetooth_packet.dart';
import 'package:utl_seat_cushion/domain/model/entity/seat_cushion_entity.dart';

abstract class BluetoothDtoHandler {
  void addPacket({
    required BluetoothPacket packet,
  });
  Stream<SeatCushionEntity> get seatCushionEntityStream;
}
