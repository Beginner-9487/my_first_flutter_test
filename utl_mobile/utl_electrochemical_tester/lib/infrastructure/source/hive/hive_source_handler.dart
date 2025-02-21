import 'package:hive_flutter/adapters.dart';
import 'package:utl_electrochemical_tester/domain/entity/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_header.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/hive/hive_electrochemical.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/hive/hive_mapper.dart';
import 'package:synchronized/synchronized.dart';

class HiveSourceHandler {
  static const String _entityBoxName = "entityBox";
  static Future<HiveSourceHandler> init({
    required String hivePath,
  }) async {
    await Hive.initFlutter();

    Hive.init(hivePath);

    Hive.registerAdapter(HiveCaElectrochemicalParametersAdapter());
    Hive.registerAdapter(HiveCvElectrochemicalParametersAdapter());
    Hive.registerAdapter(HiveDpvElectrochemicalParametersAdapter());
    Hive.registerAdapter(HiveDpvElectrochemicalParametersInversionOptionAdapter());
    Hive.registerAdapter(HiveElectrochemicalDataAdapter());
    Hive.registerAdapter(HiveElectrochemicalEntityAdapter());
    Hive.registerAdapter(HiveElectrochemicalHeaderAdapter());
    Hive.registerAdapter(HiveElectrochemicalTypeAdapter());

    var entityBox = await Hive.openLazyBox<HiveElectrochemicalEntity>(_entityBoxName);

    return HiveSourceHandler._(entityBox);
  }

  final LazyBox<HiveElectrochemicalEntity> _entityBox;

  final Lock _lock = Lock();
  HiveSourceHandler._(this._entityBox);

  Future<ElectrochemicalEntity?> fetchEntityById(int entityId) async {
    return _lock.synchronized(() async {
      var entity = await _entityBox.get(entityId);
      if (entity == null) return null;
      return HiveElectrochemicalMapper.toEntity(entityId, entity);
    });
  }

  Future<ElectrochemicalHeader?> fetchHeadersByIds(int entityId) {
    return _lock.synchronized(() async {
      var entity = await _entityBox.get(entityId);
      if (entity == null) return null;
      return HiveElectrochemicalMapper.toHeader(entity.electrochemicalHeader);
    });
  }

  int countEntities() {
    return _entityBox.length;
  }

  Iterable<int> fetchEntityIds() {
    return _entityBox.keys.cast<int>();
  }

  Stream<ElectrochemicalEntity> get entitySyncStream {
    return _entityBox.watch()
      .where((event) => event.value is HiveElectrochemicalEntity)
      .asyncMap((event) async {
        return _lock.synchronized(() async {
          return HiveElectrochemicalMapper.toEntity(event.key, event.value);
        });
      });
  }

  Stream<int> get entityRemovedStream {
    return _entityBox.watch()
      .where((event) => event.value == null)
      .asyncMap((event) async {
        return _lock.synchronized(() async {
          return event.key;
        });
      });
  }

  Future<ElectrochemicalEntity> createEntityFromHeader({
    required ElectrochemicalHeader header,
  }) async {
    return _lock.synchronized(() async {
      final newEntity = ElectrochemicalEntity(
        id: _entityBox.length + 1,
        electrochemicalHeader: header,
        data: [],
      );
      await _entityBox.put(newEntity.id, HiveElectrochemicalMapper.fromEntity(newEntity));
      return newEntity;
    });
  }

  Future<void> upsertEntity({
    required ElectrochemicalEntity entity,
  }) async {
    return _lock.synchronized(() {
      return _entityBox.put(entity.id, HiveElectrochemicalMapper.fromEntity(entity));
    });
  }

  Future<int> clearRepository() async {
    return _lock.synchronized(() {
      return _entityBox.clear();
    });
  }

  void dispose() {
    _entityBox.close();
  }
}
