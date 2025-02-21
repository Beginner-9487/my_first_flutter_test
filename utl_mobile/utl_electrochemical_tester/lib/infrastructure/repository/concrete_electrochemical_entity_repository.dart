import 'package:synchronized/synchronized.dart';
import 'package:utl_electrochemical_tester/domain/entity/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/domain/repository/electrochemical_entity_repository.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_data.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_header.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/hive/hive_source_handler.dart';

class ConcreteElectrochemicalEntityRepository implements ElectrochemicalEntityRepository {
  final Lock _lock = Lock();
  final HiveSourceHandler hiveSourceHandler;
  ConcreteElectrochemicalEntityRepository({
    required this.hiveSourceHandler,
  });

  @override
  Future<ElectrochemicalEntity?> appendDataToEntity({required int entityId, required Iterable<ElectrochemicalData> data}) {
    return _lock.synchronized(() async {
      var entity = await hiveSourceHandler.fetchEntityById(entityId);
      if(entity == null) return null;
      entity.data.addAll(data);
      hiveSourceHandler.upsertEntity(entity: entity);
      return entity;
    });
  }

  @override
  Future<bool> clearRepository() {
    return _lock.synchronized(() async {
      await hiveSourceHandler.clearRepository();
      return true;
    });
  }

  @override
  Future<int> countEntities() async {
    return _lock.synchronized(() async {
      return hiveSourceHandler.countEntities();
    });
  }

  @override
  Future<ElectrochemicalEntity> createEntityFromHeader({required ElectrochemicalHeader header}) {
    return _lock.synchronized(() async {
      return await hiveSourceHandler.createEntityFromHeader(header: header);
    });
  }

  @override
  Stream<ElectrochemicalEntity> get entitySyncStream => hiveSourceHandler.entitySyncStream;

  @override
  Stream<int> get entityRemovedStream => hiveSourceHandler.entityRemovedStream;

  @override
  Stream<ElectrochemicalEntity> fetchEntities() async* {
    for(var id in hiveSourceHandler.fetchEntityIds().toList()) {
      var entity = await _lock.synchronized(() async {
        return await hiveSourceHandler.fetchEntityById(id);
      });
      if(entity != null) yield entity;
    }
  }

  @override
  Stream<ElectrochemicalEntity?> fetchEntitiesByIds({required Iterable<int> entityIds}) async* {
    for(var id in entityIds.toList()) {
      yield await _lock.synchronized(() async {
        return await hiveSourceHandler.fetchEntityById(id);
      });
    }
  }

  @override
  Stream<ElectrochemicalHeader> fetchHeaders() async* {
    for(var id in hiveSourceHandler.fetchEntityIds().toList()) {
      var header = await _lock.synchronized(() async {
        return await hiveSourceHandler.fetchHeadersByIds(id);
      });
      if(header != null) yield header;
    }
  }

  @override
  Stream<ElectrochemicalHeader?> fetchHeadersByIds({required Iterable<int> entityIds}) async* {
    for(var id in entityIds.toList()) {
      yield await _lock.synchronized(() async {
        return await hiveSourceHandler.fetchHeadersByIds(id);
      });
    }
  }

  @override
  Stream<int> fetchIds() async* {
    for(var id in hiveSourceHandler.fetchEntityIds().toList()) {
      yield id;
    }
  }

  @override
  Future<bool> upsertEntity({required ElectrochemicalEntity entity}) {
    return _lock.synchronized(() async {
      await hiveSourceHandler.upsertEntity(entity: entity);
      return true;
    });
  }
  
}