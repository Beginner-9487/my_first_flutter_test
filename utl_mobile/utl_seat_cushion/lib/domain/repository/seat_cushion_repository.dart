import 'package:equatable/equatable.dart';
import 'package:utl_seat_cushion/domain/model/entity/seat_cushion_entity.dart';

/// Repository interface for managing seat cushion data
abstract class SeatCushionRepository {
  Future<bool> add({
    required SeatCushionEntity entity,
  });
  SeatCushionEntity? get lastEntity;
  Stream<SeatCushionEntity> get lastEntityStream;
  Stream<SeatCushionEntity> fetchEntities();
  Future<int> fetchEntitiesLength();
  Future<int> generateEntityId();
  Future<bool> clearAllEntities();
  Stream<SeatCushionSaveOptions> get optionsStream;
  SeatCushionSaveOptions get options;
  set options(SeatCushionSaveOptions options);
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
