import 'package:utl_seat_cushion/controller/seat_cushion_data_view_controller.dart';
import 'package:utl_seat_cushion/init/resources/service_resources.dart';
import 'package:utl_seat_cushion/init/usecase_registry.dart';

class ControllerRegistry {
  ControllerRegistry._();
  static SeatCushionDataViewController get seatCushionDataViewController => ConcreteSeatCushionDataViewController(
    fetchLastSeatCushionEntityUseCase: UseCaseRegistry.fetchLastSeatCushionUseCase,
    fetchLastSeatCushionEntityStreamUseCase: UseCaseRegistry.fetchLastSeatCushionEntityStreamUseCase,
    clearAllSeatCushionEntitiesUseCase: UseCaseRegistry.clearAllEntitiesUseCase,
    getSeatCushionOptionsStreamUseCase: UseCaseRegistry.getOptionsStreamUseCase,
    getSeatCushionOptionsUseCase: UseCaseRegistry.getOptionsUseCase,
    setSeatCushionOptionsUseCase: UseCaseRegistry.setOptionsUseCase,
    sendCommandToAllSeatCushionDeviceUseCase: UseCaseRegistry.sendCommandUseCase,
    fileService: ServiceResources.fileService,
  );
}