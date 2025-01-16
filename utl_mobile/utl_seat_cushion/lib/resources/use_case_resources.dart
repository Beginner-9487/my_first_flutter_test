import 'package:utl_seat_cushion/domain/use_case/seat_cushion_use_case.dart';
import 'package:utl_seat_cushion/resources/data_resources.dart';

class UseCaseResources {
  UseCaseResources._();
  static FetchSeatCushionUseCase get fetchSeatCushionUseCase => FetchSeatCushionUseCase(
    bufferProvider: DataResources.seatCushionBufferProvider,
    repository: DataResources.seatCushionRepository,
  );
  static SaveSeatCushionUseCase get saveSeatCushionUseCase => SaveSeatCushionUseCase(
    bufferProvider: DataResources.seatCushionBufferProvider,
    repository: DataResources.seatCushionRepository,
    optionsProvider: DataResources.seatCushionSaveOptionsProvider,
  );
  static SeatCushionDeviceUseCase get seatCushionDeviceUseCase => SeatCushionDeviceUseCase(
    seatCushionDevicesProvider: DataResources.seatCushionDevicesProvider
  );
  static DeleteSeatCushionUseCase get deleteSeatCushionUseCase => DeleteSeatCushionUseCase(
    repository: DataResources.seatCushionRepository,
  );
}
