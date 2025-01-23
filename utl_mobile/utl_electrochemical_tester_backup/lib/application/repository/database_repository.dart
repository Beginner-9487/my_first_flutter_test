import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_data.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_header.dart';

abstract class DatabaseRepository {
  Future<Iterable<ElectrochemicalEntity>> getEntities(Iterable<int> ids);
  Future<int> getEntitiesLength();
  Future<ElectrochemicalEntity> create(ElectrochemicalHeader header);
  Future<ElectrochemicalEntity> update(ElectrochemicalEntity entity, Iterable<ElectrochemicalData> data);
  Future<bool> clear();
}
