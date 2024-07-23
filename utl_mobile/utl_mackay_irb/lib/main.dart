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
import 'package:utl_mackay_irb/application/domain/mackay_irb_repository.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_repository_impl.dart';
import 'package:utl_mackay_irb/application/services/auto_save_file_service_mackay_irb.dart';
import 'package:utl_mackay_irb/application/services/ble_mackay_irb_service.dart';
import 'package:utl_mackay_irb/presentation/mackay_irb_home_screen.dart';
import 'package:utl_mackay_irb/resources/app_theme.dart';
import 'package:utl_mackay_irb/resources/global_variables.dart';

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
  DateTime initTimeStamp = DateTime.now();

  debugPrint("setGlobal");
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  debugPrint("setGlobal.SharedPreferences.getInstance()");

  BLERepository bleRepository = BLERepositoryImplFBP.getInstance();
  debugPrint("setGlobal.BLERepositoryImplFBP.getInstance()");

  MackayIRBRepository mackayIRBRepository = MackayIRBRepositoryImpl.getInstance();

  BackgroundProcessor backgroundProcessor = BackgroundProcessorImplFFT.init(
    startCallback: startCallback,
  );

  BLESelectedAutoReconnectService bleSelectedAutoReconnectService = BLESelectedAutoReconnectService.getInstance(
    bleRepository,
  );
  BLESelectedAutoReadRSSIService bleSelectedAutoReadRSSIService = BLESelectedAutoReadRSSIService.getInstance(
    bleRepository,
    15,
  );
  // BLEAutoReadRSSIService bleAutoReadRSSIService = BLEAutoReadRSSIService.getInstance(
  //     bleRepository: bleRepository,
  //     bleSelectedAutoReadRSSIService: bleSelectedAutoReadRSSIService,
  // );

  BLEMackayIRBService bleMackayIRBService = BLEMackayIRBService.getInstance(
    bleRepository: bleRepository,
    mackayIRBRepository: mackayIRBRepository,
  );

  AutoSaveFileServiceMackayIRB autoSaveFileServiceMackayIRB = AutoSaveFileServiceMackayIRB.getInstance(
    bleRepository,
    mackayIRBRepository,
  );

  // debugPrint("backgroundWorkService: ${backgroundWorkService.isRunning}");

  GlobalVariables.init(
    initTimeStamp: initTimeStamp,
    sharedPreferences: sharedPreferences!,
    bleRepository: bleRepository,
    mackayIRBRepository: mackayIRBRepository,
    bleMackayIRBService: bleMackayIRBService,
    autoSaveFileServiceMackayIRB: autoSaveFileServiceMackayIRB,
    bleSelectedAutoReconnectService: bleSelectedAutoReconnectService,
    bleSelectedAutoReadRSSIService: bleSelectedAutoReadRSSIService,
    // bleAutoReadRSSIService: bleAutoReadRSSIService,
    backgroundProcessor: backgroundProcessor,
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
      home: const MackayIRBHomeScreen(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}