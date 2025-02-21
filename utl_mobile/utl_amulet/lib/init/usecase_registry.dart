import 'package:utl_amulet/domain/usecase/amulet_fetch_entities_process.dart';
import 'package:utl_amulet/init/resources/interface/repository_resource.dart';

class UsecaseRegistry {
  UsecaseRegistry._();
  static void init() {}
  static AmuletFetchEntitiesProcessUsecase get amuletFetchEntitiesProcessUsecase => AmuletFetchEntitiesProcessUsecase(
    amuletRepository: RepositoryResource.amuletRepository,
  );
}
