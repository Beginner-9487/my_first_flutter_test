import 'package:utl_electrochemical_tester/domain/entity/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_data.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_header.dart';

abstract class ElectrochemicalEntityRepository {
  Iterable<Future<ElectrochemicalEntity?>> fetchEntitiesByIds({
    required Iterable<int> entityIds,
  });

  Iterable<Future<ElectrochemicalEntity?>> fetchEntities();

  Iterable<Future<ElectrochemicalEntity?>> fetchHeadersByIds({
    required Iterable<int> headerIds,
  });

  Iterable<Future<ElectrochemicalEntity?>> fetchHeaders();

  Future<int> countEntities();

  Iterable<Future<int?>> fetchIds();

  Stream<ElectrochemicalEntity> get entitySyncStream;

  Future<ElectrochemicalEntity> createEntityFromHeader({
    required ElectrochemicalHeader header,
  });

  Future<ElectrochemicalEntity> appendDataToEntity({
    required int entityId,
    required Iterable<ElectrochemicalData> data,
  });

  Future<bool> upsertEntity({
    required ElectrochemicalEntity entity,
  });

  Future<bool> clearRepository();
}
