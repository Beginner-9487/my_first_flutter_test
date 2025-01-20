import 'dart:async';

import 'package:async_locks/async_locks.dart';
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
  Lock entityLock = Lock();
  @override
  Future<bool> add({
    required SeatCushionEntity entity,
  }) async {
    try {
      await entityLock.acquire();
      entities.add(entity);
      lastEntityController.add(entity);
      return true;
    } catch(e) {
      return false;
    } finally {
      entityLock.release();
    }
  }
  @override
  Stream<SeatCushionEntity> get lastEntityStream => lastEntityController.stream;
  @override
  Future<List<SeatCushionEntity>> fetchEntities({
    required int start,
    required int end,
  }) async {
    try {
      await entityLock.acquire();
      return entities.skip(start).take(end).toList();
    } catch(e) {
      return List.empty();
    } finally {
      entityLock.release();
    }
  }
  @override
  Future<bool> handleEntities({
    required int start,
    required int end,
    required void Function(SeatCushionEntity entity) handler,
  }) async {
    try {
      await entityLock.acquire();
      for(var entity in entities.skip(start).take(end)) {
        handler(entity) as Future;
      }
      return true;
    } catch(e) {
      return false;
    } finally {
      entityLock.release();
    }
  }
  @override
  Future<int> fetchEntitiesLength() async {
    try {
      await entityLock.acquire();
      return entities.length;
    } catch(e) {
      return 0;
    } finally {
      entityLock.release();
    }
  }
  @override
  Future<int> generateEntityId() async {
    return fetchEntitiesLength();
  }
  @override
  Future<bool> clearAllEntities() async {
    try {
      await entityLock.acquire();
      entities.clear();
      return true;
    } catch(e) {
      return false;
    } finally {
      entityLock.release();
    }
  }
  void dispose() {
    lastEntityController.close();
    entityLock.cancelAll();
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
