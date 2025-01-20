import 'package:utl_seat_cushion/application/controller/seat_cushion_data_view_controller.dart';
import 'package:utl_seat_cushion/application/seat_cushion_devices_data_handler.dart';
import 'package:utl_seat_cushion/application/user_file_handler.dart';
import 'package:utl_seat_cushion/resources/usecase_registry.dart';

class ApplicationResources {
  ApplicationResources._();
  static SeatCushionDevicesDataHandler get seatCushionDevicesDataHandler => SeatCushionDevicesDataHandler(
    fetchReceiveSeatCushionEntityStreamUseCase: UseCaseRegistry.fetchReceiveSeatCushionEntityStreamUseCase,
    saveSeatCushionEntityUseCase: UseCaseRegistry.saveSeatCushionEntityUseCase,
  );
  static SeatCushionDataViewController get seatCushionDataViewController => ConcreteSeatCushionDataViewController(
    fetchLastSeatCushionEntityUseCase: UseCaseRegistry.fetchLastSeatCushionUseCase,
    fetchLastSeatCushionEntityStreamUseCase: UseCaseRegistry.fetchLastSeatCushionEntityStreamUseCase,
    clearAllSeatCushionEntitiesUseCase: UseCaseRegistry.clearAllEntitiesUseCase,
    getSeatCushionOptionsStreamUseCase: UseCaseRegistry.getOptionsStreamUseCase,
    getSeatCushionOptionsUseCase: UseCaseRegistry.getOptionsUseCase,
    setSeatCushionOptionsUseCase: UseCaseRegistry.setOptionsUseCase,
    sendCommandToAllSeatCushionDeviceUseCase: UseCaseRegistry.sendCommandUseCase,
    fileHandler: fileHandler,
  );
  static FileHandler get fileHandler => ConcreteFileHandler(
    handleSeatCushionEntitiesUseCase: UseCaseRegistry.handleSeatCushionEntitiesUseCase,
    fetchSeatCushionEntitiesLengthUseCase: UseCaseRegistry.fetchEntitiesLengthUseCase,
  );
}
