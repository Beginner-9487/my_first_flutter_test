import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_util/bloc/bloc_observer.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/domain/ble_repository_impl_fbp.dart';
import 'package:flutter_ble/application/services/ble_auto_read_rssi_service.dart';
import 'package:flutter_ble/application/services/ble_selected_auto_read_rssi_service.dart';
import 'package:flutter_ble/application/services/ble_selected_auto_reconnect_service.dart';
import 'package:test_ble/presentation/screen/home_screen.dart';
import 'package:test_ble/resources/app_theme.dart';
import 'package:test_ble/resources/ble_global.dart';

void main() async {
  await mainInit();
}

mainInit() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Bloc.observer = GlobalBlocObserver();
  await initBLEGlobal();
  runApp(const AppRoot());
}

initBLEGlobal() async {
  debugPrint("initBLEGlobal");

  BLERepository bleRepository = BLERepositoryImplFBP.getInstance();

  BLESelectedAutoReconnectService bleSelectedAutoReconnectService = BLESelectedAutoReconnectService.getInstance(
    bleRepository,
  );

  BLESelectedAutoReadRSSIService bleSelectedAutoReadRSSIService = BLESelectedAutoReadRSSIService.getInstance(
      bleRepository,
      BLEGlobal.READ_RSSI_RATE,
  );

  BLEAutoReadRSSIService bleAutoReadRSSIService = BLEAutoReadRSSIService.getInstance(
    bleRepository: bleRepository,
    bleSelectedAutoReadRSSIService: bleSelectedAutoReadRSSIService,
  );

  BLEGlobal.init(
    bleRepository: bleRepository,
    bleSelectedAutoReconnectService: bleSelectedAutoReconnectService,
    bleSelectedAutoReadRSSIService: bleSelectedAutoReadRSSIService,
    bleAutoReadRSSIService: bleAutoReadRSSIService,
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
      home: const HomeScreen(),
    );
  }
}