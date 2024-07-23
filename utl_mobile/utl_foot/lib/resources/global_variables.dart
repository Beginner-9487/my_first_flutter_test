import 'package:flutter_background_processor/application/infrastructure/background_processor.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/services/ble_selected_auto_reconnect_service.dart';
import 'package:utl_foot/application/domain/foot_repository.dart';
import 'package:utl_foot/application/services/ble_foot_service.dart';

class GlobalVariables {
  late DateTime initTimeStamp;

  late BackgroundProcessor backgroundProcessor;

  late BLERepository bleRepository;

  late FootRepository footRepository;
  late BLEFootService bleFootService;

  late BLESelectedAutoReconnectService bleSelectedAutoReconnectService;

  static late GlobalVariables instance;
  GlobalVariables._();

  /// ==========================================================================
  /// Foot
  factory GlobalVariables.init({
    required BLERepository bleRepository,
    required FootRepository footRepository,
    required BLEFootService bleFootService,
    required BackgroundProcessor backgroundProcessor,
    required BLESelectedAutoReconnectService bleSelectedAutoReconnectService,
    required DateTime initTimeStamp,
  }) {
    instance = GlobalVariables._();
    instance.bleRepository = bleRepository;
    instance.footRepository = footRepository;
    instance.bleFootService = bleFootService;
    instance.backgroundProcessor = backgroundProcessor;
    instance.initTimeStamp = initTimeStamp;
    instance.bleSelectedAutoReconnectService = bleSelectedAutoReconnectService;
    return instance;
  }
}