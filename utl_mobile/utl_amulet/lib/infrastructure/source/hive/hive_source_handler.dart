import 'package:hive_flutter/adapters.dart';
import 'package:utl_amulet/domain/entity/amulet_entity.dart';
import 'package:utl_amulet/domain/repository/amulet_repository.dart';
import 'package:utl_amulet/infrastructure/source/hive/hive_amulet.dart';
import 'package:utl_amulet/infrastructure/source/hive/hive_mapper.dart';
import 'package:synchronized/synchronized.dart';

class HiveSourceHandler {
  static const String _entityBoxName = "entityBox";

  static Future<HiveSourceHandler> init({
    required String hivePath,
  }) async {
    await Hive.initFlutter();
    Hive.init(hivePath);

    Hive.registerAdapter(HiveAmuletEntityAdapter());
    Hive.registerAdapter(HiveAmuletPostureTypeAdapter());

    var entityBox = await Hive.openLazyBox<HiveAmuletEntity>(_entityBoxName);
    return HiveSourceHandler._(entityBox);
  }

  final LazyBox<HiveAmuletEntity> _entityBox;

  final Lock _lock = Lock();
  HiveSourceHandler._(this._entityBox);

  Future<AmuletEntity?> fetchEntityById(int entityId) async {
    return _lock.synchronized(() async {
      var entity = await _entityBox.get(entityId);
      if (entity == null) return null;
      return HiveAmuletMapper.toAmuletEntity(id: entityId, entity: entity);
    });
  }

  int countEntities() {
    return _entityBox.length;
  }

  Iterable<int> fetchEntityIds() {
    return _entityBox.keys.cast<int>();
  }

  Stream<AmuletEntity> get entitySyncStream {
    return _entityBox.watch()
      .where((event) => event.value is HiveAmuletEntity)
      .asyncMap((event) async {
        return _lock.synchronized(() async {
          return HiveAmuletMapper.toAmuletEntity(id: event.key, entity: event.value);
        });
      });
  }

  Stream<int> get entityIdRemovedStream {
    return _entityBox.watch()
      .where((event) => event.value == null)
      .asyncMap((event) async {
        return _lock.synchronized(() async {
          return event.key;
        });
      });
  }

  Future<void> insertDto({
    required AmuletRepositoryInsertDto dto,
  }) {
    return _lock.synchronized(() async {
      final key = (_entityBox.keys.lastOrNull ?? 0) + 1;
      return _entityBox.put(key, HiveAmuletMapper.fromAmuletRepositoryInsertDto(dto: dto));
    });
  }

  Future<void> upsertEntity({
    required AmuletEntity entity,
  }) async {
    return _lock.synchronized(() {
      return _entityBox.put(entity.id, HiveAmuletMapper.fromAmuletEntity(entity: entity));
    });
  }

  Future<void> deleteEntity({
    required int entityId,
  }) async {
    return _lock.synchronized(() {
      return _entityBox.delete(entityId);
    });
  }

  Future<int> clear() async {
    return _lock.synchronized(() {
      return _entityBox.clear();
    });
  }

  void dispose() {
    _entityBox.close();
  }
}
