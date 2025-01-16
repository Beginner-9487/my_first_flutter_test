import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_device_widget_util.dart';
import 'package:provider/provider.dart';
import 'package:utl_seat_cushion/resources/bluetooth_resources.dart';
import 'package:utl_seat_cushion/resources/initializer.dart';
import 'package:utl_seat_cushion/presentation/screen/home_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await ConcreteInitializer().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const HomeScreen(),
      home: MultiProvider(
        providers: [
          Provider<FlutterBluePlusPersistDeviceWidgetsUtil<FlutterBluePlusDeviceWidgetUtil>>(
            create: (context) => BluetoothResources.bluetoothWidgetProvider,
          ),
        ],
        child: const HomeScreen(),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
