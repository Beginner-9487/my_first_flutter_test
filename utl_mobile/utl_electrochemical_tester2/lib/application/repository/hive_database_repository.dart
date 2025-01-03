import 'package:hive/hive.dart';
import 'package:utl_electrochemical_tester/application/data/electrochemical_data.dart';
import 'package:utl_electrochemical_tester/application/data/electrochemical_header.dart';
import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/application/repository/database_repository.dart';

class HiveDatabaseRepository implements DatabaseRepository {
  static const String entityBoxName = "entityBox";

  final Box<ElectrochemicalDataEntity> entityBox = Hive.box(HiveDatabaseRepository.entityBoxName);

  @override
  Future<Iterable<ElectrochemicalDataEntity>> getEntities(Iterable<int> ids) async {
    return ids.map((id) => entityBox.get(id)).whereType<ElectrochemicalDataEntity>();
  }

  @override
  Future<int> getEntitiesLength() async {
    return entityBox.length;
  }

  @override
  Future<ElectrochemicalDataEntity> create(ElectrochemicalHeader header) async {
    final id = entityBox.length + 1;
    final newEntity = ElectrochemicalDataEntity(
      id: id,
      dataName: header.dataName,
      deviceId: header.deviceId,
      createdTime: header.createdTime,
      temperature: header.temperature,
      parameters: header.parameters,
      data: [],
    );
    await entityBox.put(id, newEntity);
    return newEntity;
  }

  @override
  Future<ElectrochemicalDataEntity> update(ElectrochemicalDataEntity entity, Iterable<ElectrochemicalData> data) async {

    final updatedEntity = ElectrochemicalDataEntity(
      id: entity.id,
      dataName: entity.dataName,
      deviceId: entity.deviceId,
      createdTime: entity.createdTime,
      temperature: entity.temperature,
      parameters: entity.parameters,
      data: data.toList(),
    );
    await entityBox.put(entity.id, updatedEntity);
    return updatedEntity;
  }

  @override
  Future<bool> clear() async {
    await entityBox.clear();
    return true;
  }
}
