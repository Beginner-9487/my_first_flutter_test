import 'package:shared_preferences/shared_preferences.dart';
import 'package:utl_seat_cushion/domain/repository/seat_cushion_device.dart';
import 'package:utl_seat_cushion/domain/repository/seat_cushion_repository.dart';

class DataResources {
  DataResources._();
  static late final SharedPreferences sharedPreferences;
  static late final SeatCushionRepository seatCushionRepository;
  static late final SeatCushionDevicesProvider seatCushionDevicesProvider;
}
