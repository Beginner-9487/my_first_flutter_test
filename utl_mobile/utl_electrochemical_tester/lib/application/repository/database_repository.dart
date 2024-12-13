import 'package:utl_electrochemical_tester/application/data/electrochemical_data.dart';
import 'package:utl_electrochemical_tester/application/data/electrochemical_header.dart';
import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity.dart';

abstract class DatabaseRepository {
  Future<Iterable<ElectrochemicalDataEntity>> getEntities(Iterable<int> ids);
  Future<int> getEntitiesLength();
  Future<ElectrochemicalDataEntity> create(ElectrochemicalHeader header);
  Future<ElectrochemicalDataEntity> update(ElectrochemicalDataEntity entity, Iterable<ElectrochemicalData> data);
  Future<bool> clear();
}
