import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utl_mobile/theme/theme.dart';
import 'package:utl_seat_cushion/application/seat_cushion_devices_data_handler.dart';
import 'package:utl_seat_cushion/resources/application_resources.dart';
import 'package:utl_seat_cushion/resources/initializer.dart';
import 'package:utl_seat_cushion/presentation/screen/home_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Initializer initializer = ConcreteInitializer();
  await initializer();
  SeatCushionDevicesDataHandler seatCushionDevicesDataHandler = ApplicationResources.seatCushionDevicesDataHandler;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // var appLocalizations = AppLocalizations.of(context)!;
    var themeData = Theme.of(context);
    return MaterialApp(
      // title: appLocalizations.appName,
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      color: themeData.screenBackgroundColor,
      home: const HomeScreen(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
