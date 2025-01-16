import 'package:equatable/equatable.dart';
import 'package:utl_seat_cushion/domain/data/seat_cushion_data.dart';
import 'package:utl_seat_cushion/domain/entities/seat_cushion_entity.dart';

/// Use case for retrieving seat cushion data
class FetchSeatCushionUseCase {
  final SeatCushionBufferProvider bufferProvider;
  final SeatCushionRepository repository;

  FetchSeatCushionUseCase({
    required this.bufferProvider,
    required this.repository,
  });

  SeatCushionEntity? get buffer => bufferProvider.buffer;
  Future<List<SeatCushionEntity>> fetchEntities({
    required int start,
    required int end,
  }) => repository.fetchEntities(
    start: start,
    end: end,
  );
  Future<bool> handleEntities({
    required int start,
    required int end,
    required void Function(SeatCushionEntity entity) handler,
  }) => repository.handleEntities(
    start: start,
    end: end,
    handler: handler,
  );
  Future<int> fetchEntitiesLength() => repository.fetchEntitiesLength();
  Stream<SeatCushionEntity> get bufferStream => bufferProvider.bufferStream;
}

class DeleteSeatCushionUseCase {
  final SeatCushionRepository repository;

  DeleteSeatCushionUseCase({
    required this.repository,
  });

  Future<bool> clearAllEntities() {
    return repository.clearAllEntities();
  }
}

class SeatCushionSaveOptions extends Equatable {
  final bool saveToBufferOption;
  final bool saveToDatabaseOption;
  const SeatCushionSaveOptions({
    required this.saveToBufferOption,
    required this.saveToDatabaseOption,
  });
  @override
  List<Object?> get props => [
    saveToBufferOption,
    saveToDatabaseOption,
  ];
}

/// Use case for creating and saving seat cushion data
class SaveSeatCushionUseCase {
  final SeatCushionBufferProvider bufferProvider;
  final SeatCushionRepository repository;
  final SeatCushionSaveOptionsProvider optionsProvider;
  Stream<SeatCushionSaveOptions> get optionsStream => optionsProvider.optionsStream;
  SeatCushionSaveOptions get options => optionsProvider.options;
  set options(SeatCushionSaveOptions options) => optionsProvider.options = options;
  SaveSeatCushionUseCase({
    required this.bufferProvider,
    required this.repository,
    required this.optionsProvider,
  });
  void save(SeatCushionEntity entity) {
    if(options.saveToBufferOption) bufferProvider.update(entity: entity);
    if(options.saveToDatabaseOption) repository.add(entity: entity);
  }
}

class SeatCushionDeviceUseCase {
  final SeatCushionDevicesProvider seatCushionDevicesProvider;
  SeatCushionDeviceUseCase({
    required this.seatCushionDevicesProvider,
  });
  Future<bool> sendCommand({
    required String command,
  }) => seatCushionDevicesProvider.sendCommand(command: command);
}