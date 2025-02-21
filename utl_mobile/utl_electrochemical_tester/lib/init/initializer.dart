import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_persist_devices_util.dart';
import 'package:flutter_path_utils/path_provider_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:utl_electrochemical_tester/controller/concrete_electrochemical_line_chart_controller.dart';
import 'package:utl_electrochemical_tester/infrastructure/adapter/electrochemical_devices/concrete_electrochemical_devices_manager.dart';
import 'package:utl_electrochemical_tester/infrastructure/adapter/local_storage/concrete_electrochemical_command_local_storage_handler.dart';
import 'package:utl_electrochemical_tester/infrastructure/repository/concrete_electrochemical_entity_repository.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/bluetooth/bluetooth_devices_handler.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/bluetooth/concrete_bluetooth_packet_handler.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/bluetooth/electrochemical_bluetooth_buffer.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/hive/hive_source_handler.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/shared_preferences/shared_preferences_handler.dart';
import 'package:utl_electrochemical_tester/init/application_persist.dart';
import 'package:utl_electrochemical_tester/init/resources/interface/adapter_resource.dart';
import 'package:utl_electrochemical_tester/init/resources/infrastructure/bluetooth_resource.dart';
import 'package:utl_electrochemical_tester/init/resources/infrastructure/hive_source.dart';
import 'package:utl_electrochemical_tester/init/resources/infrastructure/path_resource.dart';
import 'package:utl_electrochemical_tester/init/resources/infrastructure/shared_preferences_resource.dart';
import 'package:utl_electrochemical_tester/init/resources/interface/repository_resource.dart';
import 'package:utl_electrochemical_tester/init/resources/service/service_resource.dart';
import 'package:utl_electrochemical_tester/infrastructure/adapter/file/concrete_file_manager.dart';
import 'package:utl_mobile/utl_bluetooth/utl_bluetooth_resources.dart';

abstract class Initializer {
  ConcreteBluetoothPacketHandler createConcreteBluetoothPacketHandler();
  Future<void> call();
}

class ConcreteInitializer extends Initializer {
  @override
  Future<void> call() async {
    FlutterBluePlus.setLogLevel(LogLevel.none);
    final bluetoothDevices = await FlutterBluePlus.systemDevices([]);
    BluetoothResource.bluetoothDevicesWidgetProvider = UtlBluetoothDevicesWidgetProvider(
      devices: bluetoothDevices.map((bluetoothDevice) => FlutterBluePlusPersistDeviceUtil(
        bluetoothDevice: bluetoothDevice,
      )).toList(),
      addNewDeviceHandler: FlutterBluePlusPersistDeviceUtil.resultToDevice,
    );
    final bluetoothPacketHandler = createConcreteBluetoothPacketHandler();
    BluetoothResource.bluetoothDevicesHandler = BluetoothDevicesHandler(
      devices: bluetoothDevices,
      bluetoothPacketHandler: bluetoothPacketHandler,
    );
    BluetoothResource.readRssiTimer = BluetoothResource.bluetoothDevicesWidgetProvider.readRssi(
      duration: const Duration(milliseconds: 300),
    );

    PathResource.downloadPath = ((await PathProviderUtil.getSystemDownloadDirectory()) ?? (await getApplicationDocumentsDirectory())).absolute.path;
    PathResource.hivePath = (await getApplicationDocumentsDirectory()).absolute.path;

    HiveSource.hiveSourceHandler = await HiveSourceHandler.init(
      hivePath: PathResource.hivePath,
    );

    SharedPreferencesResource.sharedPreferencesHandler = await SharedPreferencesHandler.init();

    RepositoryResource.electrochemicalEntityRepository = ConcreteElectrochemicalEntityRepository(
      hiveSourceHandler: HiveSource.hiveSourceHandler,
    );

    AdapterResource.electrochemicalDevicesManager = ConcreteElectrochemicalDevicesManager(bluetoothHandler: BluetoothResource.bluetoothDevicesHandler);
    AdapterResource.fileManager = ConcreteFileManager(
      electrochemicalEntityRepository: RepositoryResource.electrochemicalEntityRepository,
    );
    AdapterResource.electrochemicalCommandLocalStorageHandler = ConcreteElectrochemicalCommandLocalStorageHandler(
      sharedPreferencesHandler: SharedPreferencesResource.sharedPreferencesHandler,
    );

    ServiceResource.electrochemicalLineChartSharedResource = ConcreteElectrochemicalLineChartSharedResource(
      electrochemicalEntityRepository: RepositoryResource.electrochemicalEntityRepository,
    );

    ElectrochemicalBluetoothBuffer.init(
      electrochemicalEntityRepository: RepositoryResource.electrochemicalEntityRepository,
    );
    ApplicationPersist.init();
    ApplicationPersist.electrochemicalEntityCreator.start();
  }
  @override
  ConcreteBluetoothPacketHandler createConcreteBluetoothPacketHandler() {
    return ConcreteBluetoothPacketHandler();
  }
}
