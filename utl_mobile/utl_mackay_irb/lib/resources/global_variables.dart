import 'package:flutter_background_processor/application/infrastructure/background_processor.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/services/ble_auto_read_rssi_service.dart';
import 'package:flutter_ble/application/services/ble_selected_auto_read_rssi_service.dart';
import 'package:flutter_ble/application/services/ble_selected_auto_reconnect_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_repository.dart';
import 'package:utl_mackay_irb/application/services/auto_save_file_service_mackay_irb.dart';
import 'package:utl_mackay_irb/application/services/ble_mackay_irb_data_setter.dart';
import 'package:utl_mackay_irb/application/services/ble_mackay_irb_data_setter_impl.dart';

class GlobalVariables {
  late DateTime initTimeStamp;

  late SharedPreferences sharedPreferences;

  late BackgroundProcessor backgroundProcessor;

  late BLERepository bleRepository;

  late BLESelectedAutoReconnectService bleSelectedAutoReconnectService;
  late BLESelectedAutoReadRSSIService bleSelectedAutoReadRSSIService;
  // late BLEAutoReadRSSIService bleAutoReadRSSIService;

  late MackayIRBRepository mackayIRBRepository;
  late BLEMackayIRBDataSetter bleMackayIRBDataSetter;
  late AutoSaveFileServiceMackayIRB autoSaveFileServiceMackayIRB;

  static late GlobalVariables instance;
  GlobalVariables._();

  /// ==========================================================================
  /// Mackay IRB
  factory GlobalVariables.init({
    required DateTime initTimeStamp,
    required SharedPreferences sharedPreferences,
    required BLERepository bleRepository,
    required MackayIRBRepository mackayIRBRepository,
    required BLEMackayIRBDataSetter bleMackayIRBDataSetter,
    required AutoSaveFileServiceMackayIRB autoSaveFileServiceMackayIRB,
    required BLESelectedAutoReconnectService bleSelectedAutoReconnectService,
    required BLESelectedAutoReadRSSIService bleSelectedAutoReadRSSIService,
    // required BLEAutoReadRSSIService bleAutoReadRSSIService,
    required BackgroundProcessor backgroundProcessor,
  }) {
    instance = GlobalVariables._();
    instance.initTimeStamp = initTimeStamp;
    instance.sharedPreferences = sharedPreferences;
    instance.bleRepository = bleRepository;
    instance.mackayIRBRepository = mackayIRBRepository;
    instance.bleMackayIRBDataSetter = bleMackayIRBDataSetter;
    instance.autoSaveFileServiceMackayIRB = autoSaveFileServiceMackayIRB;
    instance.bleSelectedAutoReconnectService = bleSelectedAutoReconnectService;
    instance.bleSelectedAutoReadRSSIService = bleSelectedAutoReadRSSIService;
    // instance.bleAutoReadRSSIService = bleAutoReadRSSIService;
    instance.backgroundProcessor = backgroundProcessor;
    return instance;
  }
}