import 'package:utl_electrochemical_tester/application/electrochemical_entity_creator.dart';
import 'package:utl_electrochemical_tester/init/resources/interface/adapter_resource.dart';
import 'package:utl_electrochemical_tester/init/resources/interface/repository_resource.dart';

class ApplicationPersist {
  ApplicationPersist._();
  static void init() {
    electrochemicalEntityCreator = ElectrochemicalEntityCreator(
      electrochemicalEntityRepository: RepositoryResource.electrochemicalEntityRepository,
      electrochemicalDevicesManager: AdapterResource.electrochemicalDevicesManager,
    );
  }
  static late final ElectrochemicalEntityCreator electrochemicalEntityCreator;
}
