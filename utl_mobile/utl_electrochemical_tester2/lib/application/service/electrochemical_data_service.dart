import 'package:utl_electrochemical_tester/application/data/electrochemical_data.dart';
import 'package:utl_electrochemical_tester/application/data/electrochemical_header.dart';
import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/application/repository/csv_file_repository.dart';
import 'package:utl_electrochemical_tester/application/repository/database_repository.dart';
import 'package:utl_electrochemical_tester/application/repository/in_memory_repository.dart';

abstract class ElectrochemicalDataService {
  Iterable<ElectrochemicalDataEntity> get latestEntities;
  Stream<ElectrochemicalDataEntity> get onUpdate;
  Future<void> create(ElectrochemicalHeader header);
  Future<void> update(ElectrochemicalDataEntity entity, ElectrochemicalData data);
  Future<bool> saveFile();
}

class ConcreteElectrochemicalDataService extends ElectrochemicalDataService {
  final CsvFileRepository csvFileRepository;
  final DatabaseRepository databaseRepository;
  final InMemoryRepository inMemoryRepository;
  ConcreteElectrochemicalDataService({
    required this.csvFileRepository,
    required this.databaseRepository,
    required this.inMemoryRepository,
  });
  @override
  Iterable<ElectrochemicalDataEntity> get latestEntities => inMemoryRepository.entities;
  @override
  Stream<ElectrochemicalDataEntity> get onUpdate => inMemoryRepository.onUpdate;
  @override
  Future<void> create(ElectrochemicalHeader header) async {
    return databaseRepository.create(header).then((entity) => inMemoryRepository.add(entity));
  }
  @override
  Future<void> update(ElectrochemicalDataEntity entity, ElectrochemicalData data) async {
    ElectrochemicalDataEntity e = await databaseRepository.update(entity, [data]);
    inMemoryRepository.add(e);
    inMemoryRepository.update(e, data);
  }
  @override
  Future<bool> saveFile() async {
    await csvFileRepository.createFile();
    int length = await databaseRepository.getEntitiesLength();
    for(int i=0; i<length; i++) {
      await csvFileRepository.writeFile(await databaseRepository.getEntities([i]));
    }
    return true;
  }
}