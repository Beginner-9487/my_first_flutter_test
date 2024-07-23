import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/domain/ble_repository_impl_fbp.dart';
import 'package:flutter_ble/application/domain/ble_repository_impl_fbp_true_with_fake.dart';
import 'package:flutter_ble/application/services/ble_auto_read_rssi_service.dart';
import 'package:flutter_ble/application/services/ble_auto_reconnect_service.dart';
import 'package:flutter_ble/application/services/ble_selected_auto_read_rssi_service.dart';
import 'package:flutter_ble/application/services/ble_selected_auto_reconnect_service.dart';

class BLEGlobal {
  static const READ_RSSI_RATE = 500;

  late BLERepository bleRepository;
  late BLESelectedAutoReconnectService bleSelectedAutoReconnectService;
  late BLESelectedAutoReadRSSIService bleSelectedAutoReadRSSIService;
  late BLEAutoReconnectService bleAutoReconnectService;
  late BLEAutoReadRSSIService bleAutoReadRSSIService;

  static late BLEGlobal instance;
  BLEGlobal._();

  /// ==========================================================================
  /// Mackay IRB
  factory BLEGlobal.init({
    required BLERepository bleRepository,
    required BLESelectedAutoReconnectService bleSelectedAutoReconnectService,
    required BLESelectedAutoReadRSSIService bleSelectedAutoReadRSSIService,
    required BLEAutoReadRSSIService bleAutoReadRSSIService,
  }) {
    instance = BLEGlobal._();
    instance.bleRepository = bleRepository;
    instance.bleSelectedAutoReconnectService = bleSelectedAutoReconnectService;
    instance.bleSelectedAutoReadRSSIService = bleSelectedAutoReadRSSIService;
    instance.bleAutoReadRSSIService = bleAutoReadRSSIService;
    instance._bleRepositoryImplFBPTrueWithFake = BLERepositoryImplFBPTrueWithFake.getInstance(
        bleRepository as BLERepositoryImplFBP,
    );
    return instance;
  }

  late BLERepositoryImplFBPTrueWithFake _bleRepositoryImplFBPTrueWithFake;
}