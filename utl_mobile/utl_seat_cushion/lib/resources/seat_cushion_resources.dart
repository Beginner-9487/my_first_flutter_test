import 'package:utl_seat_cushion/domain/use_case/seat_cushion_use_case.dart';

class SeatCushionResources {
  SeatCushionResources._();
  static final SeatCushionSaveOptions defaultSaveOptions = SeatCushionSaveOptions(
    saveToBufferOption: true,
    saveToDatabaseOption: false,
  );
}