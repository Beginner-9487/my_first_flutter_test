import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_persist_devices_util.dart';
import 'package:flutter_path_utils/path_provider_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utl_mobile/utl_bluetooth/utl_bluetooth_resources.dart';
import 'package:utl_seat_cushion/infrastructure/bluetooth/bluetooth_handler.dart';
import 'package:utl_seat_cushion/infrastructure/bluetooth/bluetooth_dto_handler.dart';
import 'package:utl_seat_cushion/infrastructure/bluetooth/concrete/concrete_bluetooth_dto_handler.dart';
import 'package:utl_seat_cushion/infrastructure/bluetooth/concrete/seat_cushion_bluetooth_devices_provider.dart';
import 'package:utl_seat_cushion/infrastructure/repository/seat_cushion_repository.dart';
import 'package:utl_seat_cushion/infrastructure/source/in_memoty/in_memory.dart';
import 'package:utl_seat_cushion/init/application_persist.dart';
import 'package:utl_seat_cushion/init/resources/bluetooth_resources.dart';
import 'package:utl_seat_cushion/init/resources/data_resources.dart';
import 'package:utl_seat_cushion/init/resources/path_resources.dart';
import 'package:utl_seat_cushion/init/resources/seat_cushion_resources.dart';
import 'package:utl_seat_cushion/init/resources/service_resources.dart';
import 'package:utl_seat_cushion/init/usecase_registry.dart';
import 'package:utl_seat_cushion/service/user_file_handler.dart';

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
    BluetoothResources.bluetoothDevicesWidgetProvider = UtlBluetoothDevicesWidgetProvider(
      devices: bluetoothDevices.map((bluetoothDevice) => FlutterBluePlusPersistDeviceUtil(
        bluetoothDevice: bluetoothDevice,
      )).toList(),
      addNewDeviceHandler: FlutterBluePlusPersistDeviceUtil.resultToDevice,
    );
    BluetoothResources.readRssiTimer = BluetoothResources.bluetoothDevicesWidgetProvider.readRssi(
      duration: const Duration(milliseconds: 300),
    );
    BluetoothResources.bluetoothHandler = BluetoothHandler(
      devices: bluetoothDevices,
      bluetoothDtoHandler: createBluetoothDtoHandler(),
    );
    DataResources.seatCushionDevicesProvider = SeatCushionBluetoothDevicesProvider(
      bluetoothHandler: BluetoothResources.bluetoothHandler,
    );

    ServiceResources.fileService = ConcreteFileService(
      handleSeatCushionEntitiesUseCase: UseCaseRegistry.handleSeatCushionEntitiesUseCase,
      fetchSeatCushionEntitiesLengthUseCase: UseCaseRegistry.fetchEntitiesLengthUseCase,
    );

    ApplicationPersist.init();
  }
  @override
  BluetoothDtoHandler createBluetoothDtoHandler() {
    return ConcreteBluetoothDtoHandler(
      seatCushionRepository: DataResources.seatCushionRepository,
    );
  }
}
