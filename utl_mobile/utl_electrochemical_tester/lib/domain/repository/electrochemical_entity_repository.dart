import 'package:utl_electrochemical_tester/domain/entity/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_data.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_header.dart';

abstract class ElectrochemicalEntityRepository {
  Stream<ElectrochemicalEntity?> fetchEntitiesByIds({
    required Iterable<int> entityIds,
  });

  Stream<ElectrochemicalEntity> fetchEntities();

  Stream<ElectrochemicalHeader?> fetchHeadersByIds({
    required Iterable<int> entityIds,
  });

  Stream<ElectrochemicalHeader> fetchHeaders();

  Future<int> countEntities();

  Stream<int> fetchIds();

  Stream<ElectrochemicalEntity> get entitySyncStream;

  Stream<int> get entityRemovedStream;

  Future<ElectrochemicalEntity> createEntityFromHeader({
    required ElectrochemicalHeader header,
  });

  Future<ElectrochemicalEntity?> appendDataToEntity({
    required int entityId,
    required Iterable<ElectrochemicalData> data,
  });

  Future<bool> upsertEntity({
    required ElectrochemicalEntity entity,
  });

  Future<bool> clearRepository();
}
