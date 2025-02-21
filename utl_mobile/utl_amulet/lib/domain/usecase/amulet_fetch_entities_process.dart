import 'package:utl_amulet/domain/entity/amulet_entity.dart';
import 'package:utl_amulet/domain/repository/amulet_repository.dart';

class AmuletFetchEntitiesProcessUsecase {
  final AmuletRepository amuletRepository;
  AmuletFetchEntitiesProcessUsecase({
    required this.amuletRepository,
  });
  Future<void> call({
    required bool Function(AmuletEntity? entity) processor,
  }) async {
    await for (var entity in amuletRepository.fetchEntities()) {
      if(!processor(entity)) return;
    }
  }
}
