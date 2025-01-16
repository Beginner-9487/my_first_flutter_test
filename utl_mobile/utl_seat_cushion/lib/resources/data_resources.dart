import 'package:shared_preferences/shared_preferences.dart';
import 'package:utl_seat_cushion/domain/data/seat_cushion_data.dart';

class DataResources {
  DataResources._();
  static late final SharedPreferences sharedPreferences;
  static late final SeatCushionBufferProvider seatCushionBufferProvider;
  static late final SeatCushionRepository seatCushionRepository;
  static late final SeatCushionSaveOptionsProvider seatCushionSaveOptionsProvider;
  static late final SeatCushionDevicesProvider seatCushionDevicesProvider;
}
