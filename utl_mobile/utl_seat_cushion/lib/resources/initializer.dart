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
import 'package:utl_seat_cushion/infrastructure/in_memory.dart';
import 'package:utl_seat_cushion/domain/use_case/seat_cushion_use_case.dart';
import 'package:utl_seat_cushion/resources/bluetooth_resources.dart';
import 'package:utl_seat_cushion/resources/data_resources.dart';
import 'package:utl_seat_cushion/resources/path_resources.dart';
import 'package:utl_seat_cushion/resources/seat_cushion_resources.dart';
import 'package:utl_seat_cushion/resources/use_case_resources.dart';

abstract class Initializer {
  createBluetoothDtoHandler();
  Future init();
}

class ConcreteInitializer extends Initializer {
  @override
  Future init() async {
    PathResources.downloadPath = ((await PathProviderUtil.getSystemDownloadDirectory()) ?? (await getApplicationDocumentsDirectory())).absolute.path;

    DataResources.sharedPreferences = await SharedPreferences.getInstance();
    DataResources.seatCushionBufferProvider = InMemoryBuffer();
    DataResources.seatCushionRepository = InMemoryRepository();
    DataResources.seatCushionSaveOptionsProvider = InMemorySeatCushionDataSaveOptionProvider(
      options: SeatCushionResources.defaultSaveOptions,
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
    BluetoothResources.bluetoothWidgetProvider = FlutterBluePlusPersistDeviceWidgetsUtil(
      devices: bluetoothDevices.map((e) => FlutterBluePlusDeviceWidgetUtil(bluetoothDevice: e)).toList(),
      resultToDevice: FlutterBluePlusDeviceWidgetUtil.resultToDevice,
    );
    BluetoothResources.readRssiTimer = BluetoothResources.bluetoothWidgetProvider.readRssi(
      duration: const Duration(milliseconds: 300),
    );
    BluetoothResources.bluetoothDataModule = BluetoothDataModule(
      devices: bluetoothDevices,
      bluetoothDtoHandler: createBluetoothDtoHandler(),
      saveSeatCushionUseCase: UseCaseResources.saveSeatCushionUseCase,
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
