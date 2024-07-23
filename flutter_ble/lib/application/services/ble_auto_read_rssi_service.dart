import 'dart:async';

import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/services/ble_selected_auto_read_rssi_service.dart';

class BLEAutoReadRSSIService {
  BLERepository bleRepository;
  late StreamSubscription<BLEDevice> _onNewDeviceFounded;
  BLESelectedAutoReadRSSIService bleSelectedAutoReadRSSIService;
  BLEAutoReadRSSIService._({
    required this.bleRepository,
    required this.bleSelectedAutoReadRSSIService,
  }) {
    _onNewDeviceFounded = bleRepository.onNewDeviceFounded((result) {
      bleSelectedAutoReadRSSIService.addWantedRead(result);
    });
  }
  static BLEAutoReadRSSIService? _instance;
  static BLEAutoReadRSSIService getInstance({
    required BLERepository bleRepository,
    required BLESelectedAutoReadRSSIService bleSelectedAutoReadRSSIService,
  }) {
    _instance ??= BLEAutoReadRSSIService._(
      bleRepository: bleRepository,
      bleSelectedAutoReadRSSIService: bleSelectedAutoReadRSSIService,
    );
    return _instance!;
  }
}