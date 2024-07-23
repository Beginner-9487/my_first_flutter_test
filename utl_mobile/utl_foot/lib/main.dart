import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_processor/application/infrastructure/background_processor.dart';
import 'package:flutter_background_processor/application/infrastructure/background_processor_impl_fft.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/domain/ble_repository_impl_fbp.dart';
import 'package:flutter_ble/application/services/ble_selected_auto_reconnect_service.dart';
import 'package:flutter_util/bloc/bloc_observer.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pytorch_mobile/enums/dtype.dart';
import 'package:utl_foot/application/domain/foot_repository.dart';
import 'package:utl_foot/application/domain/foot_repository_impl.dart';
import 'package:utl_foot/application/services/ble_foot_service.dart';
import 'package:utl_foot/presentation/foot_home_screen.dart';
import 'package:utl_foot/resources/ai_model.dart';
import 'package:utl_foot/resources/app_theme.dart';
import 'package:utl_foot/resources/global_variables.dart';

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
  // Bloc.observer = GlobalBlocObserver();
  await setGlobal();
  runApp(const AppRoot());
}

setGlobal() async {
  await AIModel.init();

  DateTime initTimeStamp = DateTime.now();

  BLERepository bleRepository = BLERepositoryImplFBP.getInstance();
  debugPrint("setGlobal.BLERepositoryImplFBP.getInstance()");

  BackgroundProcessor backgroundProcessor = BackgroundProcessorImplFFT.init(
    startCallback: startCallback,
  );

  FootRepository footRepository = FootRepositoryImpl.getInstance();
  BLEFootService bleFootService = BLEFootService.getInstance(
      bleRepository,
      footRepository,
  );

  BLESelectedAutoReconnectService bleSelectedAutoReconnectService = BLESelectedAutoReconnectService
      .getInstance(bleRepository);

  GlobalVariables.init(
      bleRepository: bleRepository,
      footRepository: footRepository,
      bleFootService: bleFootService,
      backgroundProcessor: backgroundProcessor,
      initTimeStamp: initTimeStamp,
      bleSelectedAutoReconnectService: bleSelectedAutoReconnectService,
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
      home: const FootHomeScreen(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}