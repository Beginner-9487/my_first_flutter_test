import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bt/bt.dart';
import 'package:flutter_bt/flutter_blue_plus/bt_provider_impl_fbp.dart';
import 'package:flutter_customize_bloc/bloc_observer.dart';

import 'package:test_ble/presentation/screen/home_screen.dart';
import 'package:test_ble/resources/app_theme.dart';

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

late BT_Provider provider;
late Timer _readingRssi;

initBLEGlobal() async {
  debugPrint("initBLEGlobal");

  provider = BT_Provider_Impl_FBP.init();
  _readingRssi = Timer.periodic(const Duration(milliseconds: 100), (timer) {
    for (var element in provider.devices) {
      element.fetchRssi();
    }
  });
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