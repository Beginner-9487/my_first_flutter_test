import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_device_widget_util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_electrochemical_tester/application/controller/electrochemical_command_controller.dart';
import 'package:utl_electrochemical_tester/application/repository/database_repository.dart';
import 'package:utl_electrochemical_tester/application/repository/hive_database_repository.dart';
import 'package:utl_electrochemical_tester/application/repository/in_memory_repository.dart';
import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_device.dart';
import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_received_packet.dart';
import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_service.dart';
import 'package:utl_electrochemical_tester/application/service/electrochemical_data_service.dart';
import 'package:utl_electrochemical_tester/presentation/screen/home_screen.dart';
import 'package:utl_electrochemical_tester/resources/app_theme.dart';
import 'package:utl_electrochemical_tester/resources/bt_uuid.dart';
import 'package:utl_mobile/utl_bluetooth/utl_bluetooth_handler.dart';
import 'package:utl_mobile/utl_bluetooth/fbp_utl_bluetooth_handler.dart';

late final SharedPreferences sharedPreferences;
late final UtlBluetoothHandler<ConcreteElectrochemicalSensor, ElectrochemicalSensorReceivedPacket> utlBluetoothHandler;
late final ElectrochemicalSensorService electrochemicalSensorService;
late final ElectrochemicalCommandController electrochemicalCommandController;

late final FlutterBluePlusPersistDeviceWidgetsUtil<FlutterBluePlusDeviceWidgetUtil> bluetoothScannerController;

late final DatabaseRepository databaseRepository;
late final InMemoryRepository inMemoryRepository;
late final ElectrochemicalDataService electrochemicalDataService;

late Timer readRssiTimer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();

  await HiveDatabaseRepository.init();
  databaseRepository = HiveDatabaseRepository();

  fbp.FlutterBluePlus.setLogLevel(fbp.LogLevel.none);
  List<fbp.BluetoothDevice> bluetoothDevices = await fbp.FlutterBluePlus.systemDevices([]);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  bluetoothScannerController = FlutterBluePlusPersistDeviceWidgetsUtil(
    devices: bluetoothDevices.map((e) => FlutterBluePlusDeviceWidgetUtil(bluetoothDevice: e)).toList(),
    resultToDevice: FlutterBluePlusDeviceWidgetUtil.resultToDevice,
  );
  readRssiTimer = bluetoothScannerController.readRssi(
      duration: const Duration(milliseconds: 300),
  );
  utlBluetoothHandler = FbpUtlBluetoothHandler<ConcreteElectrochemicalSensor, ElectrochemicalSensorReceivedPacket, FbpUtlBluetoothSharedResources<ConcreteElectrochemicalSensor, ElectrochemicalSensorReceivedPacket>>(
    devices: bluetoothDevices,
    resources: FbpUtlBluetoothSharedResources(
        toPacket: (device, data) => ElectrochemicalSensorReceivedPacket(
          data: data,
          deviceId: device.bluetoothDevice.remoteId.str,
          deviceName: device.bluetoothDevice.platformName,
        ),
        sentUuid: [bluetoothSentUuids],
        receivedUuid: [bluetoothReceivedUuids],
    ),
    bluetoothDeviceToDevice: (resource, bluetoothDevice) => ConcreteElectrochemicalSensor(
        bluetoothDevice: bluetoothDevice,
        resource: resource,
        dataName: ""
    ),
    resultToDevice: (resource, result) => ConcreteElectrochemicalSensor(
        bluetoothDevice: result.device,
        resource: resource,
        dataName: ""
    ),
  );

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
      home: MultiProvider(
        providers: [
          Provider<FlutterBluePlusPersistDeviceWidgetsUtil<FlutterBluePlusDeviceWidgetUtil>>(create: (_) => bluetoothScannerController),
          Provider<SharedPreferences>(create: (_) => sharedPreferences),
          Provider<UtlBluetoothHandler<ConcreteElectrochemicalSensor, ElectrochemicalSensorReceivedPacket>>(create: (_) => utlBluetoothHandler),
          Provider<ElectrochemicalSensorService>(create: (_) => electrochemicalSensorService),
          Provider<ElectrochemicalCommandController>(create: (_) => electrochemicalCommandController),
          Provider<DatabaseRepository>(create: (_) => databaseRepository),
          Provider<InMemoryRepository>(create: (_) => inMemoryRepository),
          Provider<ElectrochemicalDataService>(create: (_) => electrochemicalDataService),
        ],
        child: const HomeScreen(),
        // child: const A(),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
