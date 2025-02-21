import 'package:utl_seat_cushion/domain/repository/seat_cushion_repository.dart';

class SeatCushionResources {
  SeatCushionResources._();
  static final SeatCushionSaveOptions defaultSaveOptions = SeatCushionSaveOptions(
    saveToBufferOption: true,
    saveToDatabaseOption: false,
  );
}