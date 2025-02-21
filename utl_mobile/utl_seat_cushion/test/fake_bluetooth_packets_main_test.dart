// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utl_seat_cushion/application/seat_cushion_devices_data_handler.dart';

import 'package:utl_seat_cushion/main.dart';
import 'package:utl_seat_cushion/init/application_persist.dart';
import 'package:utl_seat_cushion/init/initializer.dart';

import 'data/fake_data_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Initializer initializer = ConcreteInitializer();
  await initializer();
  SeatCushionDevicesDataHandler seatCushionDevicesDataHandler = ApplicationPersist.seatCushionDevicesDataHandler;
  FakeDataGenerator().startGenerateBluetoothPackets();
  runApp(const MyApp());
}
