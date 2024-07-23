import 'package:flutter_background_processor/application/infrastructure/background_processor.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/services/ble_auto_read_rssi_service.dart';
import 'package:flutter_ble/application/services/ble_selected_auto_read_rssi_service.dart';
import 'package:flutter_ble/application/services/ble_selected_auto_reconnect_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utl_amulet/application/domain/amulet_repository.dart';
import 'package:utl_amulet/application/services/auto_save_file_service_amulet.dart';
import 'package:utl_amulet/application/services/ble_amulet_service.dart';

class GlobalVariables {
  late DateTime initTimeStamp;

  late SharedPreferences sharedPreferences;

  late BackgroundProcessor backgroundProcessor;

  late BLERepository bleRepository;

  late BLESelectedAutoReconnectService bleSelectedAutoReconnectService;
  late BLESelectedAutoReadRSSIService bleSelectedAutoReadRSSIService;
  late BLEAutoReadRSSIService bleAutoReadRSSIService;

  late AmuletRepository amuletRepository;
  late BLEAmuletService bleAmuletService;
  late AutoSaveFileServiceAmulet autoSaveFileServiceAmulet;

  static late GlobalVariables instance;
  GlobalVariables._();

  /// ==========================================================================
  /// Amulet
  factory GlobalVariables.initAmulet({
    required SharedPreferences sharedPreferences,
    required BLERepository bleRepository,
    required BLESelectedAutoReconnectService bleSelectedAutoReconnectService,
    required BLESelectedAutoReadRSSIService bleSelectedAutoReadRSSIService,
    required BLEAutoReadRSSIService bleAutoReadRSSIService,
    required BackgroundProcessor backgroundProcessor,
    required AmuletRepository amuletRepository,
    required BLEAmuletService bleAmuletService,
    required AutoSaveFileServiceAmulet autoSaveFileServiceAmulet,
    required DateTime initTimeStamp,
  }) {
    instance = GlobalVariables._();
    instance.sharedPreferences = sharedPreferences;
    instance.bleRepository = bleRepository;
    instance.bleSelectedAutoReconnectService = bleSelectedAutoReconnectService;
    instance.bleSelectedAutoReadRSSIService = bleSelectedAutoReadRSSIService;
    instance.bleAutoReadRSSIService = bleAutoReadRSSIService;
    instance.backgroundProcessor = backgroundProcessor;
    instance.amuletRepository = amuletRepository;
    instance.bleAmuletService = bleAmuletService;
    instance.autoSaveFileServiceAmulet = autoSaveFileServiceAmulet;
    instance.initTimeStamp = initTimeStamp;
    return instance;
  }
}