import 'package:flutter_system_path/system_path.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_data.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_header.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_parameters.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_type.dart';
import 'package:utl_electrochemical_tester/application/repository/database_repository.dart';

class HiveDatabaseRepository implements DatabaseRepository {
  static const String entityBoxName = "entityBox";

  // final Box<ElectrochemicalDataEntity> entityBox = Hive.box(HiveDatabaseRepository.entityBoxName);
  static late final Box<ElectrochemicalEntity> entityBox;

  static Future<void> init({
    required SystemPath systemPath,
  }) async {
    await Hive.initFlutter();
    Hive.init(systemPath.app_document_path_absolute);

    Hive.registerAdapter(ElectrochemicalEntityAdapter());
    Hive.registerAdapter(ElectrochemicalDataAdapter());
    Hive.registerAdapter(ElectrochemicalHeaderAdapter());
    Hive.registerAdapter(ElectrochemicalTypeAdapter());
    Hive.registerAdapter(CaElectrochemicalParametersAdapter());
    Hive.registerAdapter(CvElectrochemicalParametersAdapter());
    Hive.registerAdapter(DpvElectrochemicalParametersAdapter());
    Hive.registerAdapter(InversionOptionAdapter());

    return Hive.openBox<ElectrochemicalEntity>(HiveDatabaseRepository.entityBoxName).then((value) {
      entityBox = value;
      return;
    });
  }

  @override
  Future<Iterable<ElectrochemicalEntity>> getEntities(Iterable<int> ids) async {
    return ids.map((id) => entityBox.get(id)).whereType<ElectrochemicalEntity>();
  }

  @override
  Future<int> getEntitiesLength() async {
    return entityBox.length;
  }

  @override
  Future<ElectrochemicalEntity> create(ElectrochemicalHeader header) async {
    final id = entityBox.length;
    final newEntity = ElectrochemicalEntity(
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
  Future<ElectrochemicalEntity> update(ElectrochemicalEntity entity, Iterable<ElectrochemicalData> data) async {

    final updatedEntity = ElectrochemicalEntity(
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
