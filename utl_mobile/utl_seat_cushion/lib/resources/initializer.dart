import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_device_widget_util.dart';
import 'package:flutter_path_utils/path_provider_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utl_seat_cushion/infrastructure/bluetooth/bluetooth_data_module.dart';
import 'package:utl_seat_cushion/infrastructure/bluetooth/bluetooth_dto_handler.dart';
import 'package:utl_seat_cushion/infrastructure/bluetooth/concrete/concrete_bluetooth_dto_handler.dart';
import 'package:utl_seat_cushion/infrastructure/bluetooth/concrete/seat_cushion_bluetooth_devices_provider.dart';
import 'package:utl_seat_cushion/infrastructure/repository/seat_cushion_repository.dart';
import 'package:utl_seat_cushion/infrastructure/source/in_memoty/in_memory.dart';
import 'package:utl_seat_cushion/resources/bluetooth_resources.dart';
import 'package:utl_seat_cushion/resources/data_resources.dart';
import 'package:utl_seat_cushion/resources/path_resources.dart';
import 'package:utl_seat_cushion/resources/seat_cushion_resources.dart';

abstract class Initializer {
  createBluetoothDtoHandler();
  Future call();
}

class ConcreteInitializer extends Initializer {
  @override
  Future call() async {
    PathResources.downloadPath = ((await PathProviderUtil.getSystemDownloadDirectory()) ?? (await getApplicationDocumentsDirectory())).absolute.path;

    DataResources.sharedPreferences = await SharedPreferences.getInstance();
    DataResources.seatCushionRepository = ConcreteSeatCushionRepository(
      inMemoryBuffer: InMemoryBuffer(),
      inMemoryRepository: InMemoryRepository(),
      inMemorySeatCushionDataSaveOptionProvider: InMemorySeatCushionDataSaveOptionProvider(
        options: SeatCushionResources.defaultSaveOptions,
      ),
    );
    // await HiveDatabaseRepository.init();
    // databaseRepository = HiveDatabaseRepository();

    // inMemoryRepository = ConcreteInMemoryRepository(
    //   maxLength: 100,
    // );
    // electrochemicalDataService = ConcreteElectrochemicalDataService(
    //   databaseRepository: databaseRepository,
    //   inMemoryRepository: inMemoryRepository,
    // )..loadToMemory();

    FlutterBluePlus.setLogLevel(LogLevel.none);
    List<BluetoothDevice> bluetoothDevices = await FlutterBluePlus.systemDevices([]);
    BluetoothResources.bluetoothWidgetsProvider = FlutterBluePlusPersistDeviceWidgetUtilsProvider(
      devices: bluetoothDevices.map((e) => FlutterBluePlusDeviceWidgetUtil(bluetoothDevice: e)).toList(),
      resultToDevice: FlutterBluePlusDeviceWidgetUtil.resultToDevice,
    );
    BluetoothResources.readRssiTimer = BluetoothResources.bluetoothWidgetsProvider.readRssi(
      duration: const Duration(milliseconds: 300),
    );
    BluetoothResources.bluetoothDataModule = BluetoothDataModule(
      devices: bluetoothDevices,
      bluetoothDtoHandler: createBluetoothDtoHandler(),
    );
    DataResources.seatCushionDevicesProvider = SeatCushionBluetoothDevicesProvider(
      bluetoothDataModule: BluetoothResources.bluetoothDataModule,
    );
  }
  @override
  BluetoothDtoHandler createBluetoothDtoHandler() {
    return ConcreteBluetoothDtoHandler(
      seatCushionRepository: DataResources.seatCushionRepository,
    );
  }
}
