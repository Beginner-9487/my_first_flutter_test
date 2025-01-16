import 'package:utl_seat_cushion/domain/entities/seat_cushion_entity.dart';
import 'package:utl_seat_cushion/domain/use_case/seat_cushion_use_case.dart';

/// Repository interface for managing seat cushion data
abstract class SeatCushionRepository {
  Future<bool> add({
    required SeatCushionEntity entity,
  });
  Stream<SeatCushionEntity> get lastEntityStream;
  Future<List<SeatCushionEntity>> fetchEntities({
    required int start,
    required int end,
  });
  Future<bool> handleEntities({
    required int start,
    required int end,
    required void Function(SeatCushionEntity entity) handler,
  });
  Future<int> fetchEntitiesLength();
  Future<int> generateEntityId();
  Future<bool> clearAllEntities();
}

/// Interface for buffering and streaming seat cushion data
abstract class SeatCushionBufferProvider {
  void update({
    required SeatCushionEntity entity,
  });
  SeatCushionEntity? get buffer;
  Stream<SeatCushionEntity> get bufferStream;
}

abstract class SeatCushionSaveOptionsProvider {
  Stream<SeatCushionSaveOptions> get optionsStream;
  SeatCushionSaveOptions get options;
  set options(SeatCushionSaveOptions options);
}

abstract class SeatCushionDevicesProvider {
  Future<bool> sendCommand({
    required String command,
  });
}
