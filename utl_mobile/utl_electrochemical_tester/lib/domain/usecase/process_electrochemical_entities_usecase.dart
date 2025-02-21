import 'package:utl_electrochemical_tester/domain/entity/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/domain/repository/electrochemical_entity_repository.dart';

class ProcessElectrochemicalEntitiesWithIdsUsecase {
  ElectrochemicalEntityRepository electrochemicalEntityRepository;
  ProcessElectrochemicalEntitiesWithIdsUsecase({
    required this.electrochemicalEntityRepository,
  });
  Future<void> call({
    required Iterable<int> entityIds,
    required bool Function(ElectrochemicalEntity entity) processor,
  }) async {
    await for (var entity in electrochemicalEntityRepository.fetchEntitiesByIds(entityIds: entityIds)) {
      if(entity == null) continue;
      if(!processor(entity)) return;
    }
  }
}

class ProcessElectrochemicalEntitiesUsecase {
  ElectrochemicalEntityRepository electrochemicalEntityRepository;
  ProcessElectrochemicalEntitiesUsecase({
    required this.electrochemicalEntityRepository,
  });
  Future<void> call({
    required bool Function(ElectrochemicalEntity? entity) processor,
  }) async {
    await for (var entity in electrochemicalEntityRepository.fetchEntities()) {
      if(!processor(entity)) return;
    }
  }
}
