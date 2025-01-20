import 'package:utl_seat_cushion/domain/model/entity/seat_cushion_entity.dart';

abstract class SeatCushionDevicesProvider {
  Future<bool> sendCommand({
    required String command,
  });
  Stream<SeatCushionEntity> get receiveSeatCushionEntityStream;
}
