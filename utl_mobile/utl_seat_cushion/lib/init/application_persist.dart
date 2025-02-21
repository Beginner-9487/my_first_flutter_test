import 'package:utl_seat_cushion/controller/seat_cushion_data_view_controller.dart';
import 'package:utl_seat_cushion/application/seat_cushion_devices_data_handler.dart';
import 'package:utl_seat_cushion/service/user_file_handler.dart';
import 'package:utl_seat_cushion/init/usecase_registry.dart';

class ApplicationPersist {
  ApplicationPersist._();
  static void init() {
    seatCushionDevicesDataHandler = SeatCushionDevicesDataHandler(
      fetchReceiveSeatCushionEntityStreamUseCase: UseCaseRegistry.fetchReceiveSeatCushionEntityStreamUseCase,
      saveSeatCushionEntityUseCase: UseCaseRegistry.saveSeatCushionEntityUseCase,
    );
  }
  static late final SeatCushionDevicesDataHandler seatCushionDevicesDataHandler;
}
