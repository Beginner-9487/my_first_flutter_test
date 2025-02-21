import 'package:utl_amulet/controller/amulet_buttons_board_controller.dart';
import 'package:utl_amulet/controller/amulet_line_chart_controller.dart';
import 'package:utl_amulet/controller/concrete_amulet_bottons_board_controller.dart';
import 'package:utl_amulet/init/resources/interface/adapter_resource.dart';
import 'package:utl_amulet/init/resources/interface/repository_resource.dart';
import 'package:utl_amulet/init/resources/service/service_resource.dart';

class ControllerRegistry {
  ControllerRegistry._();
  static void init() {}
  static AmuletLineChartController get amuletLineChartController => ServiceResource.concreteAmuletLineChartSharedResource.amuletLineChartController;
  static AmuletLineChartInfoController get amuletLineChartInfoController => ServiceResource.concreteAmuletLineChartSharedResource.amuletLineChartInfoController;
  static AmuletButtonsBoardController get amuletButtonsBoardController => ConcreteAmuletButtonsBoardController(
    amuletDevicesManager: AdapterResource.amuletDevicesManager,
    concreteAmuletEntityCreator: ServiceResource.concreteAmuletEntityCreator,
    amuletRepository: RepositoryResource.amuletRepository,
    fileManager: AdapterResource.fileManager,
  );
}
