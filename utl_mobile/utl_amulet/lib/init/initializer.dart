import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_persist_devices_util.dart';
import 'package:flutter_path_utils/path_provider_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:utl_amulet/controller/concrete_amulet_line_chart_controller.dart';
import 'package:utl_amulet/infrastructure/adapter/amulet_device/concrete_amulet_devices_manager.dart';
import 'package:utl_amulet/infrastructure/adapter/file/concrete_file_manager.dart';
import 'package:utl_amulet/infrastructure/repository/concrete_amulet_repository.dart';
import 'package:utl_amulet/infrastructure/source/bluetooth/bluetooth_devices_handler.dart';
import 'package:utl_amulet/infrastructure/source/hive/hive_source_handler.dart';
import 'package:utl_amulet/init/application_persist.dart';
import 'package:utl_amulet/init/controller_registry.dart';
import 'package:utl_amulet/init/resources/interface/adapter_resource.dart';
import 'package:utl_amulet/init/resources/infrastructure/bluetooth_resource.dart';
import 'package:utl_amulet/init/resources/infrastructure/hive_source.dart';
import 'package:utl_amulet/init/resources/infrastructure/path_resource.dart';
import 'package:utl_amulet/init/resources/interface/repository_resource.dart';
import 'package:utl_amulet/init/resources/service/service_resource.dart';
import 'package:utl_amulet/init/usecase_registry.dart';
import 'package:utl_amulet/service/amulet_entity_creator.dart';
import 'package:utl_mobile/utl_bluetooth/utl_bluetooth_resources.dart';

abstract class Initializer {
  Future call();
}

class ConcreteInitializer extends Initializer {
  @override
  Future call() async {
    FlutterBluePlus.setLogLevel(LogLevel.none);
    final bluetoothDevices = await FlutterBluePlus.systemDevices([]);
    BluetoothResource.bluetoothDevicesWidgetProvider = UtlBluetoothDevicesWidgetProvider(
      devices: bluetoothDevices.map((bluetoothDevice) => FlutterBluePlusPersistDeviceUtil(
        bluetoothDevice: bluetoothDevice,
      )).toList(),
      addNewDeviceHandler: FlutterBluePlusPersistDeviceUtil.resultToDevice,
    );
    BluetoothResource.bluetoothDevicesHandler = BluetoothDevicesHandler(
      devices: bluetoothDevices,
    );
    BluetoothResource.readRssiTimer = BluetoothResource.bluetoothDevicesWidgetProvider.readRssi(
      duration: const Duration(milliseconds: 300),
    );

    PathResource.downloadPath = ((await PathProviderUtil.getSystemDownloadDirectory()) ?? (await getApplicationDocumentsDirectory())).absolute.path;
    PathResource.hivePath = (await getApplicationDocumentsDirectory()).absolute.path;

    HiveSource.hiveSourceHandler = await HiveSourceHandler.init(
      hivePath: PathResource.hivePath,
    );

    AdapterResource.amuletDevicesManager = ConcreteAmuletDevicesManager(
      bluetoothDevicesHandler: BluetoothResource.bluetoothDevicesHandler,
    );
    AdapterResource.fileManager = ConcreteFileManager(
      amuletFileDownloadFolder: PathResource.downloadPath,
    );

    RepositoryResource.amuletRepository = ConcreteAmuletRepository(
        hiveSourceHandler: HiveSource.hiveSourceHandler
    );

    ServiceResource.concreteAmuletEntityCreator = ConcreteAmuletEntityCreator(
      amuletRepository: RepositoryResource.amuletRepository,
      amuletDevicesManager: AdapterResource.amuletDevicesManager,
    );
    ServiceResource.amuletEntityCreator = ServiceResource.concreteAmuletEntityCreator;
    ServiceResource.concreteAmuletLineChartSharedResource = ConcreteAmuletLineChartSharedResource(
      amuletDevicesManager: AdapterResource.amuletDevicesManager,
      amuletEntityCreator: ServiceResource.amuletEntityCreator,
      amuletFetchEntitiesProcessUsecase: UsecaseRegistry.amuletFetchEntitiesProcessUsecase,
    );

    ApplicationPersist.init();
    ControllerRegistry.init();
  }
}
