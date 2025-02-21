import 'package:utl_electrochemical_tester/controller/concrete_electrochemical_command_controller.dart';
import 'package:utl_electrochemical_tester/controller/concrete_electrochemical_feature_controller.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_command_controller.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_line_chart_controller.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_feature_controller.dart';
import 'package:utl_electrochemical_tester/init/resources/interface/adapter_resource.dart';
import 'package:utl_electrochemical_tester/init/resources/infrastructure/path_resource.dart';
import 'package:utl_electrochemical_tester/init/resources/interface/repository_resource.dart';
import 'package:utl_electrochemical_tester/init/resources/service/service_resource.dart';

class ControllerRegistry {
  ControllerRegistry._();
  static ElectrochemicalCommandController get electrochemicalCommandController => ConcreteElectrochemicalCommandController(
    electrochemicalDevicesManager: AdapterResource.electrochemicalDevicesManager,
    electrochemicalCommandLocalStorageHandler: AdapterResource.electrochemicalCommandLocalStorageHandler,
  );
  static ElectrochemicalLineChartController get electrochemicalLineChartController => ServiceResource.electrochemicalLineChartSharedResource.electrochemicalLineChartController;
  static ElectrochemicalLineChartInfoController get electrochemicalLineChartInfoController => ServiceResource.electrochemicalLineChartSharedResource.electrochemicalLineChartInfoController;
  static ElectrochemicalLineChartSetterController get electrochemicalLineChartSetterController => ServiceResource.electrochemicalLineChartSharedResource.electrochemicalLineChartSetterController;
  static ElectrochemicalFeatureController get electrochemicalFeatureController => ConcreteElectrochemicalFeatureController(
    electrochemicalEntityRepository: RepositoryResource.electrochemicalEntityRepository,
    fileManager: AdapterResource.fileManager,
    folderPath: PathResource.downloadPath,
  );
}
