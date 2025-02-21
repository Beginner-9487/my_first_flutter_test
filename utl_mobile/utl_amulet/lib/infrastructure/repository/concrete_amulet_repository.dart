import 'package:synchronized/synchronized.dart';
import 'package:utl_amulet/domain/entity/amulet_entity.dart';
import 'package:utl_amulet/domain/repository/amulet_repository.dart';
import 'package:utl_amulet/infrastructure/source/hive/hive_source_handler.dart';

class ConcreteAmuletRepository implements AmuletRepository {
  
  final Lock _lock = Lock();
  
  final HiveSourceHandler hiveSourceHandler;
  
  ConcreteAmuletRepository({
    required this.hiveSourceHandler,
  });

  @override
  Future<bool> delete({required int entityId}) {
    return _lock.synchronized(() async {
      await hiveSourceHandler.deleteEntity(entityId: entityId);
      return true;
    });
  }

  @override
  Stream<int> get entityIdRemovedStream => hiveSourceHandler.entityIdRemovedStream;

  @override
  Stream<AmuletEntity> get entitySyncStream => hiveSourceHandler.entitySyncStream;

  @override
  Stream<AmuletEntity> fetchEntities() async* {
    for(var entityId in hiveSourceHandler.fetchEntityIds().toList()) {
      final entity = await _lock.synchronized(() async {
        return await hiveSourceHandler.fetchEntityById(entityId);
      });
      if(entity != null) yield entity;
    }
  }

  @override
  Future<bool> insert({required AmuletRepositoryInsertDto dto}) {
    return _lock.synchronized(() async {
      await hiveSourceHandler.insertDto(dto: dto);
      return true;
    });
  }

  @override
  Future<bool> upsert({required AmuletEntity entity}) {
    return _lock.synchronized(() async {
      await hiveSourceHandler.upsertEntity(entity: entity);
      return true;
    });
  }

  @override
  Future<bool> clear() {
    return _lock.synchronized(() async {
      await hiveSourceHandler.clear();
      return true;
    });
  }
  
}