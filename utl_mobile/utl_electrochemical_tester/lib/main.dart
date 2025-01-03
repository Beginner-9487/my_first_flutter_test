import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:flutter_file_handler/row_csv_file.dart';
import 'package:flutter_file_handler/row_csv_file_impl.dart';
import 'package:flutter_system_path/system_path.dart';
import 'package:flutter_system_path/system_path_impl.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/controller/bluetooth_scanner_controller.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/controller/bluetooth_scanner_device_controller.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/controller/fbp_bluetooth_scanner_device_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_electrochemical_tester/application/controller/electrochemical_command_controller.dart';
import 'package:utl_electrochemical_tester/application/repository/database_repository.dart';
import 'package:utl_electrochemical_tester/application/repository/hive_database_repository.dart';
import 'package:utl_electrochemical_tester/application/repository/in_memory_repository.dart';
import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_device.dart';
import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_service.dart';
import 'package:utl_electrochemical_tester/application/service/electrochemical_data_service.dart';
import 'package:utl_electrochemical_tester/presentation/screen/home_screen.dart';
import 'package:utl_electrochemical_tester/resources/app_theme.dart';
import 'package:utl_electrochemical_tester/resources/bt_uuid.dart';
import 'package:utl_mobile/utl_bluetooth/utl_bluetooth_handler.dart';
import 'package:utl_mobile/utl_bluetooth/fbp_utl_bluetooth_handler.dart';

late final SharedPreferences sharedPreferences;
late final List<fbp.BluetoothDevice> bluetoothDevices;
late final UtlBluetoothHandler<ConcreteElectrochemicalSensor> utlBluetoothHandler;
late final ElectrochemicalSensorService electrochemicalSensorService;
late final ElectrochemicalCommandController electrochemicalCommandController;

late final BluetoothScannerController<BluetoothScannerDeviceTileController> bluetoothScannerController;

late final RowCSVFileHandler rowCSVFileHandler;
late final SystemPath systemPath;
late final DatabaseRepository databaseRepository;
late final InMemoryRepository inMemoryRepository;
late final ElectrochemicalDataService electrochemicalDataService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();

  systemPath = await SystemPathImpl.getInstance();

  await HiveDatabaseRepository.init(
    systemPath: systemPath,
  );
  databaseRepository = HiveDatabaseRepository();

  fbp.FlutterBluePlus.setLogLevel(fbp.LogLevel.none);
  bluetoothDevices = await fbp.FlutterBluePlus.systemDevices;
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  bluetoothScannerController = FbpBluetoothScannerTilesController(
    devices: bluetoothDevices,
    scanDuration: const Duration(seconds: 15),
    readRssiDelay: const Duration(milliseconds: 300),
  );
  utlBluetoothHandler = FbpUtlBluetoothHandler(
    bluetoothDeviceToDevice: (bluetoothDevice, handler) => ConcreteElectrochemicalSensor(
        bluetoothDevice: bluetoothDevice,
        handler: handler,
        dataName: ""
    ),
    scanResultToDevice: (scanResult, handler) => ConcreteElectrochemicalSensor(
        bluetoothDevice: scanResult.device,
        handler: handler,
        dataName: ""
    ),
    devices: bluetoothDevices,
    sentUuid: [bluetoothSentUuids],
    receivedUuid: [bluetoothReceivedUuids],
  );

  rowCSVFileHandler = RowCSVFileHandlerImpl.getInstance();

  inMemoryRepository = ConcreteInMemoryRepository(
    maxLength: 100,
  );
  electrochemicalDataService = ConcreteElectrochemicalDataService(
    databaseRepository: databaseRepository,
    inMemoryRepository: inMemoryRepository,
  )..loadToMemory();

  electrochemicalSensorService = ConcreteElectrochemicalSensorService(
    handler: utlBluetoothHandler,
    electrochemicalDataService: electrochemicalDataService,
  );
  electrochemicalCommandController = ConcreteElectrochemicalCommandController(service: electrochemicalSensorService);

  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: AppTheme.primaryColor,
      ),
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<BluetoothScannerController<BluetoothScannerDeviceTileController>>(create: (_) => bluetoothScannerController),
          RepositoryProvider<SharedPreferences>(create: (_) => sharedPreferences),
          RepositoryProvider<List<fbp.BluetoothDevice>>(create: (_) => bluetoothDevices),
          RepositoryProvider<UtlBluetoothHandler<ConcreteElectrochemicalSensor>>(create: (_) => utlBluetoothHandler),
          RepositoryProvider<ElectrochemicalSensorService>(create: (_) => electrochemicalSensorService),
          RepositoryProvider<ElectrochemicalCommandController>(create: (_) => electrochemicalCommandController),
          RepositoryProvider<RowCSVFileHandler>(create: (_) => rowCSVFileHandler),
          RepositoryProvider<SystemPath>(create: (_) => systemPath),
          RepositoryProvider<DatabaseRepository>(create: (_) => databaseRepository),
          RepositoryProvider<InMemoryRepository>(create: (_) => inMemoryRepository),
          RepositoryProvider<ElectrochemicalDataService>(create: (_) => electrochemicalDataService),
        ],
        child: const HomeScreen(),
        // child: const A(),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
