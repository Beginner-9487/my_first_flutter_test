import 'package:flutter/cupertino.dart';
import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_data.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_header.dart';
import 'package:utl_electrochemical_tester/application/repository/database_repository.dart';
import 'package:utl_electrochemical_tester/application/repository/file_repository.dart';
import 'package:utl_electrochemical_tester/application/repository/in_memory_repository.dart';

abstract class ElectrochemicalDataService {
  Iterable<ElectrochemicalEntity> get latestEntities;
  Stream<ElectrochemicalEntity> get onUpdate;
  Stream<void> get onClear;
  Future<void> loadToMemory();
  Future<void> create(ElectrochemicalHeader header);
  Future<void> update(ElectrochemicalEntity entity, ElectrochemicalData data);
  Future<bool> saveFile(FileRepository fileRepository);
  Future<bool> clear();
}

class ConcreteElectrochemicalDataService extends ElectrochemicalDataService {
  final DatabaseRepository databaseRepository;
  final InMemoryRepository inMemoryRepository;
  ConcreteElectrochemicalDataService({
    required this.databaseRepository,
    required this.inMemoryRepository,
  });
  @override
  Iterable<ElectrochemicalEntity> get latestEntities => inMemoryRepository.entities;
  @override
  Stream<ElectrochemicalEntity> get onUpdate => inMemoryRepository.onUpdate;
  @override
  Stream<void> get onClear => inMemoryRepository.onClear;
  @override
  Future<void> create(ElectrochemicalHeader header) async {
    return databaseRepository
        .create(header)
        .then((entity) => inMemoryRepository.add(entity));
  }
  @override
  Future<void> update(ElectrochemicalEntity entity, ElectrochemicalData data) async {
    List<ElectrochemicalData> list = [
      ...entity.data,
      data,
    ];
    ElectrochemicalEntity e = await databaseRepository.update(entity, list);
    inMemoryRepository.add(e);
    inMemoryRepository.update(e, data);
  }
  @override
  Future<void> loadToMemory() async {
    int length = await databaseRepository.getEntitiesLength();
    debugPrint("loadToMemory: $length");
    for(int i=0; i<length; i++) {
      inMemoryRepository.add((await databaseRepository.getEntities([i])).first);
    }
    return;
  }
  @override
  Future<bool> saveFile(FileRepository fileRepository) async {
    await fileRepository.createFile();
    int length = await databaseRepository.getEntitiesLength();
    for(int i=0; i<length; i++) {
      await fileRepository.writeFile((await databaseRepository.getEntities([i])).map((entity) => entity.fileDto));
    }
    return true;
  }
  @override
  Future<bool> clear() async {
    await databaseRepository.clear();
    inMemoryRepository.clear();
    return true;
  }
}