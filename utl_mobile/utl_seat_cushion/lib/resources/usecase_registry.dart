import 'package:utl_seat_cushion/domain/usecase/seat_cushion_usecase.dart';
import 'package:utl_seat_cushion/resources/data_resources.dart';

class UseCaseRegistry {
  static FetchLastSeatCushionEntityUseCase get fetchLastSeatCushionUseCase =>
      FetchLastSeatCushionEntityUseCase(
        seatCushionRepository: DataResources.seatCushionRepository,
      );

  static FetchSeatCushionEntitiesUseCase get fetchSeatCushionEntitiesUseCase =>
      FetchSeatCushionEntitiesUseCase(
        repository: DataResources.seatCushionRepository,
      );

  static HandleSeatCushionEntitiesUseCase get handleSeatCushionEntitiesUseCase =>
      HandleSeatCushionEntitiesUseCase(
        repository: DataResources.seatCushionRepository,
      );

  static FetchSeatCushionEntitiesLengthUseCase get fetchEntitiesLengthUseCase =>
      FetchSeatCushionEntitiesLengthUseCase(
        repository: DataResources.seatCushionRepository,
      );

  static FetchLastSeatCushionEntityStreamUseCase
  get fetchLastSeatCushionEntityStreamUseCase =>
      FetchLastSeatCushionEntityStreamUseCase(
        seatCushionRepository: DataResources.seatCushionRepository,
      );

  static ClearAllSeatCushionEntitiesUseCase get clearAllEntitiesUseCase =>
      ClearAllSeatCushionEntitiesUseCase(
        repository: DataResources.seatCushionRepository,
      );

  static SaveSeatCushionEntityUseCase get saveSeatCushionEntityUseCase =>
      SaveSeatCushionEntityUseCase(
        seatCushionRepository: DataResources.seatCushionRepository,
      );

  static GetSeatCushionOptionsStreamUseCase get getOptionsStreamUseCase =>
      GetSeatCushionOptionsStreamUseCase(
        seatCushionRepository:
        DataResources.seatCushionRepository,
      );

  static GetSeatCushionOptionsUseCase get getOptionsUseCase =>
      GetSeatCushionOptionsUseCase(
        seatCushionRepository:
        DataResources.seatCushionRepository,
      );

  static SetSeatCushionOptionsUseCase get setOptionsUseCase =>
      SetSeatCushionOptionsUseCase(
        seatCushionRepository:
        DataResources.seatCushionRepository,
      );

  static SendCommandToAllSeatCushionDeviceUseCase get sendCommandUseCase =>
      SendCommandToAllSeatCushionDeviceUseCase(
        seatCushionDevicesProvider: DataResources.seatCushionDevicesProvider,
      );

  static FetchReceiveSeatCushionEntityStreamUseCase
  get fetchReceiveSeatCushionEntityStreamUseCase =>
      FetchReceiveSeatCushionEntityStreamUseCase(
        seatCushionDevicesProvider:
        DataResources.seatCushionDevicesProvider,
      );
}
