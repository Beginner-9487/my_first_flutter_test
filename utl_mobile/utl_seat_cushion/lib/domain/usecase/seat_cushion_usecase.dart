import 'package:utl_seat_cushion/domain/repository/seat_cushion_device.dart';
import 'package:utl_seat_cushion/domain/repository/seat_cushion_repository.dart';
import 'package:utl_seat_cushion/domain/model/entity/seat_cushion_entity.dart';

/// Fetch buffer use case
class FetchLastSeatCushionEntityUseCase {
  final SeatCushionRepository seatCushionRepository;

  FetchLastSeatCushionEntityUseCase({
    required this.seatCushionRepository,
  });

  SeatCushionEntity? call() => seatCushionRepository.lastEntity;
}

/// Fetch entities use case
class FetchSeatCushionEntitiesUseCase {
  final SeatCushionRepository repository;

  FetchSeatCushionEntitiesUseCase({
    required this.repository,
  });

  Stream<SeatCushionEntity> call() => repository.fetchEntities();
}

/// Handle entities use case
class HandleSeatCushionEntitiesUseCase {
  final SeatCushionRepository repository;

  HandleSeatCushionEntitiesUseCase({
    required this.repository,
  });

  Future<bool> call({
    required int start,
    required int end,
    required void Function(SeatCushionEntity entity) handler,
  }) async {
    await for (var entity in repository.fetchEntities().skip(start).take(end - start)) {
      handler(entity);
    }
    return true;
  }
}

/// Fetch entities length use case
class FetchSeatCushionEntitiesLengthUseCase {
  final SeatCushionRepository repository;

  FetchSeatCushionEntitiesLengthUseCase({
    required this.repository,
  });

  Future<int> call() => repository.fetchEntitiesLength();
}

/// Buffer stream use case
class FetchLastSeatCushionEntityStreamUseCase {
  final SeatCushionRepository seatCushionRepository;

  FetchLastSeatCushionEntityStreamUseCase({
    required this.seatCushionRepository,
  });

  Stream<SeatCushionEntity> call() => seatCushionRepository.lastEntityStream;
}

/// Clear all entities use case
class ClearAllSeatCushionEntitiesUseCase {
  final SeatCushionRepository repository;

  ClearAllSeatCushionEntitiesUseCase({
    required this.repository,
  });

  Future<bool> call() => repository.clearAllEntities();
}

/// Save seat cushion use case
class SaveSeatCushionEntityUseCase {
  final SeatCushionRepository seatCushionRepository;

  SaveSeatCushionEntityUseCase({
    required this.seatCushionRepository,
  });

  void call({
    required SeatCushionEntity entity,
  }) {
    seatCushionRepository.add(entity: entity);
  }
}

/// Options stream use case
class GetSeatCushionOptionsStreamUseCase {
  final SeatCushionRepository seatCushionRepository;

  GetSeatCushionOptionsStreamUseCase({
    required this.seatCushionRepository,
  });

  Stream<SeatCushionSaveOptions> call() => seatCushionRepository.optionsStream;
}

/// Get options use case
class GetSeatCushionOptionsUseCase {
  final SeatCushionRepository seatCushionRepository;

  GetSeatCushionOptionsUseCase({
    required this.seatCushionRepository,
  });

  SeatCushionSaveOptions call() => seatCushionRepository.options;
}

/// Set options use case
class SetSeatCushionOptionsUseCase {
  final SeatCushionRepository seatCushionRepository;

  SetSeatCushionOptionsUseCase({
    required this.seatCushionRepository,
  });

  void call({
    required SeatCushionSaveOptions options,
  }) {
    seatCushionRepository.options = options;
  }
}

/// Send command use case
class SendCommandToAllSeatCushionDeviceUseCase {
  final SeatCushionDevicesProvider seatCushionDevicesProvider;

  SendCommandToAllSeatCushionDeviceUseCase({
    required this.seatCushionDevicesProvider,
  });

  Future<bool> call({
    required String command,
  }) => seatCushionDevicesProvider.sendCommand(command: command);
}

class FetchReceiveSeatCushionEntityStreamUseCase {
  final SeatCushionDevicesProvider seatCushionDevicesProvider;

  FetchReceiveSeatCushionEntityStreamUseCase({
    required this.seatCushionDevicesProvider,
  });

  Stream<SeatCushionEntity> call() => seatCushionDevicesProvider.receiveSeatCushionEntityStream;
}
