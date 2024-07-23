import 'package:flutter_background_processor/application/infrastructure/background_processor.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/domain/ble_repository_impl_fbp.dart';
import 'package:flutter_ble/application/domain/ble_repository_impl_fbp_true_with_fake.dart';
import 'package:flutter_ble/application/services/ble_selected_auto_reconnect_service.dart';
import 'package:utl_leakage/application/domain/leakage_repository.dart';
import 'package:utl_leakage/application/services/ble_packet_to_leakage_repository.dart';

class GlobalVariables {
  late DateTime initTimeStamp;

  late BackgroundProcessor backgroundProcessor;

  late BLERepository bleRepository;

  late BLESelectedAutoReconnectService bleSelectedAutoReconnectService;

  late LeakageRepository leakageRepository;
  late BLEPacketToLeakageRepository blePacketToLeakageRepository;

  static late GlobalVariables instance;
  GlobalVariables._();

  /// ==========================================================================
  /// Foot
  factory GlobalVariables.init({
    required BLERepository bleRepository,
    required BackgroundProcessor backgroundProcessor,
    required BLESelectedAutoReconnectService bleSelectedAutoReconnectService,
    required DateTime initTimeStamp,
    required LeakageRepository leakageRepository,
    required BLEPacketToLeakageRepository blePacketToLeakageRepository,
  }) {
    instance = GlobalVariables._();
    instance.bleRepository = bleRepository;
    instance.backgroundProcessor = backgroundProcessor;
    instance.initTimeStamp = initTimeStamp;
    instance.bleSelectedAutoReconnectService = bleSelectedAutoReconnectService;
    instance.leakageRepository = leakageRepository;
    instance.blePacketToLeakageRepository = blePacketToLeakageRepository;
    instance._bleRepositoryImplFBPTrueWithFake = BLERepositoryImplFBPTrueWithFake.getInstance(bleRepository as BLERepositoryImplFBP);
    return instance;
  }

  late BLERepositoryImplFBPTrueWithFake _bleRepositoryImplFBPTrueWithFake;
}