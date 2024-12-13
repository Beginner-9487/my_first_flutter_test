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
  static late final CsvFileRepository _csvFileRepository;
  static late final DatabaseRepository _databaseRepository;
  static late final InMemoryRepository _inMemoryRepository;
  static void init({
    required CsvFileRepository csvFileRepository,
    required DatabaseRepository databaseRepository,
    required InMemoryRepository inMemoryRepository,
  }) {
    _csvFileRepository = csvFileRepository;
    _databaseRepository = databaseRepository;
    _inMemoryRepository = inMemoryRepository;
  }
  @override
  Iterable<ElectrochemicalDataEntity> get latestEntities => _inMemoryRepository.entities;
  @override
  Stream<ElectrochemicalDataEntity> get onUpdate => _inMemoryRepository.onUpdate;
  @override
  Future<void> create(ElectrochemicalHeader header) async {
    return _databaseRepository.create(header).then((entity) => _inMemoryRepository.add(entity));
  }
  @override
  Future<void> update(ElectrochemicalDataEntity entity, ElectrochemicalData data) async {
    ElectrochemicalDataEntity e = await _databaseRepository.update(entity, [data]);
    _inMemoryRepository.add(e);
    _inMemoryRepository.update(e, data);
  }
  @override
  Future<bool> saveFile() async {
    await _csvFileRepository.createFile();
    int length = await _databaseRepository.getEntitiesLength();
    for(int i=0; i<length; i++) {
      await _csvFileRepository.writeFile(await _databaseRepository.getEntities([i]));
    }
    return true;
  }
}