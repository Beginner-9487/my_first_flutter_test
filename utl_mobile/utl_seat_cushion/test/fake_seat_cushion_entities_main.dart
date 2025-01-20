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
import 'package:utl_seat_cushion/resources/application_resources.dart';

import 'data/fake_data_generator.dart';
import 'fake_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FakeInitializer fakeInitializer = FakeInitializer();
  await fakeInitializer();
  SeatCushionDevicesDataHandler seatCushionDevicesDataHandler = ApplicationResources.seatCushionDevicesDataHandler;
  FakeDataGenerator().startGenerateFakeSeatCushionEntities(fakeInitializer: fakeInitializer);
  runApp(const MyApp());
}
