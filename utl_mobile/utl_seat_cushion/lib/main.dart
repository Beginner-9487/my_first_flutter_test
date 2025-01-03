import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/controller/bluetooth_scanner_controller.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/controller/fbp_bluetooth_scanner_device_controller.dart';
import 'package:utl_seat_cushion/presentation/screen/home_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late final List<BluetoothDevice> bluetoothDevices;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  bluetoothDevices = await FlutterBluePlus.systemDevices;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    BluetoothScannerController bluetoothScannerController = FbpBluetoothScannerTilesController(
        devices: bluetoothDevices,
        scanDuration: const Duration(seconds: 15),
        readRssiDelay: const Duration(milliseconds: 100),
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const HomeScreen(),
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<BluetoothScannerController>(create: (_) => bluetoothScannerController),
        ],
        child: const HomeScreen(),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
