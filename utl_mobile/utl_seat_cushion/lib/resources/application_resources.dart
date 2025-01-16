import 'package:utl_seat_cushion/application/controller/seat_cushion_data_view_controller.dart';
import 'package:utl_seat_cushion/application/user_file_handler.dart';
import 'package:utl_seat_cushion/resources/use_case_resources.dart';

class ApplicationResources {
  ApplicationResources._();
  static SeatCushionDataViewController get seatCushionDataViewController => ConcreteSeatCushionDataViewController(
    deleteSeatCushionUseCase: UseCaseResources.deleteSeatCushionUseCase,
    fetchSeatCushionUseCase: UseCaseResources.fetchSeatCushionUseCase,
    saveSeatCushionUseCase: UseCaseResources.saveSeatCushionUseCase,
    seatCushionDeviceUseCase: UseCaseResources.seatCushionDeviceUseCase,
    fileHandler: fileHandler,
  );
  static FileHandler get fileHandler => ConcreteFileHandler(
    fetchSeatCushionUseCase: UseCaseResources.fetchSeatCushionUseCase,
  );
}
