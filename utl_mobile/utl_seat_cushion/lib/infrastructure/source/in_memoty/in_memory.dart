import 'dart:async';

import 'package:synchronized/synchronized.dart';
import 'package:utl_seat_cushion/domain/repository/seat_cushion_repository.dart';
import 'package:utl_seat_cushion/domain/model/entity/seat_cushion_entity.dart';

class InMemoryBuffer {
  final StreamController<SeatCushionEntity> _seatCushionEntityController = StreamController.broadcast();
  void update({
    required SeatCushionEntity entity,
  }) {
    buffer = entity;
    _seatCushionEntityController.add(entity);
  }
  SeatCushionEntity? buffer;
  Stream<SeatCushionEntity> get bufferStream => _seatCushionEntityController.stream;
  void dispose() {
    _seatCushionEntityController.close();
  }
}

class InMemoryRepository {
  final StreamController<SeatCushionEntity> lastEntityController = StreamController.broadcast();
  final List<SeatCushionEntity> entities = [];
  final Lock _entityLock = Lock();
  Future<bool> add({
    required SeatCushionEntity entity,
  }) {
    return _entityLock.synchronized(() {
      entities.add(entity);
      lastEntityController.add(entity);
      return true;
    });
  }
  Stream<SeatCushionEntity> get lastEntityStream => lastEntityController.stream;
  Stream<SeatCushionEntity> fetchEntities() async* {
    for(var entity in entities.toList()) {
      yield entity;
    }
  }
  Future<bool> handleEntities({
    required int start,
    required int end,
    required void Function(SeatCushionEntity entity) handler,
  }) async {
    return _entityLock.synchronized(() {
      for(var entity in entities.skip(start).take(end)) {
        handler(entity);
      }
      return true;
    });
  }
  Future<int> fetchEntitiesLength() {
    return _entityLock.synchronized(() {
      return entities.length;
    });
  }
  Future<int> generateEntityId() {
    return fetchEntitiesLength();
  }
  Future<bool> clearAllEntities() {
    return _entityLock.synchronized(() {
      entities.clear();
      return true;
    });
  }
  void dispose() {
    lastEntityController.close();
  }
}

class InMemorySeatCushionDataSaveOptionProvider {
  final StreamController<SeatCushionSaveOptions> _optionsStreamController = StreamController.broadcast();
  Stream<SeatCushionSaveOptions> get optionsStream => _optionsStreamController.stream;
  SeatCushionSaveOptions _options;
  SeatCushionSaveOptions get options => _options;
  set options(SeatCushionSaveOptions options) {
    _options = options;
    _optionsStreamController.add(options);
  }
  InMemorySeatCushionDataSaveOptionProvider({
    required SeatCushionSaveOptions options,
  }) : _options = options {
    _optionsStreamController.add(options);
  }
  void dispose() {
    _optionsStreamController.close();
  }
}
