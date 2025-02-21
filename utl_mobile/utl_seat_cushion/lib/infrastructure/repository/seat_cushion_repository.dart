import 'package:utl_seat_cushion/domain/model/entity/seat_cushion_entity.dart';
import 'package:utl_seat_cushion/domain/repository/seat_cushion_repository.dart';
import 'package:utl_seat_cushion/infrastructure/source/in_memoty/in_memory.dart';

class ConcreteSeatCushionRepository implements SeatCushionRepository {
  final InMemoryBuffer inMemoryBuffer;
  final InMemoryRepository inMemoryRepository;
  final InMemorySeatCushionDataSaveOptionProvider inMemorySeatCushionDataSaveOptionProvider;

  ConcreteSeatCushionRepository({
    required this.inMemoryBuffer,
    required this.inMemoryRepository,
    required this.inMemorySeatCushionDataSaveOptionProvider,
  });

  @override
  SeatCushionSaveOptions get options => inMemorySeatCushionDataSaveOptionProvider.options;

  @override
  Future<bool> add({required SeatCushionEntity entity}) async {
    if(options.saveToBufferOption) inMemoryBuffer.update(entity: entity);
    if(options.saveToDatabaseOption) inMemoryRepository.add(entity: entity);
    return true;
  }

  @override
  Future<bool> clearAllEntities() {
    return inMemoryRepository.clearAllEntities();
  }

  @override
  Stream<SeatCushionEntity> fetchEntities() {
    return inMemoryRepository.fetchEntities();
  }

  @override
  Future<int> fetchEntitiesLength() {
    return inMemoryRepository.fetchEntitiesLength();
  }

  @override
  Future<int> generateEntityId() {
    return inMemoryRepository.generateEntityId();
  }

  @override
  Future<bool> handleEntities({required int start, required int end, required void Function(SeatCushionEntity entity) handler}) {
    return inMemoryRepository.handleEntities(start: start, end: end, handler: handler);
  }

  @override
  SeatCushionEntity? get lastEntity => inMemoryBuffer.buffer;

  @override
  Stream<SeatCushionEntity> get lastEntityStream => inMemoryBuffer.bufferStream;

  @override
  Stream<SeatCushionSaveOptions> get optionsStream => inMemorySeatCushionDataSaveOptionProvider.optionsStream;

  @override
  set options(SeatCushionSaveOptions options) {
    inMemorySeatCushionDataSaveOptionProvider.options = options;
  }
  
}