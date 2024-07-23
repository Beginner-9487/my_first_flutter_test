import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_processor/application/infrastructure/background_processor.dart';
import 'package:flutter_background_processor/application/infrastructure/background_processor_impl_fft.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/domain/ble_repository_impl_fbp.dart';
import 'package:flutter_ble/application/services/ble_auto_read_rssi_service.dart';
import 'package:flutter_ble/application/services/ble_selected_auto_read_rssi_service.dart';
import 'package:flutter_ble/application/services/ble_selected_auto_reconnect_service.dart';
import 'package:flutter_util/bloc/bloc_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_amulet/application/domain/amulet_repository.dart';
import 'package:utl_amulet/application/domain/amulet_repository_impl.dart';
import 'package:utl_amulet/application/services/auto_save_file_service_amulet.dart';
import 'package:utl_amulet/application/services/ble_amulet_service.dart';
import 'package:utl_amulet/presentation/amulet_home_screen.dart';
import 'package:utl_amulet/resources/app_theme.dart';
import 'package:utl_amulet/resources/global_constants.dart';
import 'package:utl_amulet/resources/global_variables.dart';

@pragma('vm:entry-point')
void startCallback() {
}

void main() async {
  await mainInit();
}

mainInit() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Bloc.observer = GlobalBlocObserver();
  await setGlobal();
  runApp(const AppRoot());
}

setGlobal() async {
  debugPrint("setGlobal");
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  BLERepository bleRepository = BLERepositoryImplFBP.getInstance();

  BackgroundProcessor backgroundProcessor = BackgroundProcessorImplFFT.init(
    startCallback: startCallback,
  );

  BLESelectedAutoReconnectService bleSelectedAutoReconnectService = BLESelectedAutoReconnectService.getInstance(
    bleRepository,
  );
  BLESelectedAutoReadRSSIService bleSelectedAutoReadRSSIService = BLESelectedAutoReadRSSIService.getInstance(
    bleRepository,
    GlobalConstants.READ_RSSI_RATE,
  );
  BLEAutoReadRSSIService bleAutoReadRSSIService = BLEAutoReadRSSIService.getInstance(
    bleRepository: bleRepository,
    bleSelectedAutoReadRSSIService: bleSelectedAutoReadRSSIService,
  );

  AmuletRepository amuletRepository = AmuletRepositoryImpl.getInstance();
  BLEAmuletService bleAmuletService = BLEAmuletService.getInstance(
      bleRepository: bleRepository,
      amuletRepository: amuletRepository,
  );

  AutoSaveFileServiceAmulet autoSaveFileServiceAmulet = AutoSaveFileServiceAmulet.getInstance(
      amuletRepository
  );

  DateTime initTimeStamp = DateTime.now();

  GlobalVariables.initAmulet(
    sharedPreferences: sharedPreferences,
    bleRepository: bleRepository,
    bleSelectedAutoReconnectService: bleSelectedAutoReconnectService,
    bleSelectedAutoReadRSSIService: bleSelectedAutoReadRSSIService,
    bleAutoReadRSSIService: bleAutoReadRSSIService,
    backgroundProcessor: backgroundProcessor,
    amuletRepository: amuletRepository,
    bleAmuletService: bleAmuletService,
    autoSaveFileServiceAmulet: autoSaveFileServiceAmulet,
    initTimeStamp: initTimeStamp,
  );
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: AppTheme.primaryColor,
      ),
      home: const AmuletHomeScreen(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}